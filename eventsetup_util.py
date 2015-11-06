import uuid
import binascii

conditionTypes = (
  "SingleMuon",
  "DoubleMuon",
  "TripleMuon",
  "QuadMuon",
  "SingleEgamma",
  "DoubleEgamma",
  "TripleEgamma",
  "QuadEgamma",
  "SingleTau",
  "DoubleTau",
  "TripleTau",
  "QuadTau",
  "SingleJet",
  "DoubleJet",
  "TripleJet",
  "QuadJet",
  "TotalEt", 
  "TotalHt",   
  "MissingEt",   
  "MissingHt",   
  "MuonMuonCorrelation",   
  "MuonEsumCorrelation",   
  "CaloMuonCorrelation",   
  "CaloCaloCorrelation",   
  "CaloEsumCorrelation",   
  "InvariantMass",   
)

objectTypes = (
  "MU",
  "EG",
  "TAU",
  "JET",
  "ETT",
  "HTT",
  "ETM",
  "HTM"
)
## which format in "Global Trigger Logic - description for emulator" and http://www.hephy.at/user/tmatsushita/utm/tmEventSetup/namespacetmeventsetup.html#a41abbc49e4f07549d47c2b9d8361baa8 dont match! 

cutTypes = (
  "Threshold",
  "Eta",
  "Phi",
  "Charge",
  "Quality",
  "Isolation",
  "DeltaEta",
  "DeltaPhi",
  "DeltaR",
  "Mass",
  "ChargeCorrelation",
)

# -----------------------------------------------------------------------------
#  Helpers
# -----------------------------------------------------------------------------
sortDictByKey = lambda iDict, iKey,reverse : sorted ( iDict, key=lambda x: iDict[x][iKey],reverse=reverse )


def getCutDict(cutDict,cutType):
  return [cutDict[c] for c in cutDict if cutDict[c]['cutType']==cutType]

def _makeDefaultTemplateDictionaries(condition):
    defTempDict={}
    ###################################       Common Dictionaries     ###############################
    EtaRangeDict = {
                     "EtaFullRange"              :      [ 'false',  'false',  'false',  'false'  ]     ,
                     "EtaW1UpperLimits"          :      [ 0,  0,  0,  0  ]     ,
                     "EtaW1LowerLimits"          :      [ 0,  0,  0,  0  ]     ,
                     "EtaW2Ignore"               :      [ 'false',  'false',  'false',  'false'  ]     ,
                     "EtaW2UpperLimits"          :      [ 0,  0,  0,  0  ]     ,
                     "EtaW2LowerLimits"          :      [ 0,  0,  0,  0  ]     ,
                    }
    PhiRangeDict = {
                      "PhiFullRange"              :      [ 'false',  'false',  'false',  'false'  ]     ,
                      "PhiW1UpperLimits"          :      [ 0,  0,  0,  0  ]     ,
                      "PhiW1LowerLimits"          :      [ 0,  0,  0,  0  ]     ,
                      "PhiW2Ignore"               :      [ 'false',  'false',  'false',  'false'  ]     , 
                      "PhiW2UpperLimits"          :      [ 0,  0,  0,  0  ]     ,
                      "PhiW2LowerLimits"          :      [ 0,  0,  0,  0  ]     ,            
                    }

    EtaPhiDiffDict= {
                   "DiffEtaUpperLimit"         :        0                                      ,
                   "DiffEtaLowerLimit"         :        0                                      ,
                   "DiffPhiUpperLimit"         :        0                                      ,
                   "DiffPhiLowerLimit"         :        0                                      ,
                    }
    #################################################################################################
    

    #### Muon Condition Template
    if any_in(["MU"],condition):
      defTempDict['muon_condition_dict'] =\
                                   {
                                            "PtThresholds"              :      [ 0,  0,  0,  0  ]     , 
                                            "RequestedCharges"          :      ["ign","ign","ign","ign"]  ,            
                                            "QualityLuts"               :      [ 0xFFFF,  0xFFFF, 0xFFFF, 0xFFFF  ]     ,              
                                            "IsolationLuts"             :      [ 0xF, 0xF, 0xF, 0xF  ]     ,              
                                            "RequestedChargeCorrelation":        "ig"                                   ,
                                   }
      for dct in [EtaRangeDict,  PhiRangeDict, EtaPhiDiffDict]:
        defTempDict['muon_condition_dict'].update(dct)
    #### Calo Condition Template
    if any_in(["JET","TAU","EG"],condition):
      defTempDict['calo_condition_dict'] =\
                                   {
                                            "EtThresholds"              :      [ 0,  0,  0,  0  ]     , 
                                            #"IsoLuts"                   :      [ 0xF, 0xF, 0xF, 0xF  ]   ,
                                            "IsoLuts"                   :      [ 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF  ]   ,
                                   }
      for dct in [EtaRangeDict,  PhiRangeDict, EtaPhiDiffDict]:
        defTempDict['calo_condition_dict'].update(dct)

    #### Esums Condition Template
    if any_in([ "ETT","HTT","ETM","HTM"],condition):
      defTempDict['esums_condition_dict'] =\
                                   {
                                            "EtThreshold"               :      [ "0" ]     , 
                                            "PhiFullRange"              :      ['false' ]  ,
                                            "PhiW1UpperLimit"          :      [ 0 ], 
                                            "PhiW1LowerLimit"          :      [ 0 ], 
                                            "PhiW2Ignore"               :      ['false' ] , 
                                            "PhiW2UpperLimit"          :      [ 0 ], 
                                            "PhiW2LowerLimit"          :      [ 0 ], 
                                   }
      #for dct in [EtaRangeDict,  PhiRangeDict, EtaPhiDiffDict]:
      #  defTempDict['esums_condition_dict'].update(dct)


    return defTempDict



def any_in(stringList,string):
  return any([x.lower() in string.lower() for x in stringList] )

def getObjectType(condName):
  objectType=[]
  for objType in objectTypes:
    if objType in condName:
      objectType.append(objType)
  assert len(objectType)==1
  return objectType[0]


def getReport(menu,vhdlVersion=False):
    #conditionTypes=( "SingleMuon", "DoubleMuon", "TripleMuon", "QuadMuon", "SingleEgamma", "DoubleEgamma", "TripleEgamma", "QuadEgamma", "SingleTau", "DoubleTau", "TripleTau", "QuadTau", "SingleJet", "DoubleJet", "TripleJet", "QuadJet" )
    #objectTypes= ("MU","EG","TAU","JET","ETT","HTT","ETM","HTM") ## which format in "Global Trigger Logic - description for emulator" and http://www.hephy.at/user/tmatsushita/utm/tmEventSetup/namespacetmeventsetup.html#a41abbc49e4f07549d47c2b9d8361baa8 dont match! 

    menu.reporter={}
    menuName = menu.getName()
    tgDict= {'nBits':0, 'bits': set() }
    menu.reporter["TriggerGroups"]= dict((key,  {'nBits':0, 'bits':[] } ) for key in conditionTypes)
    menu.reporter["algoMap"]   = menu.getAlgorithmMap()
    menu.reporter["condMap"]   = menu.getConditionMap()
    menu.reporter["scaleMap"]  = menu.getScaleMap()
    menu.reporter["algoDict"]   = dict( ( algo.getName()  , {
                                                                "algo":algo, 
                                                                "index":algo.getIndex(), 
                                                                "exp":algo.getExpression(),
                                                                "condDict":{} ,
                                                                "moduleId":algo.getModuleId(),
                                                                "moduleIndex":algo.getModuleIndex(),
                                                            }) for key, algo in menu.reporter["algoMap"].iteritems())

    if vhdlVersion:
      version = vhdlVersion.rsplit(".")
      menu.reporter["XxxDict"]   = {
                                    "L1TMenuUUIDHex":  uuid.uuid5(uuid.NAMESPACE_DNS, menuName).hex, 
                                    "L1TMenuUUID":  uuid.uuid5(uuid.NAMESPACE_DNS, menuName), 
                                    "L1TMenuNameHex":   binascii.hexlify(menu.getName()).zfill(256) ,  
                                    "L1TMenuFirmwareUUID":  uuid.uuid1()  ,  
                                    "L1TMenuFirmwareUUIDHex":  uuid.uuid1().hex  ,  
                                    "L1TMCompilerVersionMajor":     version[0],  
                                    "L1TMCompilerVersionMinor":     version[1],  
                                    "L1TMCompilerVersionRevision":  version[2],  
                                    "L1TMenuName":        menuName,  
                                    "L1TMenuScaleSet":    None,  
                                  }

    for algoName in menu.reporter["algoDict"]: 
      #algo = menu.reporter["algoDict"][algoName]["algo"]
      algoDict = menu.reporter["algoDict"][algoName]
      for x in algoDict['algo'].getRpnVector():
        #if tmGrammar.isGate(x): continue
        if x in ["AND", "OR", "NOT", "XOR"]: continue
        hash = menu.getHash(x)
        cond = menu.reporter["condMap"][hash]
        condName=cond.getName()
        #condName.replace("_"+str(x),"")
        algoDict["condDict"][condName]={    
                                            'objType':getObjectType(condName) ,           
                                            "cond":cond,
                                            "hash":hash, 
                                            "type":cond.getType(), 
                                            "TriggerGroup":conditionTypes[cond.getType()],
                                       }
        if True:
          algoDict["condDict"][condName].update( {
                                                  'ConditionTemplates': _makeDefaultTemplateDictionaries(condName), 
                                               } )
      #for _condName in algoDict['condDict'].keys():
      #  if condName != _condName:
      #    print "########################################################################################"
      #    print "########################################################################################"
      #    print "########################################################################################"
      #    print "######################                                             ####################"
      #    print "######################            SOMETHING WRONGGGG!!!!!          ####################"
      #    print "######################                                             #####################"
      #    print "########################################################################################"
      #    print "########################################################################################"
      #    print condName, _condName
      #    break
        condDict = algoDict['condDict'][condName]
        if any_in(["MU"],condName):
          muCondDict= condDict['ConditionTemplates']['muon_condition_dict']
        if any_in(["JET","TAU","EG"],condName):
          caloCondDict = condDict['ConditionTemplates']['calo_condition_dict']
        if any_in([ "ETT","HTT","ETM","HTM"],condName):
          esumsCondDict = condDict['ConditionTemplates']['esums_condition_dict']

        for cut in condDict['cond'].getCuts():
          print cut
        condDict['objDict']={}
        condDict['objList']=[]
        for obj in condDict['cond'].getObjects():
          objName = obj.getName()
          condDict['objDict'][objName]={  
                                          'objType':objectTypes[obj.getType()],
                                          'name':objName ,
                                          'type':obj.getType(), 
                                          'op': obj.getComparisonOperator()==0, 
                                          'obj':obj, 
                                          'Bx':bx_encode(obj.getBxOffset()), 
                                          'bxOffset':obj.getBxOffset(), 
                                       }
          objDict = condDict['objDict'][objName]
          #objDict['type']=obj.getType()
          #objDict['op']=obj.getComparisonOperator()
          objDict['cutDict']={}
          for cut in obj.getCuts():
            cutName = cut.getName()
            objDict["cutDict"][cutName]={
                                            'name'        :cutName,
                                            'cut'         :cut, 
                                            'target'      :cut.getObjectType(), 
                                            "cutType"     :cutTypes[cut.getCutType()] , 
                                            "type"        :cut.getCutType() , 
                                            "minVal"      :cut.getMinimum().value, 
                                            "minIndex"    :cut.getMinimum().index,  
                                            "maxVal"      :cut.getMaximum().value ,
                                            "maxIndex"    :cut.getMaximum().index , 
                                            "data"        :cut.getData() 
                                        }
          condDict['objList'].append( condDict['objDict'][objName]  )

          #print condDict['ConditionTemplates']['muon_condition_dict']

        for iObj in range(len(condDict['objList'])):
          objDict = condDict['objList'][iObj]
          cutDict = condDict['objList'][iObj]['cutDict']

          if any_in(["MU"],condName):  #do this only for muons
            #muCondDict["PtThresholds"][iObj]                =  [cd[c]['minIndex'] for c in cd if cd[c]['cutType']=='Threshold'][0] 
            muCondDict["PtThresholds"][iObj]                =  getCutDict(cutDict,"Threshold")[0]['minIndex'] 
            assert getCutDict(cutDict,"Threshold")[0]['minIndex'] == [cutDict[c]['minIndex'] for c in cutDict if cutDict[c]['cutType']=='Threshold'][0]

            #EtaCuts = [cd[c] for c in cd if cd[c]['cutType']=='Eta']
            EtaCuts = getCutDict(cutDict,"Eta")
            nEtaCuts = len(EtaCuts)
            if nEtaCuts == 0:
              muCondDict["EtaFullRange"][iObj]                = 'true'
            if nEtaCuts >= 1:
              muCondDict["EtaW1UpperLimits"][iObj]            =  EtaCuts[0]['maxIndex']                              
              muCondDict["EtaW1LowerLimits"][iObj]            =  EtaCuts[0]['minIndex'] 
              if nEtaCuts == 1:
                muCondDict["EtaW2Ignore"][iObj]                 =  'true' 
              if nEtaCuts == 2:
                muCondDict["EtaW2UpperLimits"][iObj]            =  EtaCuts[1]['maxIndex']                              
                muCondDict["EtaW2LowerLimits"][iObj]            =  EtaCuts[1]['minIndex'] 

            #PhiCuts = [cd[c] for c in cd if cd[c]['cutType']=='Phi']
            PhiCuts = getCutDict(cutDict,"Phi")
            nPhiCuts = len(PhiCuts)
            if nPhiCuts == 0:
              muCondDict["PhiFullRange"][iObj]                = 'true'
            if nPhiCuts >= 1:
              muCondDict["PhiW1UpperLimits"][iObj]            =  PhiCuts[0]['maxIndex']                              
              muCondDict["PhiW1LowerLimits"][iObj]            =  PhiCuts[0]['minIndex'] 
              if nPhiCuts ==1:
                esumsCondDict["PhiW2Ignore"][iObj]                 =  'true' 
              if nPhiCuts == 2:
                muCondDict["PhiW2UpperLimits"][iObj]            =  PhiCuts[1]['maxIndex']                              
                muCondDict["PhiW2LowerLimits"][iObj]            =  PhiCuts[1]['minIndex'] 

            ChargeCuts = getCutDict(cutDict,"Charge")
            nChargeCuts = len(ChargeCuts)           
            if nChargeCuts > 0:
              muCondDict["RequestedCharges"][iObj]            = chargeFormat(ChargeCuts[0]['data'] )

            QualityCuts = getCutDict(cutDict,"Quality")
            nQualityCuts = len(QualityCuts)           
            if nQualityCuts == 1:
              muCondDict["QualityLuts"][iObj]                 = QualityCuts[0]["data"]

            IsolationCuts = getCutDict(cutDict,"Isolation")
            nIsolationCuts = len(IsolationCuts)           
            if nIsolationCuts == 1:
              muCondDict["IsolationLuts"][iObj]                 = IsolationCuts[0]["data"]


            ChargeCorrelationCuts = getCutDict(cutDict,"ChargeCorrelation")
            nChargeCorrelationCuts = len(ChargeCorrelationCuts)           
            if nChargeCorrelationCuts == 1:
              muCondDict["ChargeCorrelation"][iObj]                 = ChargeCorrelationCuts[0]["data"]
              ## what is the actual output??

            DeltaEtaCuts = getCutDict(cutDict,"DeltaEta")
            nDeltaEtaCuts = len(DeltaEtaCuts)           
            if nDeltaEtaCuts == 1:
              muCondDict["DiffEtaUpperLimit"][iObj]                 = DeltaEtaCuts[0]["maxIndex"]
              muCondDict["DiffEtaLowerLimit"][iObj]                 = DeltaEtaCuts[0]["minIndex"]

            DeltaPhiCuts = getCutDict(cutDict,"DeltaPhi")
            nDeltaPhiCuts = len(DeltaPhiCuts)           
            if nDeltaPhiCuts == 1:
              muCondDict["DiffPhiUpperLimit"][iObj]                 = DeltaPhiCuts[0]["maxIndex"]
              muCondDict["DiffPhiLowerLimit"][iObj]                 = DeltaPhiCuts[0]["minIndex"]

          if any_in(["JET","TAU","EG"],condName):
            caloCondDict["EtThresholds"][iObj]                =  getCutDict(cutDict,"Threshold")[0]['minIndex'] 
            #assert getCutDict(cutDict,"Threshold")[0]['minIndex'] == [cutDict[c]['minIndex'] for c in cutDict if cutDict[c]['cutType']=='Threshold'][0]
            #EtaCuts = [cd[c] for c in cd if cd[c]['cutType']=='Eta']
            EtaCuts = getCutDict(cutDict,"Eta")
            nEtaCuts = len(EtaCuts)
            if nEtaCuts == 0:
              caloCondDict["EtaFullRange"][iObj]                = 'true'
            if nEtaCuts >= 1:
              caloCondDict["EtaW1UpperLimits"][iObj]            =  EtaCuts[0]['maxIndex']                              
              caloCondDict["EtaW1LowerLimits"][iObj]            =  EtaCuts[0]['minIndex'] 
              if nEtaCuts == 1:
                caloCondDict["EtaW2Ignore"][iObj]                 =  'true' 
              if nEtaCuts == 2:
                caloCondDict["EtaW2UpperLimits"][iObj]            =  EtaCuts[1]['maxIndex']                              
                caloCondDict["EtaW2LowerLimits"][iObj]            =  EtaCuts[1]['minIndex'] 

            PhiCuts = getCutDict(cutDict,"Phi")
            nPhiCuts = len(PhiCuts)
            if nPhiCuts == 0:
              caloCondDict["PhiFullRange"][iObj]                = 'true'
            if nPhiCuts >= 1:
              caloCondDict["PhiW1UpperLimits"][iObj]            =  PhiCuts[0]['maxIndex']                              
              caloCondDict["PhiW1LowerLimits"][iObj]            =  PhiCuts[0]['minIndex'] 
              if nPhiCuts == 1:
                caloCondDict["PhiW2Ignore"][iObj]                 =  'true' 
              if nPhiCuts == 2:
                caloCondDict["PhiW2UpperLimits"][iObj]            =  PhiCuts[1]['maxIndex']                              
                caloCondDict["PhiW2LowerLimits"][iObj]            =  PhiCuts[1]['minIndex'] 

            IsoCuts = getCutDict(cutDict,"Isolation")
            nIsoCuts = len(IsoCuts)           
            if nIsoCuts == 1:
              caloCondDict["IsoLuts"][iObj]                     = IsoCuts[0]["data"]

            DeltaEtaCuts = getCutDict(cutDict,"DeltaEta")
            nDeltaEtaCuts = len(DeltaEtaCuts)           
            if nDeltaEtaCuts == 1:
              caloCondDict["DiffEtaUpperLimit"][iObj]                 = DeltaEtaCuts[0]["maxIndex"]
              caloCondDict["DiffEtaLowerLimit"][iObj]                 = DeltaEtaCuts[0]["minIndex"]

            DeltaPhiCuts = getCutDict(cutDict,"DeltaPhi")
            nDeltaPhiCuts = len(DeltaPhiCuts)           
            if nDeltaPhiCuts == 1:
              caloCondDict["DiffPhiUpperLimit"][iObj]                 = DeltaPhiCuts[0]["maxIndex"]
              caloCondDict["DiffPhiLowerLimit"][iObj]                 = DeltaPhiCuts[0]["minIndex"]

          if any_in([ "ETT","HTT","ETM","HTM"],condName):
            esumsCondDict["EtThreshold"][iObj]                =  getCutDict(cutDict,"Threshold")[0]['minIndex'] 
            #print "#######################################################################################"
            #print "#######################################################################################"
            #print getCutDict(cutDict,"Threshold")[0] , iObj,  len(condDict['objList'])
            #print esumsCondDict["EtThreshold"]
            #print "#######################################################################################"
            #print "#######################################################################################"

            #assert getCutDict(cutDict,"Threshold")[0]['minIndex'] == [cutDict[c]['minIndex'] for c in cutDict if cutDict[c]['cutType']=='Threshold'][0]
            #EtaCuts = [cd[c] for c in cd if cd[c]['cutType']=='Eta']

            PhiCuts = getCutDict(cutDict,"Phi")
            nPhiCuts = len(PhiCuts)
            if nPhiCuts == 0:
              esumsCondDict["PhiFullRange"][iObj]                = 'true'
            if nPhiCuts >= 1:
              esumsCondDict["PhiW1UpperLimit"][iObj]            =  PhiCuts[0]['maxIndex']                              
              esumsCondDict["PhiW1LowerLimit"][iObj]            =  PhiCuts[0]['minIndex'] 
              if nPhiCuts ==1:
                esumsCondDict["PhiW2Ignore"][iObj]                 =  'true' 
              if nPhiCuts == 2:
                esumsCondDict["PhiW2UpperLimit"][iObj]            =  PhiCuts[1]['maxIndex']                              
                esumsCondDict["PhiW2LowerLimit"][iObj]            =  PhiCuts[1]['minIndex'] 

    for algoName in menu.reporter["algoDict"]:
      algo = menu.reporter["algoDict"][algoName]["algo"]
      for condName in menu.reporter["algoDict"][algoName]["condDict"]:
        condType=menu.reporter["algoDict"][algoName]["condDict"][condName]["TriggerGroup"]
        menu.reporter["TriggerGroups"][condType]["nBits"]+=1
        menu.reporter["TriggerGroups"][condType]["bits"].append( {"index":menu.reporter["algoDict"][algoName]["index"] , "algoName":algoName})
    menu.reporter["nBits_sorted"]=sortDictByKey(menu.reporter['TriggerGroups'],"nBits",True)
    menu.reporter["index_sorted"]=sortDictByKey(menu.reporter["algoDict"],"index",False)
    menu.reporter["nAlgoDefined"] = sum([menu.reporter['TriggerGroups'][tg]['nBits'] for tg in menu.reporter['TriggerGroups']])
    condList=[]
    for algoName in menu.reporter['index_sorted']: 
      condList.extend(menu.reporter['algoDict'][algoName]['condDict'].keys()) 
    menu.reporter["conditionSet"] = set(condList) 
    menu.reporter["__objects"] = [ [ [menu.reporter['algoDict'][algoName]['condDict'][condName]['objList'][iObj]['name'] for iObj in range( len( menu.reporter['algoDict'][algoName]['condDict'][condName]['objList'] )) ] for condName in menu.reporter['algoDict'][algoName]['condDict'].keys() ]  for algoName in menu.reporter['index_sorted']  ] 


def pprint(x):
  print "%%  ###############################################################################"
  print "%%  ###############################################################################"
  print x
  print "%%  ###############################################################################"
  print "%%  ###############################################################################"


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


# eof
