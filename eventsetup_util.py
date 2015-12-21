#!/bin/env python

import logging
import uuid
from binascii import hexlify as hexlify

import tmGrammar
import tmEventSetup


# keys for reporter
keyNAlgoDefined = "nAlgoDefined"
keyNBitsSorted = "nBits_sorted"
keyAlgoMap = "algoMap"
keyIndexSorted = "index_sorted"
keyAlgoDict = "algoDict"
keyScaleMap = "scaleMap"
keyConditionSet = "conditionSet"
keyMenuInfo = "MenuInfo"
keyTriggerGroups = "TriggerGroups"
keyCondMap = "condMap"

keyCutDict = "cutDict"
keyObjDict = "objDict"
keyObjList = "objList"

keyBxComb = "bxComb"


# keys for algoDict
#   reporter[keyAlgoDict][<algoName>]
keyAlgo = "algo"
keyExp = "exp"
keyIndex = "index"
keyModuleId = "moduleId"
keyModuleIndex = "moduleIndex"
keyCondDict = "condDict"


# keys for condDict
#   reporter[keyAlgoDict][<algoName>][keyCondDict][<condName>]
keyCondition = "condition"
keyObjType = "objType"
keyTriggerGroup = "TriggerGroup"
keyCond = "cond"
keyType = "type"
keyConditionTemplates = "ConditionTemplates"


# keys for template
#  reporter[keyAlgoDict][<algoName>][keyCondDict][<condName>][keyConditionTemplates]
keyMuonConditionDict = "muon_condition_dict"
keyCaloConditionDict = "calo_condition_dict"
keyEsumsConditionDict = "esums_condition_dict"
keyCaloMuonCorrelationConditionDict = "calo_muon_correlation_condition_dict"


# keys for objDict
#   reporter[keyAlgoDict][keyCondDict][<condName>][keyObjDict][<objName>]
keyObj = "obj"
keyName = "name"
keyBxOffset = "bxOffset"
keyObjType
keyBx = "Bx"
keyType
keyOp = "op"


# keys for cutDict
#   reporter[keyAlgoDict][<algoName>][keyCondDict][<condName>][keyObjList][ii][keyCutDict][<cutName>]
keyMinIndex = "minIndex"
keyMaxVal = "maxVal"
keyCut = "cut"
keyName
keyTarget = "target"
keyData = "data"
keyMinVal = "minVal"
keyType
keyMaxIndex = "maxIndex"
keyCutType = "cutType"


# keys for reporter[keyTriggerGroups][<conditionType>]
keyNBits = "nBits"
keyBits = "bits"


# keys for reporter[keyTriggerGroups][<conditionType>][keyBits][ii]
keyAlgoName = 'algoName'
keyIndex


# list of condition types
# should match esConditionType enum in ../tmEventSetup/esTriggerMenu.hh
_conditionTypes = [None] * tmEventSetup.nConditionType

_conditionTypes[tmEventSetup.SingleMuon] = "SingleMuon"
_conditionTypes[tmEventSetup.DoubleMuon] = "DoubleMuon"
_conditionTypes[tmEventSetup.TripleMuon] = "TripleMuon"
_conditionTypes[tmEventSetup.QuadMuon] = "QuadMuon"

MuonCondition = (
  tmEventSetup.SingleMuon,
  tmEventSetup.DoubleMuon,
  tmEventSetup.TripleMuon,
  tmEventSetup.QuadMuon,
)

_conditionTypes[tmEventSetup.SingleEgamma] = "SingleEgamma"
_conditionTypes[tmEventSetup.DoubleEgamma] = "DoubleEgamma"
_conditionTypes[tmEventSetup.TripleEgamma] = "TripleEgamma"
_conditionTypes[tmEventSetup.QuadEgamma] = "QuadEgamma"

EgammaCondition = (
  tmEventSetup.SingleEgamma,
  tmEventSetup.DoubleEgamma,
  tmEventSetup.TripleEgamma,
  tmEventSetup.QuadEgamma,
)

_conditionTypes[tmEventSetup.SingleTau] = "SingleTau"
_conditionTypes[tmEventSetup.DoubleTau] = "DoubleTau"
_conditionTypes[tmEventSetup.TripleTau] = "TripleTau"
_conditionTypes[tmEventSetup.QuadTau] = "QuadTau"

TauCondition = (
  tmEventSetup.SingleTau,
  tmEventSetup.DoubleTau,
  tmEventSetup.TripleTau,
  tmEventSetup.QuadTau,
)

_conditionTypes[tmEventSetup.SingleJet] = "SingleJet"
_conditionTypes[tmEventSetup.DoubleJet] = "DoubleJet"
_conditionTypes[tmEventSetup.TripleJet] = "TripleJet"
_conditionTypes[tmEventSetup.QuadJet] = "QuadJet"

JetCondition = (
  tmEventSetup.SingleJet,
  tmEventSetup.DoubleJet,
  tmEventSetup.TripleJet,
  tmEventSetup.QuadJet,
)

_conditionTypes[tmEventSetup.TotalEt] = "TotalEt"
_conditionTypes[tmEventSetup.TotalHt] = "TotalHt"
_conditionTypes[tmEventSetup.MissingEt] = "MissingEt"
_conditionTypes[tmEventSetup.MissingHt] = "MissingHt"

EsumCondition = (
  tmEventSetup.TotalEt,
  tmEventSetup.TotalHt,
  tmEventSetup.MissingEt,
  tmEventSetup.MissingHt,
)

CaloCondition = EgammaCondition + TauCondition + JetCondition
ObjectCondition = MuonCondition + CaloCondition + EsumCondition

_conditionTypes[tmEventSetup.MuonMuonCorrelation] = "MuonMuonCorrelation"
_conditionTypes[tmEventSetup.MuonEsumCorrelation] = "MuonEsumCorrelation"
_conditionTypes[tmEventSetup.CaloMuonCorrelation] = "CaloMuonCorrelation"
_conditionTypes[tmEventSetup.CaloCaloCorrelation] = "CaloCaloCorrelation"
_conditionTypes[tmEventSetup.CaloEsumCorrelation] = "CaloEsumCorrelation"

CorrelationCondition = (
  tmEventSetup.MuonMuonCorrelation,
  tmEventSetup.MuonEsumCorrelation,
  tmEventSetup.CaloMuonCorrelation,
  tmEventSetup.CaloCaloCorrelation,
  tmEventSetup.CaloEsumCorrelation,
)

_conditionTypes[tmEventSetup.InvariantMass] = "InvariantMass"

conditionTypes = tuple(_conditionTypes)


# list of object types
# should match index in esConditionType enum of ../tmEventSetup/esTriggerMenu.hh
# should match names in ../tmGrammar/Object.hh
_objectTypes = [None] * tmEventSetup.nObjectType
_objectTypes[tmEventSetup.Muon] = tmGrammar.MU
_objectTypes[tmEventSetup.Egamma] = tmGrammar.EG
_objectTypes[tmEventSetup.Tau] = tmGrammar.TAU
_objectTypes[tmEventSetup.Jet] = tmGrammar.JET
_objectTypes[tmEventSetup.ETT] = tmGrammar.ETT
_objectTypes[tmEventSetup.HTT] = tmGrammar.HTT
_objectTypes[tmEventSetup.ETM] = tmGrammar.ETM
_objectTypes[tmEventSetup.HTM] = tmGrammar.HTM
_objectTypes[tmEventSetup.EXT] = tmGrammar.EXT

objectTypes = tuple(_objectTypes)


# list of cut types
# should match esCutType enum in ../tmEventSetup/esTriggerMenu.hh
Threshold = "Threshold"
Eta = "Eta"
Phi = "Phi"
DeltaEta = "DeltaEta"
DeltaPhi = "DeltaPhi"
Charge = "Charge"
Quality = "Quality"
Isolation = "Isolation"
ChargeCorrelation = "ChargeCorrelation"
DeltaR = "DeltaR"
Mass = "Mass"

_cutTypes = [None]*tmEventSetup.nCutType
_cutTypes[tmEventSetup.Threshold] = Threshold
_cutTypes[tmEventSetup.Eta] = Eta
_cutTypes[tmEventSetup.Phi] = Phi
_cutTypes[tmEventSetup.Charge] = Charge
_cutTypes[tmEventSetup.Quality] = Quality
_cutTypes[tmEventSetup.Isolation] = Isolation
_cutTypes[tmEventSetup.DeltaEta] = DeltaEta
_cutTypes[tmEventSetup.DeltaPhi] = DeltaPhi
_cutTypes[tmEventSetup.DeltaR] = DeltaR
_cutTypes[tmEventSetup.Mass] = Mass
_cutTypes[tmEventSetup.ChargeCorrelation] = ChargeCorrelation

cutTypes = tuple(_cutTypes)


# template keywords
EtaFullRange = "EtaFullRange"
EtaW1UpperLimits = "EtaW1UpperLimits"
EtaW1LowerLimits = "EtaW1LowerLimits"
EtaW2Ignore = "EtaW2Ignore"
EtaW2UpperLimits = "EtaW2UpperLimits"
EtaW2LowerLimits = "EtaW2LowerLimits"

PhiFullRange = "PhiFullRange"
PhiW1UpperLimits = "PhiW1UpperLimits"
PhiW1LowerLimits = "PhiW1LowerLimits"
PhiW2Ignore = "PhiW2Ignore"
PhiW2UpperLimits = "PhiW2UpperLimits"
PhiW2LowerLimits = "PhiW2LowerLimits"

PhiW1UpperLimit = "PhiW1UpperLimit"
PhiW1LowerLimit = "PhiW1LowerLimit"
PhiW2UpperLimit = "PhiW2UpperLimit"
PhiW2LowerLimit = "PhiW2LowerLimit"

DiffEtaUpperLimit = "DiffEtaUpperLimit"
DiffEtaLowerLimit = "DiffEtaLowerLimit"
DiffPhiUpperLimit = "DiffPhiUpperLimit"
DiffPhiLowerLimit = "DiffPhiLowerLimit"

PtThresholds = "PtThresholds"
RequestedCharges = "RequestedCharges"
QualityLuts = "QualityLuts"
IsolationLuts = "IsolationLuts"
RequestedChargeCorrelation = "RequestedChargeCorrelation"
EtThreshold = "EtThreshold"
EtThresholds = "EtThresholds"
IsoLuts = "IsoLuts"



# -----------------------------------------------------------------------------
#  Helpers
# -----------------------------------------------------------------------------
class Object:
  def __init__(self):
    logging.debug(self.__class__.__name__)
    pass


def sortDictByKey(iDict, iKey, reverse):
  return sorted(iDict, key=lambda x: iDict[x][iKey], reverse=reverse)


def getCutDict(cutDict, cutType):
  #logging.debug(cutType)
  rc = []
  for c in cutDict:
    if cutDict[c][keyCutType] == cutType:
      rc.append(cutDict[c])
  return rc


def bx_encode(value):
  logging.debug(value)
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


def chargeFormat(ch):
  logging.debug(ch)

  if str(ch).lower() in ["positive", "pos", "1"]:
    charge = "pos"
  elif str(ch).lower() in ["negative", "neg", "-1"]:
    charge = "neg"
  else:
    print "CANT RECOGNIZE REQUESTED CHARGE. WILL BE IGNORED"
    charge = "ign"
  return charge


def getObjectTemplate(condition):
  logging.debug(condition)

  template = {}

  ####################     Common Dictionaries     ####################
  EtaRangeDict = {
    EtaFullRange:     [ 'false', 'false', 'false', 'false' ],
    EtaW1UpperLimits: [ 0, 0, 0, 0 ],
    EtaW1LowerLimits: [ 0, 0, 0, 0 ],
    EtaW2Ignore:      [ 'false', 'false', 'false', 'false' ],
    EtaW2UpperLimits: [ 0, 0, 0, 0 ],
    EtaW2LowerLimits: [ 0, 0, 0, 0 ],
  }

  PhiRangeDict = {
    PhiFullRange:     [ 'false', 'false', 'false', 'false' ],
    PhiW1UpperLimits: [ 0, 0, 0, 0 ],
    PhiW1LowerLimits: [ 0, 0, 0, 0 ],
    PhiW2Ignore:      [ 'false', 'false', 'false', 'false' ],
    PhiW2UpperLimits: [ 0, 0, 0, 0 ],
    PhiW2LowerLimits: [ 0, 0, 0, 0 ],
  }

  EtaPhiDiffDict = {
    DiffEtaUpperLimit: 0,
    DiffEtaLowerLimit: 0,
    DiffPhiUpperLimit: 0,
    DiffPhiLowerLimit: 0,
  }


  if condition in MuonCondition:
    logging.debug("MuonCondition")

    template[keyMuonConditionDict] = {
      PtThresholds:               [ 0, 0, 0, 0 ],
      RequestedCharges:           [ "ign","ign","ign","ign" ],
      QualityLuts:                [ 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF ],
      IsolationLuts:              [ 0xF, 0xF, 0xF, 0xF ],
      RequestedChargeCorrelation: "ig",
    }
    for dct in [EtaRangeDict, PhiRangeDict, EtaPhiDiffDict]:
      template[keyMuonConditionDict].update(dct)

  elif condition in CaloCondition:
    logging.debug("CaloCondition")

    template[keyCaloConditionDict] = {
      EtThresholds: [ 0, 0, 0, 0 ],
      IsoLuts:      [ 0xF, 0xF, 0xF, 0xF ],
      #IsoLuts:      [ 0xF, 0xF, 0xF, 0xF ],
    }
    for dct in [EtaRangeDict,  PhiRangeDict, EtaPhiDiffDict]:
      template[keyCaloConditionDict].update(dct)

  elif condition in EsumCondition:
    logging.debug("EsumCondition")

    template[keyEsumsConditionDict] = {
      EtThreshold:      [ "0" ],
      PhiFullRange:     [ 'false' ],
      PhiW1UpperLimits: [ 0 ],
      PhiW1LowerLimits: [ 0 ],
      PhiW2Ignore:      [ 'false' ],
      PhiW2UpperLimits: [ 0 ],
      PhiW2LowerLimits: [ 0 ],
    }

  else:
    logging.error("Unknown condition: %s" % condition)
    raise NotImplementedError

  return template


def getDefaultTemplate(condition):
  logging.debug(condition)

  if condition in ObjectCondition:
    return getObjectTemplate(condition)

  else:
    logging.error("Unknown condition: %s" % condition)
    raise NotImplementedError


def getObjectType(condName):
  logging.debug(condName)

  objectType = []
  for objType in objectTypes:
    if objType in condName:
      objectType.append(objType)

  if len(objectType) == 1:
    return objectType[0]

  else:
    logging.error("Unknown condition: %s" % condName)
    raise NotImplementedError


def setEtaCuts(ii, condDict, cutDict):
  EtaCuts = getCutDict(cutDict, Eta)
  nEtaCuts = len(EtaCuts)
  if nEtaCuts == 0:
    condDict[EtaFullRange][ii] = 'true'

  else:
    condDict[EtaW1UpperLimits][ii] = EtaCuts[0][keyMaxIndex]
    condDict[EtaW1LowerLimits][ii] = EtaCuts[0][keyMinIndex]

    if nEtaCuts == 1:
      condDict[EtaW2Ignore][ii] = 'true'

    elif nEtaCuts == 2:
      condDict[EtaW2UpperLimits][ii] = EtaCuts[1][keyMaxIndex]
      condDict[EtaW2LowerLimits][ii] = EtaCuts[1][keyMinIndex]


def setPhiCuts(ii, condDict, cutDict):
  PhiCuts = getCutDict(cutDict, Phi)
  nPhiCuts = len(PhiCuts)
  if nPhiCuts == 0:
    condDict[PhiFullRange][ii] = 'true'

  else:
    condDict[PhiW1UpperLimits][ii] = PhiCuts[0][keyMaxIndex]
    condDict[PhiW1LowerLimits][ii] = PhiCuts[0][keyMinIndex]

    if nPhiCuts == 1:
      condDict[PhiW2Ignore][ii] = 'true'

    elif nPhiCuts == 2:
      condDict[PhiW2UpperLimits][ii] = PhiCuts[1][keyMaxIndex]
      condDict[PhiW2LowerLimits][ii] = PhiCuts[1][keyMinIndex]


def setDeltaEtaCuts(ii, condDict, cutDict):
  DeltaEtaCuts = getCutDict(cutDict, DeltaEta)
  nDeltaEtaCuts = len(DeltaEtaCuts)

  if nDeltaEtaCuts == 1:
    condDict[DiffEtaUpperLimit][ii] = DeltaEtaCuts[0][keyMaxIndex]
    condDict[DiffEtaLowerLimit][ii] = DeltaEtaCuts[0][keyMinIndex]


def setDeltaPhiCuts(ii, condDict, cutDict):
  DeltaPhiCuts = getCutDict(cutDict, DeltaPhi)
  nDeltaPhiCuts = len(DeltaPhiCuts)

  if nDeltaPhiCuts == 1:
    condDict[DiffPhiUpperLimit][ii] = DeltaPhiCuts[0][keyMaxIndex]
    condDict[DiffPhiLowerLimit][ii] = DeltaPhiCuts[0][keyMinIndex]


def getMuonCondition(ii, condDict, cutDict):
  condDict[PtThresholds][ii] = getCutDict(cutDict, Threshold)[0][keyMinIndex]

  array = []
  for c in cutDict:
    x = cutDict[c][keyCutType]
    if x == Threshold:
      array.append(cutDict[c][keyMinIndex])
  assert getCutDict(cutDict, Threshold)[0][keyMinIndex] == array[0]

  setEtaCuts(ii, condDict, cutDict)
  setPhiCuts(ii, condDict, cutDict)
  setDeltaEtaCuts(ii, condDict, cutDict)
  setDeltaPhiCuts(ii, condDict, cutDict)

  ChargeCuts = getCutDict(cutDict, Charge)
  nChargeCuts = len(ChargeCuts)
  if nChargeCuts:
    condDict[RequestedCharges][ii] = chargeFormat(ChargeCuts[0][keyData])

  QualityCuts = getCutDict(cutDict, Quality)
  nQualityCuts = len(QualityCuts)
  if nQualityCuts == 1:
    condDict[QualityLuts][ii] = QualityCuts[0][keyData]

  IsolationCuts = getCutDict(cutDict, Isolation)
  nIsolationCuts = len(IsolationCuts)
  if nIsolationCuts == 1:
    condDict[IsolationLuts][ii] = IsolationCuts[0][keyData]

  ChargeCorrelationCuts = getCutDict(cutDict, ChargeCorrelation)
  nChargeCorrelationCuts = len(ChargeCorrelationCuts)
  if nChargeCorrelationCuts == 1:
    condDict[ChargeCorrelation][ii] = ChargeCorrelationCuts[0][keyData]
    ## what is the actual output??



def getCaloCondition(ii, condDict, cutDict):
  condDict[EtThresholds][ii] = getCutDict(cutDict, Threshold)[0][keyMinIndex]

  setEtaCuts(ii, condDict, cutDict)
  setPhiCuts(ii, condDict, cutDict)
  setDeltaEtaCuts(ii, condDict, cutDict)
  setDeltaPhiCuts(ii, condDict, cutDict)

  IsoCuts = getCutDict(cutDict, Isolation)
  nIsoCuts = len(IsoCuts)
  if nIsoCuts == 1:
    condDict[IsoLuts][ii] = IsoCuts[0][keyData]


def getEsumCondition(ii, condDict, cutDict):
  condDict[EtThreshold][ii] = getCutDict(cutDict, Threshold)[0][keyMinIndex]

  setPhiCuts(ii, condDict, cutDict)


def setBxCombChgCor(dictionary):
  dictionary[keyBxComb] = []

  for algoName in dictionary[keyAlgoDict]:
    algo = dictionary[keyAlgoDict][algoName][keyAlgo]
    for condName in dictionary[keyAlgoDict][algoName][keyCondDict]:
      condType = dictionary[keyAlgoDict][algoName][keyCondDict][condName][keyTriggerGroup]

      bxSet = []
      # TODO: handle MuonMuonCorrelation
      if condType in (conditionTypes[tmEventSetup.DoubleMuon],
                      conditionTypes[tmEventSetup.TripleMuon],
                      conditionTypes[tmEventSetup.QuadMuon]):
        for x in dictionary[keyAlgoDict][algoName][keyCondDict][condName][keyObjList]:
          bxSet.append(x['Bx'])
        bxSet = list(set(bxSet))
        if len(bxSet) == 1:
          bxCombination = bxSet[0], bxSet[0]
          dictionary[keyBxComb].append(bxCombination)
        else:
          raise NotImplementedError


def getReport(menu, vhdlVersion=False):
  data = Object()
  data.reporter = {}
  menuName = menu.getName()

  triggerGroups = {}
  for key in conditionTypes:
    triggerGroups[key] = {keyNBits: 0, keyBits: []}

  data.reporter[keyTriggerGroups] = triggerGroups
  data.reporter[keyAlgoMap] = menu.getAlgorithmMapPtr()
  data.reporter[keyCondMap] = menu.getConditionMapPtr()
  data.reporter[keyScaleMap] = menu.getScaleMapPtr()

  algoDict = {}
  for key, algo in data.reporter[keyAlgoMap].iteritems():
    value = {keyAlgo: algo}
    value.update( {keyIndex: algo.getIndex()} )
    value.update( {keyExp: algo.getExpression()} )
    value.update( {keyCondDict: {}} )
    value.update( {keyModuleId: algo.getModuleId()} )
    value.update( {keyModuleIndex: algo.getModuleIndex()} )
    algoDict[algo.getName()] =  value
  data.reporter[keyAlgoDict] = algoDict

  if vhdlVersion:
    version = vhdlVersion.rsplit(".")
    value = {"L1TMenuUUIDHex": uuid.uuid5(uuid.NAMESPACE_DNS, menuName).hex }
    value.update( {"L1TMenuUUID": uuid.uuid5(uuid.NAMESPACE_DNS, menuName)} )
    value.update( {"L1TMenuUUID": uuid.uuid5(uuid.NAMESPACE_DNS, menuName)} )
    value.update( {"L1TMenuNameHex": hexlify(menu.getName()[::-1]).zfill(256)} )
    value.update( {"L1TMenuFirmwareUUID": uuid.uuid1()} )
    value.update( {"L1TMenuFirmwareUUIDHex": uuid.uuid1().hex} )
    value.update( {"L1TMCompilerVersionMajor": version[0]} )
    value.update( {"L1TMCompilerVersionMinor": version[1]} )
    value.update( {"L1TMCompilerVersionRevision": version[2]} )
    value.update( {"L1TMenuName": menuName} )
    value.update( {"L1TMenuScaleSet": None} )

    data.reporter[keyMenuInfo] = value

  condInUse = []
  for algoName in data.reporter[keyAlgoDict]:
    algoDict = data.reporter[keyAlgoDict][algoName]
    condDict = {}
    for x in algoDict[keyAlgo].getRpnVector():
      if tmGrammar.isGate(x): continue
      condition = x
      if condition in condInUse: continue
      condInUse.append(condition)
      cond = data.reporter[keyCondMap][condition]
      condName = cond.getName()
      condDict = { keyObjType: getObjectType(condName) }
      condDict.update( {keyCond: cond} )
      condDict.update( {keyCondition: condition} )
      condDict.update( {keyType: cond.getType()} )
      condDict.update( {keyTriggerGroup: conditionTypes[cond.getType()]} )
      condDict.update( {keyConditionTemplates: getDefaultTemplate(cond.getType())} )
      algoDict[keyCondDict][condName] = condDict

      if condDict[keyType] in MuonCondition:
        muCondDict = condDict[keyConditionTemplates][keyMuonConditionDict]

      elif condDict[keyType] in CaloCondition:
        caloCondDict = condDict[keyConditionTemplates][keyCaloConditionDict]

      elif condDict[keyType] in EsumCondition:
        esumsCondDict = condDict[keyConditionTemplates][keyEsumsConditionDict]

      else:
        logging.error("Unknown condition: %s" % condDcit[keyType])
        raise NotImplementedError

      for cut in condDict[keyCond].getCuts():
        print cut
      condDict[keyObjDict] = {}
      condDict[keyObjList] = []
      for obj in condDict[keyCond].getObjects():
        objName = obj.getName()

        objDict = { keyObjType: objectTypes[obj.getType()] }
        objDict.update( {keyName: objName} )
        objDict.update( {keyType: obj.getType()} )
        objDict.update( {keyOp: obj.getComparisonOperator () == 0} )
        objDict.update( {keyObj: obj} )
        objDict.update( {keyBx: bx_encode(obj.getBxOffset())} )
        objDict.update( {keyBxOffset: obj.getBxOffset()} )

        objDict[keyCutDict] = {}
        for cut in obj.getCuts():
          cutName = cut.getName()
          value = { keyName: cutName }
          value.update( {keyCut: cut } )
          value.update( {keyTarget: cut.getObjectType()} )
          value.update( {keyCutType: cutTypes[cut.getCutType()]} )
          value.update( {keyType: cut.getCutType()} )
          value.update( {keyMinVal: cut.getMinimum().value} )
          value.update( {keyMinIndex: cut.getMinimum().index} )
          value.update( {keyMaxVal: cut.getMaximum().value} )
          value.update( {keyMaxIndex: cut.getMaximum().index} )
          value.update( {keyData: cut.getData()} )
          objDict[keyCutDict][cutName] = value

        condDict[keyObjDict][objName] = objDict
        condDict[keyObjList].append( condDict[keyObjDict][objName] )

      for ii in range(len(condDict[keyObjList])):
        objDict = condDict[keyObjList][ii]
        cutDict = condDict[keyObjList][ii][keyCutDict]

        if condDict[keyType] in MuonCondition:
          getMuonCondition(ii, muCondDict, cutDict)

        elif condDict[keyType] in CaloCondition:
          getCaloCondition(ii, caloCondDict, cutDict)

        elif condDict[keyType] in EsumCondition:
          getEsumCondition(ii, esumsCondDict, cutDict)

        else:
          logging.error("unknown condition: %s" % condDict[keyType])
          raise NotImplementedError

         
  for algoName in data.reporter[keyAlgoDict]:
    algo = data.reporter[keyAlgoDict][algoName][keyAlgo]
    for condName in data.reporter[keyAlgoDict][algoName][keyCondDict]:
      condType = data.reporter[keyAlgoDict][algoName][keyCondDict][condName][keyTriggerGroup]
      data.reporter[keyTriggerGroups][condType][keyNBits] += 1
      value = {keyIndex: data.reporter[keyAlgoDict][algoName][keyIndex]}
      value.update( {keyAlgoName: algoName} )
      data.reporter[keyTriggerGroups][condType][keyBits].append(value)

  data.reporter[keyNBitsSorted] = sortDictByKey(data.reporter[keyTriggerGroups],
                                                keyNBits, True)
  data.reporter[keyIndexSorted] = sortDictByKey(data.reporter[keyAlgoDict],
                                                keyIndex, False)
  n = 0
  for tg in data.reporter[keyTriggerGroups]:
    n += data.reporter[keyTriggerGroups][tg][keyNBits]
  data.reporter[keyNAlgoDefined] = n

  condList = []
  for algoName in data.reporter[keyIndexSorted]:
    condList.extend(data.reporter[keyAlgoDict][algoName][keyCondDict].keys())
  data.reporter[keyConditionSet] = set(condList)

  setBxCombChgCor(data.reporter)
  print data.reporter[keyBxComb]

  return data

# eof
