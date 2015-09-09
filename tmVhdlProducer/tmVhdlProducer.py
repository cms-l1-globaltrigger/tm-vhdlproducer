# -*- coding: utf-8 -*-
#
# Repository path   : $HeadURL: $
# Last committed    : $Revision: $
# Last changed by   : $Author: $
# Last changed date : $Date: $
#

from jinja2 import Environment, BaseLoader, TemplateNotFound, FileSystemLoader,filters
from os.path import join, exists, getmtime
from tmReporter.tmReporter import getReport
from os.path import basename
#import template_rc

__version__ = '0.1.0'
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
        "X04": lambda x: "%04X"%int(float(x)) , 
        #"X04": lambda x: pprint(x),
        "X01": lambda x: "%01X"%int(float(x)) , 
        #"X04": lambda x: x , 
        #"X01": lambda x: x , 
          }

def bx_encode(value):
     """Encode relative bunch crossings into VHDL notation.
     All positive values with the exception of zero are prefixed with m, all
     negative values are prefixed with p instead of the minus sign.
     """
     # Prefix positive values greater then zero with p.
     if value > 0:
         return 'p{0:d}'.format(value)
     # Prefix negative values with m instead of minus sign (abs).
     if value < 0:
         return 'm{0:d}'.format(abs(value))
     # Zero value is not prefixed according to VHDL documentation.
     return '0'


templateDict = {  
        #"test"                  :       "testTemplate.ja",
        "gtl_module"            :       "gtl_module.vhd",
        "algo_mapping"          :       "algo_mapping_rop.ja.vhd",
        "gtl_pkg"               :       "gtl_pkg.ja.vhd",
        "signal_eta_phi"        :       "subTemplates/signal_eta_phi.ja.vhd",
        #"muon_conditions"       :      "subTemplates/instance_muon_condition.vhd",                   
        "muon_conditions"       :       "subTemplates/instance_muon_condition.ja.vhd",                   
        "calo_conditions"       :       "subTemplates/instance_calo_condition_v2.ja.vhd",                   
        "esums_conditions"      :       "subTemplates/instance_esums_condition.ja.vhd",                   
        "muon_charges"          :       "subTemplates/instance_muon_charges.ja.vhd_",                   
        }

#finalTemplates = ["gtl_module", "algo_mapping", "gtl_pkg"]
finalTemplates = ["gtl_module", "algo_mapping"]




# -----------------------------------------------------------------------------
# Additional Helpers
# -----------------------------------------------------------------------------

import os, errno
import shutil
def mkdir_p(path):
    #if os.path.exists(path):
    #  print path, "already exists. Will be replaced"
    #  shutil.rmtree(path)
    try:
        os.makedirs(path)
    except OSError as exc: # Python >2.5
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else: raise

class twoWayMap:
    def __init__(self):
       self.d = {}
    def add(self, k, v):
       self.d[k] = v
       self.d[v] = k
    def remove(self, k):
       self.d.pop(self.d.pop(k))
    def get(self, k):
       return self.d[k]



# -----------------------------------------------------------------------------
#  Jinja2 custom filters exposed to VHDL templates.
# -----------------------------------------------------------------------------

def hex_filter(i, chars = None):
    if isinstance(i, str):
        i = int(i, 16) if i.lower().startswith('0x') else int(i, 10)
    return "{0:0{1}X}".format(i, chars)[:chars] if chars else "{0:X}".format(i)

def hexstr_filter(s, chars = None):
    return "{0:0{1}}".format(str2hex(s), chars)[:chars] if chars else "{0}".format(str2hex(s))

def uuid2hex_filter(s):
    return uuid.UUID(s).hex.upper()

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


        #try:
        #    #return template_rc.rcload(template), None, lambda: True
        #except KeyError:
        #    raise TemplateNotFound(template)

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
      #self.template = self.env.get_template(templateName)
      self.source = self.get_source(self.env,templateFile) ## not sure what this is good for
    def getTemplateDict(self,templateDict):
      for templateName in templateDict:
        templateFile = templateDict[templateName]
        self.getTemplate(templateName,templateFile)
        #self.templateDict[templateName]=templateFile

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
        #self.environment.filters['uuid'] = uuid_filter
        self.environment.filters['bool'] = lambda b: ('false', 'true')[bool(b)]

    def render(self, template, data = {}):
        template = self.environment.get_template(template)
        return template.render(data)

# -----------------------------------------------------------------------------
#  VHDL producer class.
# -----------------------------------------------------------------------------

class VhdlProducer(object):
    """VHDL producer class."""

    def __init__(self,menu,templateDir,nModules,outputDir):
        self.menu     = menu
        self.menuName = menu.getName()
        self.nModules = nModules  ##how to get these?
        self.outputDir = outputDir
        self._makeDirectories()
        #self._makeDefaultTemplateDictionaries()

        self.loader = Loader(templateDir)
        self.loader.getTemplateDict( templateDict ) 
        #self.loader.env.loader.env.filters.update(filters)
        #self.loader.templateDict

        algoMap = menu.getAlgorithmMap()
        self.nAlgos = algoMap.size()
        getReport(self.menu)
        print "menu reporter keys:", self.menu.reporter.keys()
        menu.reporter['DefaultTemps']= self._makeDefaultTemplateDictionaries()

    def _makeDirectories(self):
        mainDir = self.outputDir + "/" + "L1Menu_" + self.menuName
        testVectorDir = mainDir +"/testvector"
        vhdlDir = mainDir + "/vhdl"
        self.directoryDict= { 
                'top' : mainDir, 
                "testvector" : testVectorDir,
                "vhdl" : vhdlDir, 
                            }
        for iMod in range(self.nModules):
            self.directoryDict["module_%s"%iMod] = vhdlDir + "/module_%s"%iMod+"/src/"
        if os.path.exists(self.directoryDict['top']):
          print self.directoryDict['top'], "already exists. Will be replaced"
          shutil.rmtree(self.directoryDict['top'])


        for directory in self.directoryDict:
            mkdir_p(self.directoryDict[directory])
            print self.directoryDict[directory]


    def _makeDefaultTemplateDictionaries(self):
        defTempDict={}
        defTempDict['muon_condition_dict'] =\
                                     {
                                              "PtThresholds"              :      [ 0,  0,  0,  0  ]     , 
                                              "EtaFullRange"              :      [ 0,  0,  0,  0  ]     ,
                                              "EtaW1UpperLimits"          :      [ 0,  0,  0,  0  ]     ,
                                              "EtaW1LowerLimits"          :      [ 0,  0,  0,  0  ]     ,
                                              "EtaW2Ignore"               :      [ 0,  0,  0,  0  ]     ,
                                              "EtaW2UpperLimits"          :      [ 0,  0,  0,  0  ]     ,
                                              "EtaW2LowerLimits"          :      [ 0,  0,  0,  0  ]     ,
                                              "PhiFullRange"              :      [ 0,  0,  0,  0  ]     ,
                                              "PhiW1UpperLimits"          :      [ 0,  0,  0,  0  ]     ,
                                              "PhiW1LowerLimits"          :      [ 0,  0,  0,  0  ]     ,
                                              "PhiW2Ignore"               :      [ 0,  0,  0,  0  ]     ,
                                              "PhiW2UpperLimits"          :      [ 0,  0,  0,  0  ]     ,
                                              "PhiW2LowerLimits"          :      [ 0,  0,  0,  0  ]     ,            
                                              "RequestedCharges"          :      ["ign","ign","ign","ign"]  ,            
                                              "QualityLuts"               :      [ 0,  0,  0,  0  ]     ,              
                                              "IsolationLuts"             :      [ 0,  0,  0,  0  ]     ,              
                                              "RequestedChargeCorrelation":        "ig"                                   ,
                                              "DiffEtaUpperLimit"         :        0                                      ,
                                              "DiffEtaLowerLimit"         :        0                                      ,
                                              "DiffPhiUpperLimit"         :        0                                      ,
                                              "DiffPhiLowerLimit"         :        0                                      ,
                                     }

        return defTempDict

        







    def initialize(self):
        from itertools import cycle
        iAlgo=0
        moduleCycle=cycle(range(self.nModules))
        print "writing %s Algos in %s Modules"%(self.nAlgos,self.nModules)
        a2m = {}
        m2a = [[] for x in range(self.nModules) ]
        while iAlgo < self.nAlgos:
          iMod = moduleCycle.next()
          #algoName  =  self.menu.reporter['algoDict'].keys()[iAlgo]  ## Need to spread out the algos in a more logical way
          algoName  =  self.menu.reporter['index_sorted'][iAlgo]  ## Need to spread out the algos in a more logical way
          algoDict  =  self.menu.reporter['algoDict'][algoName]
          algoIndex =  algoDict['index']
          m2a[iMod].append(algoIndex)
          a2m[algoIndex]=(iMod, m2a[iMod].index(algoIndex))
          iAlgo+=1
        print "adding mapping", m2a, a2m
        self.menu.reporter['m2a']=m2a
        self.menu.reporter['a2m']=a2m
        self.m2a=m2a
        self.a2m=a2m

    def write(self):
        self.initialize()

        from itertools import cycle
        iAlgo=0
        moduleCycle=cycle(range(self.nModules))
        print "writing %s Algos in %s Modules"%(self.nAlgos,self.nModules)

        ##Loop over algos and insert them in each module.

        #while iAlgo < self.nAlgos:
        #  iMod = moduleCycle.next()
        #  algoName  =  self.menu.reporter['algoDict'].keys()[iAlgo]  ## Need to spread out the algos in a more logical way
        #  algoDict  =  self.menu.reporter['algoDict'][algoName]
        for iMod in range(self.nModules): 
          print "template: "
          #temp = "signal_eta_phi"
          #for temp in [ "algo_mapping", "muon_conditions" , "muon_charges", "gtl_module"]:
          for temp in finalTemplates:
          #for temp in [ "esums_conditions" ]:
    
            tempOutputName= basename(templateDict[temp])
            #tempOutput = self.directoryDict["module_%s"%(iMod)] +"/%s"%templateDict[temp] 
            tempOutput = self.directoryDict["module_%s"%(iMod)] +"/%s"%tempOutputName 
            #print temp, tempOutput
            #self.loader.env.filters.update(filters)
            
            #print self.loader.env.filters
            with open( tempOutput ,'a') as f:
     
              f.write(self.loader.templateDict[temp].render(  {"menu":self.menu,"iMod":iMod } ))
              print "###################################      Start Template:    %s       #################################"%temp
              print(self.loader.templateDict[temp].render(  {"menu":self.menu,"iMod":iMod} ))
              print "###################################      End   Template:    %s       #################################"%temp
              f.close()
          ## render template for the algo in the module directory 
          #print iAlgo, self.directoryDict["module_%s"%iMod]
          #iAlgo+=1

