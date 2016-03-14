#!/bin/env python

import argparse
import json
import os
import subprocess
import sys
import types

import tmEventSetup
import tmTable
import tmReporter


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




def main():
  pass
if True:
  import logging

  conf = 'logging.conf'
  if os.path.isfile(conf):
    import logging.config
    logging.config.fileConfig(conf)

  logging.addLevelName(10, 'dbg> ')
  logging.addLevelName(20, 'inf> ')
  logging.addLevelName(30, 'war> ')
  logging.addLevelName(40, 'err> ')
  logging.addLevelName(50, 'fat> ')

  logging.info("Reporter")


  utm_root = os.environ.get("UTM_ROOT")
  if not utm_root:
    print "error> Please set UTM_ROOT environmnet variable"
    sys.exit(1)

  #revision = getSvnVersion(utm_root)
  revision = 0

  defaultMenu = "/afs/cern.ch/user/n/nrad/public/utm/L1Menu_CollisionsHeavyIons2015_v4_uGT_v2.xml"
  #defaultOut = os.path.join(utm_root, "tmVhdlProducer/test/reporter")
  defaultOut = os.path.join(utm_root, "/afs/cern.ch/user/n/nrad/www/tm")

  parser = argparse.ArgumentParser()

  parser.add_argument("--menu", dest="menu", default=defaultMenu, type=str, action="store", help="path to the level1 trigger menu xml file")
  #parser.add_argument("--nModules", dest="nModules", default=1, type=int, action="store", help="number of uGT modules")
  #parser.add_argument("--manual_dist", dest="manual_dist", action="store_true", help="manual distribution of algorithms in uGT modules")
  parser.add_argument("--output", dest="outputDir", default=defaultOut, type=str, action="store", help="directory for the Reporter output")
  parser.add_argument("--verbose", dest="verbose", action="store_true", help="prints teplate output")

  options = parser.parse_args()


  ## -----------------------------------------------
  outputDir = options.outputDir

  dest = os.path.realpath(os.path.join(outputDir, 'xml'))
  orig = os.path.dirname(os.path.realpath(options.menu))
  if dest == orig:
    print 'err> %s is in %s directory which will be deleted during the process' % (
      options.menu, dest)
    print '     specify menu not in %s directory' % dest
    sys.exit(1)

  vhdlTemplateDir = os.path.join(utm_root, "tmVhdlProducer/jinjaTemplates")
  verbose = options.verbose
  menu = tmEventSetup.getTriggerMenu(options.menu)
  menu.sw_revision_svn = revision
  menu.uuid_firmware = menu.getFirmwareUuid()

  
  #producer = tmVhdlProducer.VhdlProducer(menu, vhdlTemplateDir, nModules, outputDir, verbose, options.manual_dist)
  #producer.write()

  reporter = tmReporter.Reporter(menu, vhdlTemplateDir, outputDir, verbose)
  reporter.write()


if __name__ == "__main__":
  main()

# eof
