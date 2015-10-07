
from tmVhdlProducer import *
#from tmVhdlProducer.tmVhdlProducer import TemplateEngine, mkdir_p, ResourceLoader
from tmVhdlProducer.tmVhdlProducer import TemplateEngine, mkdir_p, ResourceLoader,Loader
from tmReporter.tmReporter import getReport
import tmEventSetup
import tmGrammar
import os


DIR              = os.environ["UTM_ROOT"]
defaultMenu      = "/afs/cern.ch/user/t/tmatsush/public/tmGui/L1Menu_Collisions2015_25nsStage1_v6_uGT_v2.xml"
                   #"/afs/cern.ch/user/t/tmatsush/public/tmGui/L1Menu_Collisions2015_25nsStage1_v6_uGT.xml"
                   #"/afs/cern.ch/user/t/tmatsush/public/tmGui/L1Menu_Point5IntegrationTest_2015_v1.xml"

from optparse import OptionParser
parser = OptionParser()
parser.add_option("--menu",     dest="menu",      default=defaultMenu,       type="string",  action="store",     help="path to the xml trigger menu")
parser.add_option("--nModules", dest="nModules",  default=1,      type="int",     action="store",     help="Number of Modules")
parser.add_option("--auto_dist", dest="auto_dist",  default=True,      type="string",     action="store",     help="Auto distribue algos in module")
parser.add_option("--output",   dest="outputDir", default=DIR+"/tmVhdlProducer/test/vhdltest/" ,      type="string", action="store", help="directory for the VHDL producer output")
parser.add_option("--verbose",   dest="verbose",  default=True ,      type="string", action="store", help="prints template outputs (to be implemented)")

#parser.add_option("--overwrite", dest="overwrite", action="store_true", help="Overwrite?", default=True)
(options, args) = parser.parse_args()




## -----------------------------------------------
#DIR              = "/afs/cern.ch/user/n/nrad/tm/utm/"
outputDir        = DIR+"/tmVhdlProducer/test/vhdltest/"
vhdlTemplateDir  = DIR+"/tmVhdlProducer/jinjaTemplates/"
nModules         = options.nModules
verbose          = options.verbose
menu             = tmEventSetup.getTriggerMenu(options.menu)



#loader = ResourceLoader(DIR)
#template = loader.get_source("","gtl_module.vhd.ja")



#t = TemplateEngine(vhdlTemplateDir)
#t.render("testTemplate.ja",{"name":"aa"})

#loader = Loader(vhdlTemplateDir)
#loader.getTemplateDict( templateDict )
#loader.templateDict

producer=VhdlProducer(menu,vhdlTemplateDir,nModules,outputDir,verbose)
producer.write()
#producer.makeDirectories()
