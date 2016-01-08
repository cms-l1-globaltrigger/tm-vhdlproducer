#!/bin/env python

import argparse
import json
import os
import subprocess
import sys
import types

import tmEventSetup
import tmTable
import tmVhdlProducer


def getSvnVersion(root):
  cwd = os.getcwd()

  os.chdir(root)
  process = subprocess.Popen('svnversion', stdout=subprocess.PIPE)
  revision = process.stdout.readlines()[0].strip()
  revision = revision.split(':')[-1]
  try:
    int(revision)
  except ValueError:
    print "error> The utm library seems locally modified. Please check-in the changes and try again. [Revision=%s]" % revision
    sys.exit(1)

  revision = int(revision)

  os.chdir(cwd)
  return revision


def updateMenu(menu_path, json_dir, nModules):
  json_path = os.path.join(json_dir, "menu.json")
  json_data = None
  with open(json_path) as fp:
    json_data = json.load(fp)


  menu = tmTable.Menu()
  scale = tmTable.Scale()
  ext_signal = tmTable.ExtSignal()


  msg = tmTable.xml2menu(menu_path, menu, scale, ext_signal, False)
  if msg:
    print 'err> %s: %s' % (menu_path,  msg)
    sys.exit(1)

  print "inf> processing %s ... " % menu.menu["name"]

  menu.menu["uuid_menu"] = str(json_data["menu_uuid"])
  menu.menu["uuid_firmware"] = str(json_data["firmware_uuid"])
  menu.menu["n_modules"] = str(json_data["n_modules"])
  menu.menu["is_valid"] = "1"


  names = []
  for algorithm in menu.algorithms:
    names.append(algorithm["name"])

  for name, index, module_id, module_index in json_data["algorithms"]:
    algorithm = tmTable.Row()
    id = names.index(name)
    for k, v in menu.algorithms[id].iteritems():
      algorithm[k] = v
    algorithm["index"] = str(index)
    algorithm["module_id"] = str(module_id)
    algorithm["module_index"] = str(module_index)
    menu.algorithms[id] = algorithm

  output = os.path.join(json_dir, os.path.basename(menu_path))
  base, ext = os.path.splitext(output)
  tmTable.menu2xml(menu, scale, ext_signal, '%s_ugt_%sboard%s' % (base, nModules, ext))


def main():
  import logging

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


  utm_root = os.environ.get("UTM_ROOT")
  if not utm_root:
    print "error> Please set UTM_ROOT environmnet variable"
    sys.exit(1)

  revision = getSvnVersion(utm_root)

  defaultMenu = "/afs/cern.ch/user/t/tmatsush/public/tmGui/L1Menu_Collisions2015_25nsStage1_v6_uGT_v2.xml"
  defaultOut = os.path.join(utm_root, "tmVhdlProducer/test/vhdltest")

  parser = argparse.ArgumentParser()

  parser.add_argument("--menu", dest="menu", default=defaultMenu, type=str, action="store", help="path to the level1 trigger menu xml file")
  parser.add_argument("--nModules", dest="nModules", default=1, type=int, action="store", help="number of uGT modules")
  parser.add_argument("--manual_dist", dest="manual_dist", action="store_true", help="manual distribution of algorithms in uGT modules")
  parser.add_argument("--output", dest="outputDir", default=defaultOut, type=str, action="store", help="directory for the VHDL producer output")
  parser.add_argument("--verbose", dest="verbose", action="store_true", help="prints teplate output")

  options = parser.parse_args()


  ## -----------------------------------------------
  outputDir = options.outputDir
  vhdlTemplateDir = os.path.join(utm_root, "tmVhdlProducer/jinjaTemplates/")
  nModules = options.nModules
  verbose = options.verbose
  menu = tmEventSetup.getTriggerMenu(options.menu)


  producer = tmVhdlProducer.VhdlProducer(menu, vhdlTemplateDir, nModules, outputDir, verbose, options.manual_dist)
  producer.write()

  updateMenu(options.menu, os.path.join(outputDir, 'xml'), nModules)

if __name__ == "__main__":
  main()

# eof
