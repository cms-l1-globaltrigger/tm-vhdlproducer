#!/bin/env python

import json
import sys

import tmTable


menu_path = 'L1Menu_Collisions2015_25nsStage1_v6_uGT_v2.xml'
json_path = 'menu.json'


json_data = None
with open(json_path) as fp:
  json_data = json.load(fp)


menu = tmTable.Menu()
scale = tmTable.Scale()
ext_signal = tmTable.ExtSignal()


msg = tmTable.xml2menu(menu_path, menu, scale, ext_signal, False)
if msg:
  print 'err> ', msg
  sys.exit(1)

print menu.menu["name"]

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

tmTable.menu2xml(menu, scale, ext_signal, 'menu.xml')

# end
