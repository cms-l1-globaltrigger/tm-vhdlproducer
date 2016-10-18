# -*- coding: utf-8 -*-
#
# Repository path   : $HeadURL: $
# Last committed    : $Revision: $
# Last changed by   : $Author: $
# Last changed date : $Date: $
#

from jinja2 import Environment, FileSystemLoader, filters, StrictUndefined
from os.path import join, exists, basename
from itertools import cycle
from binascii import hexlify

import os, errno
import json
import shutil
import logging
import uuid

import tmEventSetup
import tmTable
import vhdlhelper
import algodist

from tmVhdlProducer import __version__
__all__ = ['VhdlProducer', 'writeXmlMenu', 'getMenuUuid']

# -----------------------------------------------------------------------------
#  Jinja2 custom filters exposed to VHDL templates.
# -----------------------------------------------------------------------------

def hexstr_filter(s, bytes):
    chars = bytes * 2
    return "{0:0>{1}}".format(hexlify(s[::-1]), chars)[-chars:]

def uuid2hex_filter(s):
    return uuid.UUID(s).hex.lower()

def bx_encode(value):
    """Encode relative bunch crossings into VHDL notation.
    All positive values with the exception of zero are prefixed with m, all
    negative values are prefixed with p instead of the minus sign.
    """
    # Prefix positive values greater then zero with p.
    if value > 0:
        return 'p{0:d}'.format(value)
    # Prefix negative values with m instead of minus sign (abs).
    if value < 0:
        return 'm{0:d}'.format(abs(value))
    # Zero value is not prefixed according to VHDL documentation.
    return '0'

def sort_by_attribute(items, attribute, reverse=False):
    """Returns list of items sorted by attribute. Provided to overcome lack of
    sort filter in older Jinja2 versions.
    """
    return sorted(items, key=lambda item: getattr(item, attribute), reverse=reverse)

def signed(value, bits=32):
    """Returns signed integer with *bits* with."""
    mask = (2 ** bits) - 1
    if value & (1 << (bits - 1)):
        return value | ~mask
    return value & mask

def murmurhash(s, bits=32):
    """Returns Murmurhash signed integer."""
    return signed(tmEventSetup.getMmHashN(str(s)), bits)

# -----------------------------------------------------------------------------
#  Constants
# -----------------------------------------------------------------------------

CustomFilters = {
    'X04' : lambda x: "%04X" % int(float(x)),
    'X01' : lambda x: "%01X" % int(float(x)),
    'alpha' : lambda s: ''.join(c for c in s if c.isalpha()),
    'bx_offset': bx_encode,
    'sort_by_attribute': sort_by_attribute,
    'hexstr': hexstr_filter,
    'hexuuid': uuid2hex_filter,
    'vhdl_bool': lambda b: ('false', 'true')[bool(b)],
    'mmhashn': murmurhash,
}

# HB 2016-09-29: used new files, to contains of the files are inserted in "algo_mapping_rop_tpl.vhd", "gtl_module_tpl.vhd" and "gtl_pkg_tpl.vhd"
# HB 2016-10-11: used gtl_module, algo_mapping_rop and gtl_pkg for "Ion run 2016"
UsedTemplates = [
    #'algo_index.vhd',
    #'gtl_module_signals.vhd',
    #'gtl_module_instances.vhd',
    #'ugt_constants.vhd',
    'gtl_module.vhd',
    #'ugt_constant_pkg.vhd',
    'algo_mapping_rop.vhd',
    'gtl_pkg.vhd',
    'menu.json',
]

# -----------------------------------------------------------------------------
# Additional Helpers
# -----------------------------------------------------------------------------

def mkdir_p(path):
    """Equivalent to bash's `mkdir -p' command. Creates a directory recusively
    and ignores it if the path already exists."""
    try:
        os.makedirs(path)
    except OSError as exc: # Python >2.5
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass # ignore existing dir...

def loadMenu(filename):
    """Load XML menu using tmTables."""
    import tmTable
    menu = tmTable.Menu()
    scale = tmTable.Scale()
    ext_signal = tmTable.ExtSignal()
    message = tmTable.xml2menu(filename, menu, scale, ext_signal, False)
    if message:
        logging.error("{filename}: {message}".format(message))
        raise RuntimeError(message)
    return menu

def getMenuUuid(filename):
    menu = loadMenu(filename)
    return menu.menu["uuid_menu"]

def writeXmlMenu(filename, json_dir):
    """Updates a XML menu file based on inforamtion from a JSON file (used to apply
    a previously calculated algorithm distribution over multiple modules).
    """
    # Load mapping from JSON
    with open(os.path.join(json_dir, 'menu.json')) as fp:
        json_data = json.load(fp)

    menu = tmTable.Menu()
    scale = tmTable.Scale()
    ext_signal = tmTable.ExtSignal()

    logging.info("reading source XML menu file %s", filename)

    message = tmTable.xml2menu(filename, menu, scale, ext_signal, False)
    if message:
        logging.error("{filename}: {message}".format(message))
        raise RuntimeError(message)

    logging.info("processing menu \"%s\" ... ", menu.menu["name"])

    # Update menu information
    logging.info("updating menu information...")
    logging.info("uuid_menu     : %s", json_data["menu_uuid"])
    logging.info("uuid_firmware : %s", json_data["firmware_uuid"])
    logging.info("n_modules     : %s", json_data["n_modules"])

    # Update menu information
    menu.menu["uuid_menu"] = str(json_data["menu_uuid"])
    menu.menu["uuid_firmware"] = str(json_data["firmware_uuid"])
    menu.menu["n_modules"] = str(json_data["n_modules"])
    menu.menu["is_valid"] = "1"

    # Collect algorithm names
    names = [algorithm["name"] for algorithm in menu.algorithms]

    # Update algorithm
    for name, index, module_id, module_index in json_data["algorithms"]:
        algorithm = tmTable.Row()
        id = names.index(name)
        for k, v in menu.algorithms[id].iteritems():
            algorithm[k] = v
        algorithm["index"] = str(index)
        algorithm["module_id"] = str(module_id)
        algorithm["module_index"] = str(module_index)
        menu.algorithms[id] = algorithm

    target = os.path.join(json_dir, '{name}_m{n}.xml'.format(name=menu.menu['name'], n=menu.menu["n_modules"]))

    logging.info("writing target XML menu file %s", target)
    tmTable.menu2xml(menu, scale, ext_signal, target)

# -----------------------------------------------------------------------------
#  Template engines with custom loader environment.
# -----------------------------------------------------------------------------

class TemplateEngine(object):
    """Custom tempalte engine class."""

    def __init__(self, searchpath, encoding='utf-8'):
        # Create Jinja environment.
        loader = FileSystemLoader(searchpath, encoding)
        self.environment = Environment(loader=loader, undefined=StrictUndefined)
        self.environment.filters.update(CustomFilters)

    def render(self, template, data={}):
        template = self.environment.get_template(template)
        return template.render(data)

# -----------------------------------------------------------------------------
#  VHDL producer class.
# -----------------------------------------------------------------------------

class VhdlProducer(object):
    """VHDL producer class."""

    def __init__(self, searchpath, verbose=False):
        self.verbose = verbose
        self.VHDLProducerVersion = __all__[0]+__version__
        self.engine = TemplateEngine(searchpath)
        self.directoryDict = {}

    def create_dirs(self, directory, n_modules):
        """Create directory tree for output."""
        vhdlDir = os.path.join(directory, "vhdl")
        self.directoryDict = {
            "top" : directory,
            "vhdl" : vhdlDir,
            "testvectors" : os.path.join(directory, "testvectors"),
            "xml" : os.path.join(directory, "xml"),
        }
        for i in range(n_modules):
            self.directoryDict["module_%s" % i] = os.path.join(vhdlDir, "module_%s/src/" % i)
        if os.path.exists(self.directoryDict['vhdl']):
            logging.warning("diectory `%s' already exists. Will be replaced.", self.directoryDict['vhdl'])
            shutil.rmtree(self.directoryDict['vhdl'])
        if os.path.exists(self.directoryDict['xml']):
            logging.warning("directory `%s' already exists. Will be replaced.", self.directoryDict['xml'])
            shutil.rmtree(self.directoryDict['xml'])

        for directory in self.directoryDict:
            mkdir_p(self.directoryDict[directory])
            if self.verbose:
                logging.info("created directory %s", self.directoryDict[directory])

    def write(self, collection, directory):
        """Write distributed modules (VHDL templates) to *directory*."""

        helper = vhdlhelper.MenuHelper(collection)
        logging.info("writing %s algorithms to %s module(s)", len(helper.algorithms), len(helper.modules))
        ## Loop over algos and insert them in each module.
        self.create_dirs(directory, len(collection)) # TODO still obfuscated init of self.directoryDict

        writeJson = True # TODO
        for module in helper.modules:
            logging.info("writing template output:")
            for template in UsedTemplates:
                if template.endswith('.json'): # HACK use rather collection.dump(...)
                    if not writeJson: continue
                    writeJson = False
                    filename = os.path.join(self.directoryDict["xml"], template)
                else:
                    filename = os.path.join(self.directoryDict["module_%s" % (module.id)], "%s" % template )
                params = {"menu": helper, 'module': module, }
                content = self.engine.render(template, params)
                with open(filename, 'a') as fp:
                    fp.write(content)
                logging.info("{template:<24}: {filename}".format(**locals()))

# eof
