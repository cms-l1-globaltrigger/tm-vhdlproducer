# -*- coding: utf-8 -*-
#
# Repository path   : $HeadURL: $
# Last committed    : $Revision: $
# Last changed by   : $Author: $
# Last changed date : $Date: $
#

from jinja2 import Environment, BaseLoader, TemplateNotFound, FileSystemLoader,filters
from os.path import join, exists, getmtime, basename
from itertools import cycle

import eventsetup_util as util

#import template_rc

__version__ = '0.0.1'
__all__ = ['VhdlProducer', ]

# -----------------------------------------------------------------------------
#  Helpers
# -----------------------------------------------------------------------------

def pprint(x):
  print "%%  ###############################################################################"
  print "%%  ###############################################################################"
  print x
  print "%%  ###############################################################################"
  print "%%  ###############################################################################"

def str2hex(s):
    """Convert a string into hex encoded value. Requires to reverse byte order, then encode."""
    return int(s[::-1].encode("hex"), 16)

def hex2str(i):
    """Convert a hex encoded integer to string. Requires to reverse byte order and stripping pending zeros."""
    return hex(i).decode("hex")[::-1].strip("\x00")

extraFilters = {
        "X04"   : lambda x: "%04X"%int(float(x)) , 
        "X01"   : lambda x: "%01X"%int(float(x)) , 
        "alpha" : lambda s: ''.join(c for c in s if c.isalpha() )
          }


templateDict = {  
        "algo_mapping"          :       "algo_mapping_rop.vhd",
        "gtl_pkg"               :       "gtl_pkg.vhd",
        "gtl_module"            :       "gtl_module.vhd",
        "json"                  :       "menu.json",
        }

templatesToUse = ["gtl_module", "algo_mapping","gtl_pkg", "json"]


# -----------------------------------------------------------------------------
# Additional Helpers
# -----------------------------------------------------------------------------

import os, errno
import shutil
def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError as exc: # Python >2.5
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else: raise


# -----------------------------------------------------------------------------
#  Jinja2 custom filters exposed to VHDL templates.
# -----------------------------------------------------------------------------

def hex_filter(i, chars = None):
    if isinstance(i, str):
        i = int(i, 16) if i.lower().startswith('0x') else int(i, 10)
    return "{0:0{1}X}".format(i, chars)[:chars] if chars else "{0:X}".format(i)

def hexstr_filter(s, chars = None):
    return "{0:0{1}}".format(str2hex(s), chars)[:chars] if chars else "{0}".format(str2hex(s))

# -----------------------------------------------------------------------------
#  Custom resource loader.
# -----------------------------------------------------------------------------

class ResourceLoader(BaseLoader):
    """Loads a template from python module resource compiled with tplrcc.

    See also http://jinja.pocoo.org/docs/dev/api/#jinja2.BaseLoader
    """
    def __init__(self, path):
        self.path = path

    def get_source(self, environment, template):
        path = join(self.path, template)
        if not exists(path):
          raise TemplateNotFound(template)
        mtime = getmtime(path)
        with file(path) as f:
            source = f.read().decode('utf-8')
        return source, path, lambda: mtime == getmtime(path)


class Loader(FileSystemLoader):

    def __init__(self, searchpath, encoding='utf-8', followlinks=False):
      filters.FILTERS.update(extraFilters)   ## probably not hte best way (seems too global) 
      if isinstance(searchpath, (str,)):
          searchpath = [searchpath]
      self.searchpath = list(searchpath)
      self.encoding = encoding
      self.followlinks = followlinks
      self.env = Environment(loader=self)
      self.templateDict={}

    def getTemplate(self,templateName,templateFile):
      self.templateDict[templateName]=self.env.get_template(templateFile)
      self.source = self.get_source(self.env,templateFile) ## not sure what this is good for
    def getTemplateDict(self,templateDict):
      for templateName in templateDict:
        templateFile = templateDict[templateName]
        self.getTemplate(templateName,templateFile)

# -----------------------------------------------------------------------------
#  Template engines with custom resource loader environment.
# -----------------------------------------------------------------------------

class TemplateEngine(object):

    def __init__(self,path):
        # Create Jinja environment.
        self.environment = Environment(loader = ResourceLoader(path))
        self.path = path

        # Adding filters.
        self.environment.filters['hex'] = hex_filter
        self.environment.filters['hexstr'] = hexstr_filter
        self.environment.filters['bool'] = lambda b: ('false', 'true')[bool(b)]

    def render(self, template, data = {}):
        template = self.environment.get_template(template)
        return template.render(data)

# -----------------------------------------------------------------------------
#  VHDL producer class.
# -----------------------------------------------------------------------------

class VhdlProducer(object):
    """VHDL producer class."""

    def __init__(self,menu,templateDir,nModules,outputDir,verbose=False,manual_dist=False):
        self.menu     = menu
        self.menuName = menu.getName()
        self.nModules = nModules  ##how to get these?
        self.outputDir = outputDir
        self.manual_dist = manual_dist
        self.verbose = verbose
        self._makeDirectories()
        self.version = __version__
        self.VHDLProducerVersion = __all__[0]+__version__

        self.loader = Loader(templateDir)
        self.loader.getTemplateDict( templateDict ) 

        algoMap = menu.getAlgorithmMapPtr()
        self.nAlgos = algoMap.size()
        self.data = util.getReport(self.menu,self.version)

    def _makeDirectories(self):
        mainDir = self.outputDir
        vhdlDir = os.path.join(mainDir, "vhdl")
        self.directoryDict= { 
                'top' : mainDir, 
                "vhdl" : vhdlDir, 
                "testvectors" : os.path.join(mainDir, "testvectors"),
                "xml" : os.path.join(mainDir, "xml"),
                            }
        for iMod in range(self.nModules):
            self.directoryDict["module_%s"%iMod] = os.path.join(vhdlDir, "module_%s/src/"%iMod)
        if os.path.exists(self.directoryDict['vhdl']):
          print self.directoryDict['vhdl'], "already exists. Will be replaced"
          shutil.rmtree(self.directoryDict['vhdl'])
        if os.path.exists(self.directoryDict['xml']):
          print self.directoryDict['xml'], "already exists. Will be replaced"
          shutil.rmtree(self.directoryDict['xml'])


        for directory in self.directoryDict:
            mkdir_p(self.directoryDict[directory])
            if self.verbose: print self.directoryDict[directory]


    def initialize(self):

        iAlgo=0
        a2m = {}                                            ####   moduleForAlgo, localAlgoIndex = a2m[globalAlgoIndex]      
        m2a = [{} for x in range(self.nModules)]           ####   globalAlgoIndex = m2a[iMod][localAlgoIndex]   

        if not self.manual_dist:
          moduleCycle=cycle(range(self.nModules))
          while iAlgo < self.nAlgos:
            iMod = moduleCycle.next()
            algoName  =  self.data.reporter['index_sorted'][iAlgo]  ## Need to spread out the algos in a more logical way
            algoDict  =  self.data.reporter['algoDict'][algoName]
            algoIndex =  algoDict['index']  ##global index
            localAlgoIndex= len(m2a[iMod])
            m2a[iMod][localAlgoIndex]=algoIndex
            a2m[algoIndex]=(iMod, localAlgoIndex)
            iAlgo+=1
        else:
          print "-----------------------------------------------------------"
          print "Manually Distributing Algos in the Modules based on the menu"
          print "-----------------------------------------------------------"
          for algoName in self.data.reporter['index_sorted']:
            algoDict  =  self.data.reporter['algoDict'][algoName]
            iMod = algoDict['moduleId']
            algoIndex = algoDict['index']  ##global index
            localAlgoIndex= algoDict['moduleIndex']
            m2a[iMod][localAlgoIndex]=algoIndex
            a2m[algoIndex]=(iMod,localAlgoIndex)

        self.data.reporter['m2a']=m2a
        self.data.reporter['a2m']=a2m
        self.m2a=m2a
        self.a2m=a2m

    def update_reporter(self):
        """ Update Reporter here to reduce the logic required in the templates """
        self.data.reporter['moduleConds']= [{} for x in range(self.nModules)]
        self.data.reporter['moduleCondSet']= [set() for x in range(self.nModules)]
        for iMod in range(self.nModules):
          for localAlgoIndex in self.data.reporter['m2a'][iMod]:
            algoIndex = self.data.reporter['m2a'][iMod][localAlgoIndex]
            algoName = filter(lambda x : self.data.reporter['algoDict'][x]['index']==algoIndex ,self.data.reporter['algoDict'])[0]
            algoDict = self.data.reporter['algoDict'][algoName]
            self.data.reporter['moduleConds'][iMod][localAlgoIndex]= [ condName for condName in algoDict['condDict']    ]

            for condName in algoDict['condDict']:
              self.data.reporter['moduleCondSet'][iMod].add(condName)
          self.data.reporter['moduleCondSet'][iMod]= list(self.data.reporter['moduleCondSet'][iMod] )
        pass


    def write(self):
        self.initialize()
        self.update_reporter()
        print "writing %s Algos in %s Modules"%(self.nAlgos,self.nModules)
        iAlgo=0
        moduleCycle=cycle(range(self.nModules))

        ##Loop over algos and insert them in each module.

        writeJson = True
        for iMod in range(self.nModules): 
          print "Template Output:  "
          for temp in templatesToUse:
            tempOutputName= basename(templateDict[temp])
            if temp =="json":
              if not writeJson: continue
              if writeJson: writeJson = False
              tempOutput = os.path.join(self.directoryDict["xml"], "%s"%tempOutputName)
            else: 
              tempOutput = os.path.join(self.directoryDict["module_%s"%(iMod)], "%s"%tempOutputName )
            with open( tempOutput ,'a') as f:
              f.write(self.loader.templateDict[temp].render(  {"menu":self.data,"iMod":iMod } ))
              if self.verbose:
                print "###################################      Start Template:    %s       #################################"%temp
                print(self.loader.templateDict[temp].render(  {"menu":self.data,"iMod":iMod} ))
                print "###################################"
                print "###################################      End   Template:    %s       #################################"%temp
              print temp, " "*(20-len(temp)) ,":  " ,  tempOutput 
              f.close()

