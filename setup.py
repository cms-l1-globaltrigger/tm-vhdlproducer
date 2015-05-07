#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Repository path   : $HeadURL: $
# Last committed    : $Revision: $
# Last changed by   : $Author: $
# Last changed date : $Date: $
#

from distutils.core import setup
import glob

setup(
    name = 'tmVhdlProducer',
    version = '0.1.0',
    description = "Trigger Menu VHDL producer for uGT upgrade",
    author = "Bernhard Arnold",
    author_email = "bernhard.arnold@cern.ch",
    url = "https://twiki.cern.ch/twiki/bin/viewauth/CMS/GlobalTriggerUpgradeL1T-uTme",
    package_dir = {'' : 'lib'},
    packages = ['', ],
    data_files = [
        ('shared/tmVhdlReporter/templates', glob.glob('templates/*.vhd')),
    ],
    scripts = [
        'bin/tm-vhdl-producer',
    ],
    provides = ['tmVhdlProducer', ],
)
