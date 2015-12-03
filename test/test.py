#!/bin/env python

import logging
import os

import tmVhdlProducer
import tmEventSetup
import tmGrammar


conf = 'logging.conf'
if os.path.isfile(conf):
  import logging.config
  logging.config.fileConfig(conf)

logging.addLevelName(10, 'dbg')
logging.addLevelName(20, 'inf')
logging.addLevelName(30, 'war')
logging.addLevelName(40, 'err')
logging.addLevelName(50, 'fat')

logging.info("VHDL producer")


DIR              = os.environ["UTM_ROOT"]
defaultMenu      = "/afs/cern.ch/user/t/tmatsush/public/tmGui/L1Menu_Collisions2015_25nsStage1_v6_uGT_v2.xml"

from optparse import OptionParser
parser = OptionParser()
parser.add_option("--menu",     dest="menu",      default=defaultMenu,       type="string",  action="store",     help="path to the xml trigger menu")
parser.add_option("--nModules", dest="nModules",  default=1,      type="int",     action="store",     help="Number of Modules")
parser.add_option("--manual_dist", dest="manual_dist",  action="store_true",     help="Manual distribution of  Algos in Modules")
parser.add_option("--output",   dest="outputDir", default=DIR+"/tmVhdlProducer/test/vhdltest/" ,      type="string", action="store", help="directory for the VHDL producer output")
parser.add_option("--verbose",   dest="verbose", action="store_true", help="prints template output")

(options, args) = parser.parse_args()


## -----------------------------------------------
outputDir        = options.outputDir
vhdlTemplateDir  = DIR+"/tmVhdlProducer/jinjaTemplates/"
nModules         = options.nModules
verbose          = options.verbose
menu             = tmEventSetup.getTriggerMenu(options.menu)


producer=tmVhdlProducer.VhdlProducer(menu,vhdlTemplateDir,nModules,outputDir,verbose,options.manual_dist)
producer.write()

# eof
