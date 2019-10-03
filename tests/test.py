#!/bin/env python

import argparse
import logging
import os

import tmVhdlProducer
import tmEventSetup


conf = 'logging.conf'
if os.path.isfile(conf):
  import logging.config
  logging.config.fileConfig(conf)

def main():
    logging.addLevelName(10, 'dbg')
    logging.addLevelName(20, 'inf')
    logging.addLevelName(30, 'war')
    logging.addLevelName(40, 'err')
    logging.addLevelName(50, 'fat')

    logging.info("VHDL producer")


    BASE_DIR = os.environ["UTM_ROOT"]
    defaultMenu = "/afs/cern.ch/user/t/tmatsush/public/tmGui/L1Menu_Collisions2015_25nsStage1_v6_uGT_v2.xml"

    parser = argparse.ArgumentParser()

    parser.add_argument("--menu", dest="menu", default=defaultMenu, type=str, action="store", help="path to the level1 trigger menu xml file")
    parser.add_argument("--nModules", dest="nModules", default=1, type=int, action="store", help="number of uGT modules")
    parser.add_argument("--manual_dist", dest="manual_dist", action="store_true", help="manual distribution of algorithms in uGT modules")
    parser.add_argument("--output", dest="outputDir", default=BASE_DIR+"/tmVhdlProducer/test/vhdltest/", type=str, action="store", help="directory for the VHDL producer output")
    parser.add_argument("--verbose", dest="verbose", action="store_true", help="prints template output")

    options = parser.parse_args()


    ## -----------------------------------------------
    outputDir = options.outputDir
    vhdlTemplateDir = BASE_DIR+"/tmVhdlProducer/templates/"
    nModules = options.nModules
    verbose = options.verbose
    menu = tmEventSetup.getTriggerMenu(options.menu)


    producer = tmVhdlProducer.VhdlProducer(menu, vhdlTemplateDir, nModules, outputDir, verbose, options.manual_dist)
    producer.write()

if __name__ == '__main__':
    main()
