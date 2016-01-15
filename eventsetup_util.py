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
keyTriggerGroups = "TriggerGroups"
keyCondMap = "condMap"

keyCutDict = "cutDict"
keyObjList = "objList"

keyBxComb = "bxComb"


# keys for algoDict
#   reporter[keyAlgoDict][<algoName>]
keyAlgo = "algo"
keyExp = "exp"
keyExpInCond = "expInCond"
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
keyEsumsConditionDict = "esums_condition_dict"
keyMuonMuonCorrelationConditionDict = "muon_muon_correlation_condition_dict"
keyMuonEsumCorrelationConditionDict = "muon_esum_correlation_condition_dict"
keyCaloMuonCorrelationConditionDict = "calo_muon_correlation_condition_dict"
keyCaloCaloCorrelationConditionDict = "calo_calo_correlation_condition_dict"
keyCaloEsumCorrelationConditionDict = "calo_esum_correlation_condition_dict"
keyInvariantMassConditionDict = "invariant_condition_dict"


# keys for objDict
#   reporter[keyAlgoDict][keyCondDict][<condName>][keyObjDict][<objName>]


# keys for cutDict
#   reporter[keyAlgoDict][<algoName>][keyCondDict][<condName>][keyObjList][ii][keyCutDict][<cutName>]
keyMinIndex = "minIndex"
keyMaxVal = "maxVal"
keyCut = "cut"
keyName = "name"
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


# list of cut types: esCutType enum in ../tmEventSetup/esTypes.hh


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


def sortDictByIndex(iDict, reverse):
  return sorted(iDict, key=lambda x: iDict[x].index, reverse=reverse)


def getCuts(cutDict, cutType):
  rc = []
  for c in cutDict:
    if cutDict[c].type == cutType:
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
    print "CAN'T RECOGNIZE REQUESTED CHARGE. WILL BE IGNORED"
    charge = "ign"
  return charge


def getObjectTemplate(index):
  logging.debug(index)

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


  if index in MuonCondition:
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

  elif index in CaloCondition:
    logging.debug("CaloCondition")

    template[keyCaloConditionDict] = {
      EtThresholds: [ 0, 0, 0, 0 ],
      IsoLuts:      [ 0xF, 0xF, 0xF, 0xF ],
      #IsoLuts:      [ 0xF, 0xF, 0xF, 0xF ],
    }
    for dct in [EtaRangeDict,  PhiRangeDict, EtaPhiDiffDict]:
      template[keyCaloConditionDict].update(dct)

  elif index in EsumCondition:
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
    logging.error("Unknown condition: %s" % index)
    raise NotImplementedError

  return template


def getMuonMuonCorrelationTemplate():
  logging.debug("getMuonMuonCorrelationTemplate")

  template = {}
  template[keyMuonMuonCorrelationConditionDict] = {}
  object1 = {}
  object2 = {}

  conditionTemplate = {
    'objectsInSameBx': 'true',
    'hasDetaCut': 'false',
    'hasDphiCut': 'false',
    'hasDrCut': 'false',
    'hasMassCut': 'false',
    RequestedChargeCorrelation: "ig",
    'DiffEtaUpperLimit': 0,
    'DiffEtaLowerLimit': 0,
    'DiffPhiUpperLimit': 0,
    'DiffPhiLowerLimit': 0,
    'DeltaRUpperLimit': 0,
    'DeltaRLowerLimit': 0,
    'InvMassUpperLimit': 0,
    'InvMassLowerLimit': 0,
  }

  template[keyMuonMuonCorrelationConditionDict].update(conditionTemplate)

  objectTemplate = {
    keyOp: 'true',
    EtThreshold: "0",
    EtaFullRange:     'false',
    EtaW1UpperLimits: 0,
    EtaW1LowerLimits: 0,
    EtaW2Ignore:      'false',
    EtaW2UpperLimits: 0,
    EtaW2LowerLimits: 0,
    PhiFullRange:     'false',
    PhiW1UpperLimits: 0,
    PhiW1LowerLimits: 0,
    PhiW2Ignore:      'false',
    PhiW2UpperLimits: 0,
    PhiW2LowerLimits: 0,
    RequestedCharges: "ign",
    QualityLuts:      0xFFFF,
    IsolationLuts:    0xF,
    keyBx: "0"
  }

  object1.update(objectTemplate)
  object2.update(objectTemplate)

  template[keyMuonMuonCorrelationConditionDict]['obj1'] = object1
  template[keyMuonMuonCorrelationConditionDict]['obj2'] = object2

  return template


def getInvariantMassTemplate(index, condition):
  logging.info("getInvariantMassTemplate")

  objects = condition.getObjects()
  if len(objects) != 2:
    logging.error("# of objects != 2")
    raise NotImplementedError

  combination = tmEventSetup.getObjectCombination(objects[0].getType(), objects[1].getType())
  if combination == tmEventSetup.MuonMuonCombination:
    return getMuonMuonCorrelationTemplate()

  elif combination == tmEventSetup.MuonEsumCombination:
    return getMuonEsumCorrelationTemplate()

  elif combination == tmEventSetup.CaloMuonCombination:
    return getCaloMuonCorrelationTemplate()

  elif combination == tmEventSetup.CaloCaloCombination:
    return getCaloCaloCorrelationTemplate()

  elif combination == tmEventSetup.CaloEsumCombination:
    return getCaloEsumCorrelationTemplate()

  else:
    logging.error("Unknown combination: %s" % combination)
    raise NotImplementedError


def getCorrelationTemplate(index):
  if index == tmEventSetup.MuonMuonCorrelation:
    return getMuonMuonCorrelationTemplate()

  elif index == tmEventSetup.MuonEsumCorrelation:
    return getMuonEsumCorrelationTemplate()

  elif index == tmEventSetup.CaloMuonCorrelation:
    return getCaloMuonCorrelationTemplate()

  elif index == tmEventSetup.CaloCaloCorrelation:
    return getCaloCaloCorrelationTemplate()

  elif index == tmEventSetup.CaloEsumCorrelation:
    return getCaloEsumCorrelationTemplate()

  else:
    logging.error("Unknown condition: %s" % index)
    raise NotImplementedError


def getDefaultTemplate(index, condition):
  logging.debug(index)

  if index in ObjectCondition:
    return getObjectTemplate(index)

  elif index in CorrelationCondition:
    return getCorrelationTemplate(index)

  elif index == tmEventSetup.InvariantMass:
    return getInvariantMassTemplate(index, condition)

  else:
    logging.error("Unknown condition: %s" % index)
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
    for ii in CorrelationCondition:
      if _conditionTypes[ii] in condName:
        return _conditionTypes[ii]
    if _conditionTypes[tmEventSetup.InvariantMass] in condName:
      return _conditionTypes[tmEventSetup.InvariantMass]

    logging.error("Unknown condition: %s" % condName)
    raise NotImplementedError


def setEtaCuts(ii, condDict, cutDict):
  EtaCuts = getCuts(cutDict, tmEventSetup.Eta)
  nEtaCuts = len(EtaCuts)
  if nEtaCuts == 0:
    condDict[EtaFullRange][ii] = 'true'

  else:
    condDict[EtaW1UpperLimits][ii] = EtaCuts[0].max_idx
    condDict[EtaW1LowerLimits][ii] = EtaCuts[0].min_idx

    if nEtaCuts == 1:
      condDict[EtaW2Ignore][ii] = 'true'

    elif nEtaCuts == 2:
      condDict[EtaW2UpperLimits][ii] = EtaCuts[1].max_idx
      condDict[EtaW2LowerLimits][ii] = EtaCuts[1].min_idx


def setPhiCuts(ii, condDict, cutDict):
  PhiCuts = getCuts(cutDict, tmEventSetup.Phi)
  nPhiCuts = len(PhiCuts)
  if nPhiCuts == 0:
    condDict[PhiFullRange][ii] = 'true'

  else:
    condDict[PhiW1UpperLimits][ii] = PhiCuts[0].max_idx
    condDict[PhiW1LowerLimits][ii] = PhiCuts[0].min_idx

    if nPhiCuts == 1:
      condDict[PhiW2Ignore][ii] = 'true'

    elif nPhiCuts == 2:
      condDict[PhiW2UpperLimits][ii] = PhiCuts[1].max_idx
      condDict[PhiW2LowerLimits][ii] = PhiCuts[1].min_idx


def setDeltaEtaCuts(ii, condDict, cutDict):
  DeltaEtaCuts = getCuts(cutDict, tmEventSetup.DeltaEta)
  nDeltaEtaCuts = len(DeltaEtaCuts)

  if nDeltaEtaCuts == 1:
    condDict[DiffEtaUpperLimit][ii] = DeltaEtaCuts[0].max_idx
    condDict[DiffEtaLowerLimit][ii] = DeltaEtaCuts[0].min_idx


def setDeltaPhiCuts(ii, condDict, cutDict):
  DeltaPhiCuts = getCuts(cutDict, tmEventSetup.DeltaPhi)
  nDeltaPhiCuts = len(DeltaPhiCuts)

  if nDeltaPhiCuts == 1:
    condDict[DiffPhiUpperLimit][ii] = DeltaPhiCuts[0].max_idx
    condDict[DiffPhiLowerLimit][ii] = DeltaPhiCuts[0].min_idx


def getMuonCondition(ii, condDict, cutDict, condCuts):
  condDict[PtThresholds][ii] = getCuts(cutDict, tmEventSetup.Threshold)[0].min_idx

  array = []
  for c in cutDict:
    x = cutDict[c].type
    if x == tmEventSetup.Threshold:
      array.append(cutDict[c].min_idx)
  assert getCuts(cutDict, tmEventSetup.Threshold)[0].min_idx == array[0]

  setEtaCuts(ii, condDict, cutDict)
  setPhiCuts(ii, condDict, cutDict)
  setDeltaEtaCuts(ii, condDict, cutDict)
  setDeltaPhiCuts(ii, condDict, cutDict)

  ChargeCuts = getCuts(cutDict, tmEventSetup.Charge)
  nChargeCuts = len(ChargeCuts)
  if nChargeCuts:
    condDict[RequestedCharges][ii] = chargeFormat(ChargeCuts[0].data)

  QualityCuts = getCuts(cutDict, tmEventSetup.Quality)
  nQualityCuts = len(QualityCuts)
  if nQualityCuts == 1:
    condDict[QualityLuts][ii] = QualityCuts[0].data

  IsolationCuts = getCuts(cutDict, tmEventSetup.Isolation)
  nIsolationCuts = len(IsolationCuts)
  if nIsolationCuts == 1:
    condDict[IsolationLuts][ii] = IsolationCuts[0].data

  nCondCuts = len(condCuts)
  if nCondCuts == 0:
    pass
  elif nCondCuts == 1:
    condDict[RequestedChargeCorrelation] = condCuts[0][keyData]
  else:
    raise NotImplementedError


def getCaloCondition(ii, condDict, cutDict):
  condDict[EtThresholds][ii] = getCuts(cutDict, tmEventSetup.Threshold)[0].min_idx

  setEtaCuts(ii, condDict, cutDict)
  setPhiCuts(ii, condDict, cutDict)
  setDeltaEtaCuts(ii, condDict, cutDict)
  setDeltaPhiCuts(ii, condDict, cutDict)

  IsoCuts = getCuts(cutDict, tmEventSetup.Isolation)
  nIsoCuts = len(IsoCuts)
  if nIsoCuts == 1:
    condDict[IsoLuts][ii] = IsoCuts[0].data


def getEsumCondition(ii, condDict, cutDict):
  condDict[EtThreshold][ii] = getCuts(cutDict, tmEventSetup.Threshold)[0].min_idx

  setPhiCuts(ii, condDict, cutDict)


def setBxCombChgCor(dictionary):
  dictionary[keyBxComb] = set()

  for algoName in dictionary[keyAlgoDict]:
    for condName in dictionary[keyAlgoDict][algoName].conditions:
      condType = dictionary[keyAlgoDict][algoName].conditions[condName].type

      bxSet = []
      # TODO: handle MuonMuonCorrelation
      if condType in (conditionTypes[tmEventSetup.DoubleMuon],
                      conditionTypes[tmEventSetup.TripleMuon],
                      conditionTypes[tmEventSetup.QuadMuon]):
        for x in dictionary[keyAlgoDict][algoName].conditions[condName].objects:
          bxSet.append(x.bx)
        bxSet = list(set(bxSet))
        if len(bxSet) == 1:
          bxCombination = bxSet[0], bxSet[0]
          dictionary[keyBxComb].add(bxCombination)
        else:
          raise NotImplementedError


def updateExpressionInCondition(algo, cond):
  if cond.getType() != tmEventSetup.Externals:
    raise NotImplementedError

  if len(cond.getObjects()) != 1:
    raise NotImplementedError

  obj = cond.getObjects()[0]
  signal = "ext_cond_bx_" + bx_encode(obj.getBxOffset()) + "(%s)" % obj.getExternalChannelId()
  algo.expression_in_condition = algo.expression_in_condition.replace(cond.getName(), signal)


def setMenuInfo(menu, data, version="0.0.0"):
  menuName = menu.getName()

  data.info = Object()
  data.info.uuid = uuid.uuid5(uuid.NAMESPACE_DNS, menuName)
  data.info.uuid_hex = data.info.uuid.hex
  data.info.name_in_hex = hexlify(menu.getName()[::-1]).zfill(256)
  data.info.fw_uuid = uuid.uuid1()
  data.info.fw_uuid_hex = data.info.fw_uuid.hex
  data.info.name = menuName
  data.info.scale_set = menu.getScaleSetName()
  data.info.svn_revision_number = menu.sw_revision_svn

  data.info.sw_version_major, data.info.sw_version_minor, data.info.sw_version_patch = version.rsplit('.')

  return


def getCutInfo(cut):
  o = Object()
  o.name = cut.getName()
  o.cut = cut
  o.target = cut.getObjectType()
  o.type = cut.getCutType()
  o.min_val = cut.getMinimum().value
  o.min_idx = cut.getMinimum().index
  o.max_val = cut.getMaximum().value
  o.max_idx = cut.getMaximum().index
  o.data = cut.getData()

  return o


def getObjectInfo(obj):
  o = Object()
  o.type = objectTypes[obj.getType()]
  o.name = obj.getName()
  o.operator = obj.getComparisonOperator() == 0
  o.object = obj
  o.bx = bx_encode(obj.getBxOffset())
  o.bx_offset = obj.getBxOffset()
  o.cuts = {}

  for cut in obj.getCuts():
    o.cuts[cut.getName()] = getCutInfo(cut)

  return o


def getConditionInfo(cond, token):
  condition = Object()
  condition.name = cond.getName()
  condition.token = token
  condition.type = conditionTypes[cond.getType()]
  condition.type_id = cond.getType()
  condition.cuts = []
  condition.template = getDefaultTemplate(condition.type_id, cond)

  condCuts = []
  for cut in cond.getCuts():
    o = Object()
    o.name = cut.getName()
    o.target = cut.getObjectType()
    o.type = cut.getCutType()
    o.min_val = cut.getMinimum().value
    o.min_idx = cut.getMinimum().index
    o.max_val = cut.getMaximum().value
    o.max_idx = cut.getMaximum().index
    o.data = cut.getData()
    condition.cuts.append(o)

  condition.objects = []
  for obj in cond.getObjects():
    condition.objects.append(getObjectInfo(obj))

  return condition


def getAlgorithmInfo(algo):
  algorithm = Object()
  algorithm.index = algo.getIndex()
  algorithm.expression = algo.getExpression()
  algorithm.expression_in_condition = algo.getExpressionInCondition()
  algorithm.conditions = {}
  algorithm.module_id = algo.getModuleId()
  algorithm.module_index = algo.getModuleIndex()
  algorithm.rpn_vector = algo.getRpnVector()
  return algorithm


def getReport(menu, version=False):
  data = Object()
  data.reporter = {}

  setMenuInfo(menu, data, version)

  triggerGroups = {}
  for key in conditionTypes:
    triggerGroups[key] = {keyNBits: 0, keyBits: []}

  data.reporter[keyTriggerGroups] = triggerGroups
  data.reporter[keyAlgoMap] = menu.getAlgorithmMapPtr()
  data.reporter[keyCondMap] = menu.getConditionMapPtr()
  data.reporter[keyScaleMap] = menu.getScaleMapPtr()

  algoDict = {}
  for key, algo in data.reporter[keyAlgoMap].iteritems():
    algoDict[algo.getName()] = getAlgorithmInfo(algo)
  data.reporter[keyAlgoDict] = algoDict


  condInUse = []
  for algoName in data.reporter[keyAlgoDict]:
    algorithm = data.reporter[keyAlgoDict][algoName]
    for token in algorithm.rpn_vector:
      if tmGrammar.isGate(token): continue

      cond_token = token
      cond = data.reporter[keyCondMap][cond_token]
      if cond.getType() == tmEventSetup.Externals:
        updateExpressionInCondition(algorithm, cond)
        continue

      if cond_token in condInUse: continue
      condInUse.append(cond_token)

      condition = getConditionInfo(cond, cond_token)
      algorithm.conditions[condition.name] = condition

      if condition.type_id in ObjectCondition:
        if condition.type_id in MuonCondition:
          muCondDict = condition.template[keyMuonConditionDict]

        elif condition.type_id in CaloCondition:
          caloCondDict = condition.template[keyCaloConditionDict]

        elif condition.type_id in EsumCondition:
          esumsCondDict = condition.template[keyEsumsConditionDict]

        else:
          logging.error("Unknown condition: %s" % condition.type)
          raise NotImplementedError

        for ii in range(len(condition.objects)):
          objDict = condition.objects[ii]
          cutDict = objDict.cuts

          if condition.type_id in MuonCondition:
            getMuonCondition(ii, muCondDict, cutDict, condition.cuts)

          elif condition.type_id in CaloCondition:
            getCaloCondition(ii, caloCondDict, cutDict)

          elif condition.type_id in EsumCondition:
            getEsumCondition(ii, esumsCondDict, cutDict)

          else:
            logging.error("unknown condition: %s" % condDict[keyType])
            raise NotImplementedError

      else:
        combination = tmEventSetup.getObjectCombination(cond.getObjects()[0].getType(), cond.getObjects()[1].getType())
        if combination == tmEventSetup.MuonMuonCombination:
          condDict[keyType] = tmEventSetup.MuonMuonCorrelation
          corrCondDict = condDict[keyConditionTemplates][keyMuonMuonCorrelationConditionDict]

        elif combination == tmEventSetup.MuonEsumCombination:
          condDict[keyType] = tmEventSetup.MuonEsumCorrelation
          corrCondDict = condDict[keyConditionTemplates][keyMuonEsumCorrelationConditionDict]

        elif combination == tmEventSetup.CaloMuonCombination:
          condDict[keyType] = tmEventSetup.CaloMuonCorrelation
          corrCondDict = condDict[keyConditionTemplates][keyCaloMuonCorrelationConditionDict]

        elif combination == tmEventSetup.CaloCaloCombination:
          condDict[keyType] = tmEventSetup.CaloCaloCorrelation
          corrCondDict = condDict[keyConditionTemplates][keyCaloCaloCorrelationConditionDict]

        elif combination == tmEventSetup.CaloEsumCombination:
          condDict[keyType] = tmEventSetup.CaloEsumCorrelation
          corrCondDict = condDict[keyConditionTemplates][keyCaloEsumCorrelationConditionDict]

        else:
          logging.error("Unknown combination: %s" % combination)
          raise NotImplementedError


  for algoName in data.reporter[keyAlgoDict]:
    for condName in data.reporter[keyAlgoDict][algoName].conditions:
      condType = data.reporter[keyAlgoDict][algoName].conditions[condName].type
      data.reporter[keyTriggerGroups][condType][keyNBits] += 1
      value = {keyIndex: data.reporter[keyAlgoDict][algoName].index}
      value.update( {keyAlgoName: algoName} )
      data.reporter[keyTriggerGroups][condType][keyBits].append(value)

  data.reporter[keyNBitsSorted] = sortDictByKey(data.reporter[keyTriggerGroups],
                                                keyNBits, True)
  data.reporter[keyIndexSorted] = sortDictByIndex(data.reporter[keyAlgoDict],
                                                  False)
  n = 0
  for tg in data.reporter[keyTriggerGroups]:
    n += data.reporter[keyTriggerGroups][tg][keyNBits]
  data.reporter[keyNAlgoDefined] = n

  condList = []
  for algoName in data.reporter[keyIndexSorted]:
    condList.extend(data.reporter[keyAlgoDict][algoName].conditions.keys())
  data.reporter[keyConditionSet] = set(condList)

  setBxCombChgCor(data.reporter)

  return data

# eof
