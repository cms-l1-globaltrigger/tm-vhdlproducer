
from tmVhdlProducer import *
#from tmVhdlProducer.tmVhdlProducer import TemplateEngine, mkdir_p, ResourceLoader
from tmVhdlProducer.tmVhdlProducer import TemplateEngine, mkdir_p, ResourceLoader,Loader
from tmReporter.tmReporter import getReport
import tmEventSetup
import tmGrammar


## -----------------------------------------------
DIR              = "/afs/cern.ch/user/n/nrad/tm/utm/"
#vhdlTemplateDir  = DIR+"/tmVhdlProducer/templates/"
vhdlTemplateDir  = DIR+"/tmVhdlProducer/jinjaTemplates/"
outputDir        = "/afs/cern.ch/user/n/nrad/tm/utm/tmVhdlProducer/test/vhdltest/"
nModules         = 3
#menu             = tmEventSetup.getTriggerMenu(DIR+'menu.xml')
menu             = tmEventSetup.getTriggerMenu("/afs/cern.ch/user/t/tmatsush/public/tmGui/L1Menu_Point5IntegrationTest_2015_v1.xml")



#loader = ResourceLoader(DIR)
#template = loader.get_source("","gtl_module.vhd.ja")



#t = TemplateEngine(vhdlTemplateDir)
#t.render("testTemplate.ja",{"name":"aa"})

#loader = Loader(vhdlTemplateDir)
#loader.getTemplateDict( templateDict )
#loader.templateDict

producer=VhdlProducer(menu,vhdlTemplateDir,nModules,outputDir)
producer.write()
#producer.makeDirectories()
