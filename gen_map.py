#!/bin/env/python

import argparse
import json
import StringIO

import tmTable


def run(options):
  ### read menu
  menu_data = tmTable.Menu()
  scaleSet = tmTable.Scale()
  extSignalSet = tmTable.ExtSignal()
  message = tmTable.xml2menu(options.menu,
                             menu_data, scaleSet, extSignalSet, False)

  if message:
    print 'error> %s: %s' % (options.menu, message)
    sys.exit(1)

  distribute = options.nmodules > 1
  mapping = {}
  mapping['menu_uuid'] = menu_data.menu['uuid_menu']
  mapping['n_modules'] = int(menu_data.menu['n_modules'])
  mapping['algorithms'] = []

  if distribute:
    mapping['n_modules'] = options.nmodules

  ii = 0
  for algorithm in menu_data.algorithms:
    module = int(algorithm['module_id'])
    if distribute:
      module = ii % options.nmodules
    data = [algorithm['name'], int(algorithm['index']), module]
    mapping['algorithms'].append(data)
    ii+=1
  
  output = StringIO.StringIO()
  import pprint
  pprint.pprint(mapping, stream=output, width=1000)
  text = output.getvalue()
  text = text.replace("'", '"')

  fd = open(options.output, 'wb')
  fd.write(text)


def main():
  out = 'map.json'

  parser = argparse.ArgumentParser()
  parser.add_argument("--menu", dest="menu", type=str, action="store", required=True,
                      help="path to the level1 trigger menu xml file")
  parser.add_argument("--output", dest="output", default=out, type=str, action="store",
                      help="output mapping file name")
  parser.add_argument("--nmodules", dest="nmodules", default=1, type=int, action="store",
                      help="number of modules")
  options = parser.parse_args()
  
  run(options)

if __name__ == "__main__":
  main()

# eof
