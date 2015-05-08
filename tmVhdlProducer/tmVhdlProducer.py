# -*- coding: utf-8 -*-
#
# Repository path   : $HeadURL: $
# Last committed    : $Revision: $
# Last changed by   : $Author: $
# Last changed date : $Date: $
#

from jinja2 import Environment, BaseLoader
import template_rc

__version__ = '0.1.0'
__all__ = ['VhdlProducer', ]

# -----------------------------------------------------------------------------
#  Helpers
# -----------------------------------------------------------------------------

def str2hex(s):
    """Convert a string into hex encoded value. Requires to reverse byte order, then encode."""
    return int(s[::-1].encode("hex"), 16)

def hex2str(i):
    """Convert a hex encoded integer to string. Requires to reverse byte order and stripping pending zeros."""
    return hex(i).decode("hex")[::-1].strip("\x00")

# -----------------------------------------------------------------------------
#  Jinja2 custom filters exposed to VHDL templates.
# -----------------------------------------------------------------------------

def hex_filter(i, chars = None):
    if isinstance(i, str):
        i = int(i, 16) if i.lower().startswith('0x') else int(i, 10)
    return "{0:0{1}X}".format(i, chars)[:chars] if chars else "{0:X}".format(i)

def hexstr_filter(s, chars = None):
    return "{0:0{1}}".format(str2hex(s), chars)[:chars] if chars else "{0}".format(str2hex(s))

def uuid2hex_filter(s):
    return uuid.UUID(s).hex.upper()

# -----------------------------------------------------------------------------
#  Custom resource loader.
# -----------------------------------------------------------------------------

class ResourceLoader(BaseLoader):
    """Loads a template from python module resource compiled with tplrcc.

    See also http://jinja.pocoo.org/docs/dev/api/#jinja2.BaseLoader
    """

    def get_source(self, environment, template):
        try:
            return template_rc.rcload(template), None, lambda: True
        except KeyError:
            raise TemplateNotFound(template)

# -----------------------------------------------------------------------------
#  Template engines with custom resource loader environment.
# -----------------------------------------------------------------------------

class TemplateEngine(object):

    def __init__(self):
        # Create Jinja environment.
        self.environment = Environment(loader = ResourceLoader())

        # Adding filters.
        self.environment.filters['hex'] = hex_filter
        self.environment.filters['hexstr'] = hexstr_filter
        self.environment.filters['uuid'] = uuid_filter
        self.environment.filters['bool'] = lambda b: ('false', 'true')[bool(b)]

    def render(self, template, data = {}):
        template = self.environment.get_template(template)
        return template.render(data)

# -----------------------------------------------------------------------------
#  VHDL producer class.
# -----------------------------------------------------------------------------

class VhdlProducer(object):
    """VHDL producer class."""

    def __init__(self):
        pass

    def write(self):
        pass
