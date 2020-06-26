import json
import shutil
import logging
import uuid
import os, errno

from jinja2 import Environment, FileSystemLoader, filters, StrictUndefined
from os.path import join, exists, basename
from itertools import cycle
from binascii import hexlify

import tmEventSetup
import tmTable

from . import vhdlhelper
from . import algodist

from tmVhdlProducer import __version__
__all__ = ['VhdlProducer', 'writeXmlMenu']

# -----------------------------------------------------------------------------
#  Jinja2 custom filters exposed to VHDL templates.
# -----------------------------------------------------------------------------

def hexstr_filter(s, bytes):
    """Converts a string into hex representation.

    >>> hexstr_filter("Monty Python's Flying Circus", 32)
    '0000000073756372694320676e69796c462073276e6f687479502079746e6f4d'
    """
    chars = bytes * 2
    return "{0:0>{1}}".format(hexlify(s[::-1].encode()).decode(), chars)[-chars:]

def uuid2hex_filter(s):
    """Converts a UUID into hex representation.

    >>> uuid2hex_filter('1d69f777-ade0-4fb7-82f7-2b9afbba4078')
    '1d69f777ade04fb782f72b9afbba4078'
    """
    return uuid.UUID(s).hex.lower()

def bx_encode(value):
    """Encode relative bunch crossings into VHDL notation.

    All positive values with the exception of zero are prefixed with m, all
    negative values are prefixed with p instead of the minus sign.

    >>> bx_encode(0)
    '0'
    >>> bx_encode(-1)
    'm1'
    >>> bx_encode(2)
    'p2'
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

def murmurhash(s):
    """Returns Murmurhash signed integer."""
    return tmEventSetup.getMmHashN(str(s))

# -----------------------------------------------------------------------------
#  Constants
# -----------------------------------------------------------------------------

CustomFilters = {
    'X21' : lambda x: "%021X" % int(float(x)),
    'X16' : lambda x: "%016X" % int(float(x)),
    'X08' : lambda x: "%08X" % int(float(x)),
    'X04' : lambda x: "%04X" % int(float(x)),
    'X01' : lambda x: "%01X" % int(float(x)),
    'alpha' : lambda s: ''.join(c for c in s if c.isalpha()),
    'bx_offset': bx_encode,
    'sort_by_attribute': sort_by_attribute,
    'hex': lambda d: format(int(d), 'x'), # plain hex format
    'hexstr': hexstr_filter,
    'hexuuid': uuid2hex_filter,
    'vhdl_bool': lambda b: ('false', 'true')[bool(b)],
    'mmhashn': murmurhash,
}

ModuleTemplates = [
    'algo_index.vhd',
    'gtl_module_signals.vhd',
    'gtl_module_instances.vhd',
    'ugt_constants.vhd',
]

# -----------------------------------------------------------------------------
# Additional Helpers
# -----------------------------------------------------------------------------

def makedirs(path):
    """Creates a directory recusively, ignores it if the path already exists."""
    logging.debug("creating directory: %s", path)
    if not os.path.exists(path):
        os.makedirs(path)

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

    def __init__(self, searchpath):
        self.VHDLProducerVersion = __all__[0]+__version__
        self.engine = TemplateEngine(searchpath)

    def create_dirs(self, directory, n_modules):
        """Create directory tree for output."""
        directories = {
            "vhdl" : os.path.join(directory, "vhdl"),
            "testvectors" : os.path.join(directory, "testvectors"),
            "xml" : os.path.join(directory, "xml"),
            "doc" : os.path.join(directory, "doc"),
        }
        for i in range(n_modules):
            module_id = "module_{i}".format(i=i)
            directories[module_id] = os.path.join(directories['vhdl'], module_id, "src")
        # Check for exisiting directories (TODO obsolete?)
        for directory in directories:
            if os.path.exists(directory):
                logging.warning("directory `%s' already exists. Will be overwritten.", directory)
                shutil.rmtree(directory)
        # Create directries
        for directory in directories:
            makedirs(directories[directory])
        return directories

    def write(self, collection, directory):
        """Write distributed modules (VHDL templates) to *directory*."""

        helper = vhdlhelper.MenuHelper(collection)
        logging.info("writing %s algorithms to %s module(s)", len(helper.algorithms), len(helper.modules))
        # Create directory tree
        directories = self.create_dirs(directory, len(collection))
        # Populate modules
        for module in helper.modules:
            logging.info("writing output for module: %s", module.id)
            for template in ModuleTemplates:
                params = {
                    'menu': helper,
                    'module': module,
                }
                content = self.engine.render(template, params)
                module_id = "module_{id}".format(id=module.id)
                filename = os.path.join(directories[module_id], template)
                with open(filename, 'w') as fp:
                    fp.write(content)
                logging.info("{template:<24}: {filename}".format(**locals()))

        # Write JSON dump (TODO obsolete?)
        params = {
            'menu': helper,
        }
        content = self.engine.render('menu.json', params)
        filename = os.path.join(directories['xml'], 'menu.json')
        makedirs(os.path.dirname(filename)) # Create path if required
        with open(filename, 'w') as fp:
            fp.write(content)

    def writeXmlMenu(self, filename, json_dir, dist=1):
        """Updates a XML menu file based on inforamtion from a JSON file (used to apply
        a previously calculated algorithm distribution over multiple modules).
        Returns path and filename of created XML menu.
        """
        # TODO
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
            id_ = names.index(name)
            # Copy attributes
            for k, v in menu.algorithms[id_].items():
                algorithm[k] = v
            # Update attributes
            algorithm["index"] = str(index)
            algorithm["module_id"] = str(module_id)
            algorithm["module_index"] = str(module_index)
            menu.algorithms[id_] = algorithm

        target = os.path.join(json_dir, '{name}-d{dist}.xml'.format(name=menu.menu['name'], dist=dist))

        logging.info("writing target XML menu file %s", target)
        tmTable.menu2xml(menu, scale, ext_signal, target)

        return target


# eof
