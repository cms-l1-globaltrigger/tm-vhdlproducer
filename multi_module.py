#!/bin/env python

import json
import logging
import os
import shutil
import sys

import tmTable


FMT_MODULE = "/tmp/%s_module%d.xml"
FMT_GLOBAL = "/tmp/%s_ugt_%dboard.xml"


class Object:
  def __init__(self):
    pass


def copytree(src, dst, symlinks=False, ignore=None):
  for item in os.listdir(src):
    s = os.path.join(src, item)
    d = os.path.join(dst, item)
    if os.path.isdir(s):
      shutil.copytree(s, d, symlinks, ignore)
    else:
      shutil.copy2(s, d)


def setTable(source, name, dest):
  logging.debug("setTable: %s" % name)

  for algo, array in source.iteritems():
    if algo != name: continue
    table = tmTable.Table()
    for item in array:
      data = tmTable.Row()
      for key, val in item.iteritems():
        data[key] = val
      table.append(data)
    dest[str(name)] = table


def getSpecification(spec_file):
  logging.info("getSpecification: %s" % spec_file)

  fd = open(spec_file)
  mapping = json.load(fd)

  n_modules = int(mapping["n_modules"])
  if n_modules < 2:
    print 'inf> # of modules = %s, nothing to do' % n_modules
    sys.exit(0)

  return mapping


def copyMenu(source):
  logging.debug("copyMenu:")

  dest = tmTable.Menu()
  for key, val in source.menu.iteritems():
    dest.menu[key] = val
  dest.menu['is_valid'] = "1"
  return dest


def updateIds(menu_data, algorithm, module_menu, ids):
  logging.debug("updateIds: %s : %s" % (algorithm['name'], ids))

  gid, mod, lid = ids
  data = tmTable.Row()
  for key, val in algorithm.iteritems():
    data[key] = val
  data['index'] = "%d" % gid
  data['module_id'] = "%d" % mod
  data['module_index'] = "%d" % lid
  module_menu.algorithms.append(data)

  name = algorithm['name']
  setTable(menu_data.cuts, name, module_menu.cuts)
  setTable(menu_data.objects, name, module_menu.objects)
  setTable(menu_data.externals, name, module_menu.externals)


def splitMenu(menu_file, mapping):
  import operator
  import uuid

  logging.info("splitMenu: %s" % menu_file)

  basename = os.path.splitext(os.path.basename(menu_file))[0]

  ### prepare algorithm distributions
  specification = []
  algorithms = mapping["algorithms"]
  n_modules = mapping["n_modules"]

  for ii in range(n_modules):
    specification.append({})

  for algo in algorithms:
    name, gid, mod = algo
    mod = int(mod)
    if mod >= n_modules:
      print "error> %s: module id [%d] should be smaller than # of modules" % (name, mod)
      sys.exit(1)
    specification[mod].update({name: gid})

  for ii in range(len(specification)):
    if len(specification[ii]) == 0:
      print "error> module %d is empty" % ii
      sys.exit(1)


  ### read menu
  menu_data = tmTable.Menu()
  scaleSet = tmTable.Scale()
  extSignalSet = tmTable.ExtSignal()
  message = tmTable.xml2menu(menu_file,
                             menu_data, scaleSet, extSignalSet, False)

  if message:
    print 'error> %s: %s' % (menu_file, message)
    sys.exit(1)

  ### sanity check
  if menu_data.menu['uuid_menu'] != mapping["menu_uuid"]:
    print 'error> uuid mismatch: menu [%s] != spec [%s]' % (menu_data.menu['uuid_menu'], mapping["menu_uuid"])
    sys.exit(1)

  ### update menu information
  menu_data.menu['uuid_firmware'] = "%s" % uuid.uuid1()
  menu_data.menu['n_modules'] = "%d" % n_modules


  ### split menu per module
  id_map = {}
  for ii in range(len(specification)):
    print "inf> preparing module %d ..." % ii,

    lid = 0
    module_menu = copyMenu(menu_data)
    array = sorted(specification[ii].items(), key=operator.itemgetter(1))

    for name, gid in array:
      for algorithm in menu_data.algorithms:
        if name in algorithm.values():
          id_map[name] = [gid,ii,lid]
          updateIds(menu_data, algorithm, module_menu, id_map[name])
          lid += 1

    tmTable.menu2xml(module_menu, scaleSet, extSignalSet, FMT_MODULE % (basename, ii))
    print lid, " algorithms"

  ### update menu
  path = FMT_GLOBAL % (basename, n_modules)
  print "inf> updating menu: %s" % path

  menu = copyMenu(menu_data)
  array = sorted(id_map.items(), key=operator.itemgetter(1))
  for name, ids in array:
    for algorithm in menu_data.algorithms:
      if name in algorithm.values():
        updateIds(menu_data, algorithm, menu, ids)
  tmTable.menu2xml(menu, scaleSet, extSignalSet, path)


def genVhdl(options):
  import tmEventSetup
  import tmVhdlProducer
 
  ## run vhdl prdocuer
  dest = os.path.realpath(os.path.join(options.outputDir, 'xml'))
  orig = os.path.dirname(os.path.realpath(options.menu))
  if dest == orig:
    print 'error> %s is in %s directory which will be deleted during the process' % (
      options.menu, dest)
    print '     specify menu not in %s directory' % dest
    sys.exit(1)

  vhdlTemplateDir = os.path.join(options.utm_root, "tmVhdlProducer/jinjaTemplates/")

  n_module = 1
  manual_dist = False
  uuid = False

  basename = os.path.splitext(os.path.basename(options.menu))[0]
  basedir = None
  for ii in list(reversed(range(options.n_modules))):
    FMT_MODULE = "/tmp/%s_module%d.xml"
    path = FMT_MODULE % (basename, ii)
    print "inf> processing %s" % path
    menu = tmEventSetup.getTriggerMenu(path)
    menu.sw_revision_svn = options.revision
    producer = tmVhdlProducer.VhdlProducer(menu, vhdlTemplateDir, n_module, options.outputDir, options.verbose, manual_dist, uuid)
    producer.write()

    if ii == 0: continue
    src = os.path.join(producer.directoryDict['vhdl'], "module_0/src/")
    dst = "/tmp/module_%d" % ii
    if not os.path.exists(dst):
      os.makedirs(dst)
    copytree(src, dst)
    basedir = producer.directoryDict['top']


  for ii in range(1, options.n_modules):
    dst = "%s/vhdl/module_%d/src" % (basedir, ii)
    src = "/tmp/module_%d" % ii
    if not os.path.exists(dst):
      os.makedirs(dst)
    copytree(src, dst)
  os.remove("%s/xml/menu.json" % basedir)
  src = FMT_GLOBAL % (basename, options.n_modules)
  shutil.copy(src, "%s/xml" % basedir)


def main():
  import argparse
  import logging

  import vhdlproducer

  conf = 'logging.conf'
  if os.path.isfile(conf):
    import logging.config
    logging.config.fileConfig(conf)

  logging.addLevelName(10, 'dbg')
  logging.addLevelName(20, 'inf')
  logging.addLevelName(30, 'war')
  logging.addLevelName(40, 'err')
  logging.addLevelName(50, 'fat')

  logging.info("VHDL producer with menu split")

  utm_root = os.environ.get("UTM_ROOT")
  if not utm_root:
    print "error> Please set UTM_ROOT environmnet variable"
    sys.exit(1)

  #revision = vhdlproducer.getSvnVersion(utm_root)
  revision = 0
  spec = 'map.json'

  output_dir = os.path.join(utm_root, "tmVhdlProducer/test/vhdltest")

  parser = argparse.ArgumentParser()
  parser.add_argument("--menu", dest="menu", type=str, action="store", required=True,
                      help="path to the level1 trigger menu xml file")
  parser.add_argument("--nModules", dest="nmodules", default=1, type=int, action="store",
                      help="number of modules")
  parser.add_argument("--verbose", dest="verbose", action="store_true",
                      help="prints teplate output")
  parser.add_argument("--spec", default=spec, dest="spec", type=str, action="store",
                      help="specification file of algorithm distribution")
  parser.add_argument("--output", dest="outputDir", default=output_dir, type=str, action="store",
                      help="directory for the VHDL producer output")
  options = parser.parse_args()
  options.revision = revision
  options.utm_root = utm_root

  if options.nmodules != 1:
    import gen_map
    params = Object()
    params.menu = options.menu
    params.nmodules = options.nmodules
    params.output = options.spec
    gen_map.run(params)

  mapping = getSpecification(options.spec)
  options.n_modules = mapping["n_modules"]
  print 'Processing %s: # of modules = %d' % (options.menu, options.n_modules)
  splitMenu(options.menu, mapping)
  genVhdl(options)


if __name__ == "__main__":
  main()

# eof
