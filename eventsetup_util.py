#!/bin/env python

import logging
import uuid
from binascii import hexlify as hexlify

import tmGrammar
import tmEventSetup


# data.reporter[keys]
#   keys for reporter
keyAlgoMap = "algoMap"
keyCondMap = "condMap"
keyScaleMap = "scaleMap"

keyTriggerGroupsDict = "TriggerGroupsDict"
keyTriggerGroups = "TriggerGroups"

keyAlgoDict = "algoDict"
keyCondDict = "condDict"
keyTranslate = "translate"

keyNBitsSorted = "nBits_sorted"
keyIndexSorted = "index_sorted"
keyNAlgoDefined = "nAlgoDefined"
keyConditionSet = "conditionSet"
keyBxComb = "bxComb"
keyObjInCorr = "ObjectsInCorrelations"
keyObjForScaleConv = "ObjectsForScaleConversion"
keyObjPairForCorr = "ObjectPairForCorrelation"

# data.reporter[keyAlgoDict] = {<algorithm_name>}
#
# algorithm = data.reporter[keyAlgoDict][<algorithm_name>]
# algorithm.index
#          .module_id
#          .module_index
#          .rpn_vector
#          .expression
#          .expression_in_condition
#          .conditions{<condition_name>}
#          .conditionNames[]
#
# condition = data.reporter[keyCondDict][<condition_name>]
# condition = algorithm.conditions[<condition_name>]
# condition.name
#          .token
#          .type
#          .type_id
#          .template
#          .objects[]
#          .cuts[]
#
# object.name
#       .type
#       .type_id
#       .operator
#       .bx
#       .bx_offset
#       .cuts{<cutName>}
#
# cut.name
#    .target
#    .type
#    .min_val
#    .min_idx
#    .max_val
#    .max_idx
#    .data
#

# keys for reporter[keyTriggerGroupsDict][<conditionType>]
keyIndex = "index"
keyNBits = "nBits"
keyBits = "bits"

# keys for reporter[keyTriggerGroupsDict][<conditionType>][keyBits][ii]
keyAlgoName = 'algoName'
keyAlgo     = 'algo'

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
_cutTypes = [None] * tmEventSetup.nCutType
_cutTypes[tmEventSetup.Threshold] = "Threshold"
_cutTypes[tmEventSetup.Eta] = "Eta"
_cutTypes[tmEventSetup.Phi] = "Phi"
_cutTypes[tmEventSetup.Charge] = "Charge"
_cutTypes[tmEventSetup.Quality] = "Quality"
_cutTypes[tmEventSetup.Isolation] = "Isolation"
_cutTypes[tmEventSetup.DeltaEta] = "DeltaEta"
_cutTypes[tmEventSetup.DeltaPhi] = "DeltaPhi"
_cutTypes[tmEventSetup.DeltaR] = "DeltaR"
_cutTypes[tmEventSetup.Mass] = "Mass"
_cutTypes[tmEventSetup.ChargeCorrelation] = "ChargeCorrelation"

cutTypes = tuple(_cutTypes)



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

  if str(ch).lower() in ("positive", "pos", "1"):
    charge = "pos"

  elif str(ch).lower() in ("negative", "neg", "-1"):
    charge = "neg"

  else:
    print "CAN'T RECOGNIZE REQUESTED CHARGE. WILL BE IGNORED"
    charge = "ign"

  return charge


def addThresholdTemplate(template, n=4):
  logging.debug("addThresholdTemplate")

  template.Thresholds = [ 0 ] * n


def addIsolationTemplate(template, lut=0xF, n=4):
  logging.debug("addIsolationTemplate")

  template.IsolationLUTs = [ lut ] * n


def addQualityTemplate(template, lut=0xFFFF, n=4):
  logging.debug("addIsolationTemplate")

  template.QualityLUTs = [ lut ] * n


def addChargeTemplate(template, n=4):
  logging.debug("addChargeTemplate")

  template.Charges = [ "ign" ] * n


def addChargeCorrelationTemplate(template):
  logging.debug("addChargeCorrelationTemplate")

  template.ChargeCorrelation = "ig"


def addEtaTemplate(template, n=4):
  logging.debug("addEtaTemplate")

  template.EtaFullRange = [ 'false' ] * n
  template.EtaW1LowerLimits = [ 0 ] * n
  template.EtaW1UpperLimits = [ 0 ] * n

  template.EtaW2Ignore = [ 'false' ] * n
  template.EtaW2LowerLimits = [ 0 ] * n
  template.EtaW2UpperLimits = [ 0 ] * n


def addPhiTemplate(template, n=4):
  logging.debug("addPhiTemplate")

  template.PhiFullRange = [ 'false' ] * n
  template.PhiW1LowerLimits = [ 0 ] * n
  template.PhiW1UpperLimits = [ 0 ] * n

  template.PhiW2Ignore =      [ 'false' ] * n
  template.PhiW2LowerLimits = [ 0 ] * n
  template.PhiW2UpperLimits = [ 0 ] * n


def getCalorimeterTemplate():
  logging.debug("getCalorimeterTemplate")

  template = Object()

  addThresholdTemplate(template)
  addIsolationTemplate(template)
  addEtaTemplate(template)
  addPhiTemplate(template)

  template.DiffEtaUpperLimit = 0
  template.DiffEtaLowerLimit = 0
  template.DiffPhiUpperLimit = 0
  template.DiffPhiLowerLimit = 0

  return template


def getMuonTemplate():
  logging.debug("getMuonTemplate")

  template = Object()

  addThresholdTemplate(template)
  addIsolationTemplate(template)
  addEtaTemplate(template)
  addPhiTemplate(template)
  addQualityTemplate(template)
  addChargeTemplate(template)
  addChargeCorrelationTemplate(template)

  template.DiffEtaUpperLimit = 0
  template.DiffEtaLowerLimit = 0
  template.DiffPhiUpperLimit = 0
  template.DiffPhiLowerLimit = 0

  return template


def getEsumTemplate():
  logging.debug("getEsumTemplate")

  template = Object()

  addThresholdTemplate(template, n=1)
  addPhiTemplate(template, n=1)

  return template


def getObjectTemplate():
  logging.debug("getObjectTemplate")

  template = Object()

  template.operator = 'true'
  template.bx = "0"

  addThresholdTemplate(template, n=1)
  addEtaTemplate(template, n=1)
  addPhiTemplate(template, n=1)
  addChargeTemplate(template, n=1)
  addQualityTemplate(template, n=1)
  addIsolationTemplate(template, n=1)

  return template


def getCorrelationTemplate():
  logging.debug("getCorrelationTemplate")

  template = Object()

  addChargeCorrelationTemplate(template)

  template.objectsInSameBx = 'true'

  template.hasDetaCut = 'false'
  template.hasDphiCut = 'false'
  template.hasDrCut = 'false'
  template.hasMassCut = 'false'

  template.DiffEtaLowerLimit = 0
  template.DiffEtaUpperLimit = 0

  template.DiffPhiLowerLimit = 0
  template.DiffPhiUpperLimit = 0

  template.DeltaRUpperLimit = 0
  template.DeltaRLowerLimit = 0

  template.InvMassUpperLimit = 0
  template.InvMassLowerLimit = 0

  template.objects = []
  template.objects.append(getObjectTemplate())
  template.objects.append(getObjectTemplate())

  return template


def setThreshold(template, index, cuts):
  array = []
  for name in cuts:
    if cuts[name].type == tmEventSetup.Threshold:
      array.append(cuts[name])

  n = len(array)
  if n != 1:
    raise NotImplementedError

  template.Thresholds[index] = array[0].min_idx


def setEtaRange(template, index, cuts):
  array = []
  for name in cuts:
    if cuts[name].type == tmEventSetup.Eta:
      array.append(cuts[name])

  n = len(array)
  if n == 0:
    template.EtaFullRange[index] = 'true'

  else:
    template.EtaW1LowerLimits[index] = array[0].min_idx
    template.EtaW1UpperLimits[index] = array[0].max_idx

    if n == 1:
      template.EtaW2Ignore[index] = 'true'

    elif n == 2:
      template.EtaW2LowerLimits[index] = array[1].min_idx
      template.EtaW2UpperLimits[index] = array[1].max_idx

    else:
      raise NotImplementedError


def setPhiRange(template, index, cuts):
  array = []
  for name in cuts:
    if cuts[name].type == tmEventSetup.Phi:
      array.append(cuts[name])

  n = len(array)
  if n == 0:
    template.PhiFullRange[index] = 'true'

  else:
    template.PhiW1LowerLimits[index] = array[0].min_idx
    template.PhiW1UpperLimits[index] = array[0].max_idx

    if n == 1:
      template.PhiW2Ignore[index] = 'true'

    elif n == 2:
      template.PhiW2LowerLimits[index] = array[1].min_idx
      template.PhiW2UpperLimits[index] = array[1].max_idx

    else:
      raise NotImplementedError


def setIsolationLUT(template, index, cuts):
  array = []
  for name in cuts:
    if cuts[name].type == tmEventSetup.Isolation:
      array.append(cuts[name])

  n = len(array)
  if n > 1:
    raise NotImplementedError

  elif n == 1:
    template.IsolationLUTs[index] = array[0].data


def setQualityLUT(template, index, cuts):
  array = []
  for name in cuts:
    if cuts[name].type == tmEventSetup.Quality:
      array.append(cuts[name])

  n = len(array)
  if n > 1:
    raise NotImplementedError

  elif n == 1:
    template.QualityLUTs[index] = array[0].data


def setCharge(template, index, cuts):
  array = []
  for name in cuts:
    if cuts[name].type == tmEventSetup.Charge:
      array.append(cuts[name])

  n = len(array)
  if n > 1:
    raise NotImplementedError

  elif n == 1:
    template.Charges[index] = chargeFormat(array[0].data)


def setChargeCorrelation(template, cuts):
  array = []
  for o in cuts:
    if o.type == tmEventSetup.ChargeCorrelation:
      array.append(o)

  n = len(array)
  if n > 1:
    raise NotImplemenedError

  elif n == 1:
    template.ChargeCorrelation = array[0].data


def reorderObjects(condition):
  if len(condition.objects) != 2:
    raise NotImplementedError

  o1 = condition.objects[0]
  o2 = condition.objects[1]

  logging.info("-reorderObjects: %s, %s" %
               (condition.objects[0].type, condition.objects[1].type))

  if o1.type_id == o2.type_id:
    pass

  elif o1.type_id == tmEventSetup.Muon:
    if o2.type_id not in (tmEventSetup.ETM, tmEventSetup.HTM):
      condition.objects[0], condition.objects[1] = condition.objects[1], condition.objects[0]

  elif o1.type_id == tmEventSetup.Jet:
    if o2.type_id not in (tmEventSetup.Tau, tmEventSetup.ETM,
                          tmEventSetup.HTM, tmEventSetup.Muon):
      condition.objects[0], condition.objects[1] = condition.objects[1], condition.objects[0]

  elif o1.type_id == tmEventSetup.Tau:
    if o2.type_id not in (tmEventSetup.ETM, tmEventSetup.HTM,
                          tmEventSetup.Muon):
      condition.objects[0], condition.objects[1] = condition.objects[1], condition.objects[0]
    pass

  elif o1.type_id in (tmEventSetup.ETM, tmEventSetup.HTM):
      condition.objects[0], condition.objects[1] = condition.objects[1], condition.objects[0]

  logging.info("+reorderObjects: %s, %s" % (condition.objects[0].type, condition.objects[1].type))

  return


def setCorrelation(template, objects, cuts):
  logging.debug("setCorrelation")

  setChargeCorrelation(template, cuts)
  template.objectsInSameBx = 'true' if objects[0].bx_offset == objects[1].bx_offset else 'false'

  for o in cuts:
    x = o.type
    if x == tmEventSetup.DeltaEta:
      template.hasDetaCut = 'true'
      template.DiffEtaLowerLimit = o.min_val
      template.DiffEtaUpperLimit = o.max_val

    elif x == tmEventSetup.DeltaPhi:
      template.hasDphiCut = 'true'
      template.DiffPhiLowerLimit = o.min_val
      template.DiffPhiUpperLimit = o.max_val

    elif x == tmEventSetup.DeltaR:
      template.hasDrCut = 'true'
      template.DeltaRLowerLimit = o.min_val*o.min_val
      template.DeltaRUpperLimit = o.max_val*o.max_val

    elif x == tmEventSetup.Mass:
      template.hasMassCut = 'true'
      template.InvMassLowerLimit = o.min_val*o.min_val*0.5
      template.InvMassUpperLimit = o.max_val*o.max_val*0.5

  if template.hasDrCut == 'true':
    if template.hasDetaCut == 'true': raise NotImplementedError
    if template.hasDphiCut == 'true': raise NotImplementedError
    if template.hasMassCut == 'true': raise NotImplementedError

  if template.hasMassCut == 'true':
    if template.hasDetaCut == 'true': raise NotImplementedError
    if template.hasDphiCut == 'true': raise NotImplementedError
    if template.hasDrCut == 'true': raise NotImplementedError

  return template


def setCalorimeterTemplate(condition):
  template = getCalorimeterTemplate()
  for ii in range(len(condition.objects)):
    cuts = condition.objects[ii].cuts
    setThreshold(template, ii, cuts)
    setEtaRange(template, ii, cuts)
    setPhiRange(template, ii, cuts)
    setIsolationLUT(template, ii, cuts)
  condition.template = template


def setMuonTemplate(condition):
  template = getMuonTemplate()
  for ii in range(len(condition.objects)):
    cuts = condition.objects[ii].cuts
    setThreshold(template, ii, cuts)
    setEtaRange(template, ii, cuts)
    setPhiRange(template, ii, cuts)
    setIsolationLUT(template, ii, cuts)
    setQualityLUT(template, ii, cuts)
    setCharge(template, ii, cuts)
  setChargeCorrelation(template, condition.cuts)
  condition.template = template


def setEsumTemplate(condition):
  template = getEsumTemplate()
  for ii in range(len(condition.objects)):
    cuts = condition.objects[ii].cuts
    setThreshold(template, ii, cuts)
    setPhiRange(template, ii, cuts)
  condition.template = template


def setMuonMuonTemplate(condition):
  logging.debug("setMuonMuonTemplate")

  template = getCorrelationTemplate()
  setCorrelation(template, condition.objects, condition.cuts)

  for ii in range(len(condition.objects)):
    tmp = template.objects[ii]
    obj = condition.objects[ii]

    cuts = condition.objects[ii].cuts
    setThreshold(tmp, 0, cuts)
    setEtaRange(tmp, 0, cuts)
    setPhiRange(tmp, 0, cuts)
    setIsolationLUT(tmp, 0, cuts)
    setCharge(tmp, 0, cuts)
    setQualityLUT(tmp, 0, cuts)

  condition.template = template


def setMuonEsumTemplate(condition):
  logging.debug("setMuonEsumTemplate")

  template = getCorrelationTemplate()
  setCorrelation(template, condition.objects, condition.cuts)

  for ii in range(len(condition.objects)):
    tmp = template.objects[ii]
    obj = condition.objects[ii]

    cuts = condition.objects[ii].cuts
    setThreshold(tmp, 0, cuts)
    setPhiRange(tmp, 0, cuts)
    if obj.type_id in MuonCondition:
      setEtaRange(tmp, 0, cuts)
      setIsolationLUT(tmp, 0, cuts)
      setQualityLUT(template, ii, cuts)
      setCharge(template, ii, cuts)

  condition.template = template


def setCaloMuonTemplate(condition):
  logging.debug("setCaloMuonTemplate")

  template = getCorrelationTemplate()
  setCorrelation(template, condition.objects, condition.cuts)

  for ii in range(len(condition.objects)):
    tmp = template.objects[ii]
    obj = condition.objects[ii]

    cuts = condition.objects[ii].cuts
    setThreshold(tmp, 0, cuts)
    setEtaRange(tmp, 0, cuts)
    setPhiRange(tmp, 0, cuts)
    setIsolationLUT(tmp, 0, cuts)
    if obj.type_id == tmEventSetup.Muon:
      setCharge(tmp, 0, cuts)
      setQualityLUT(tmp, 0, cuts)

  condition.template = template


def setCaloCaloTemplate(condition):
  logging.debug("setCaloCaloTemplate")

  template = getCorrelationTemplate()
  setCorrelation(template, condition.objects, condition.cuts)

  for ii in range(len(condition.objects)):
    tmp = template.objects[ii]
    obj = condition.objects[ii]

    cuts = condition.objects[ii].cuts
    setThreshold(tmp, 0, cuts)
    setEtaRange(tmp, 0, cuts)
    setPhiRange(tmp, 0, cuts)
    setIsolationLUT(tmp, 0, cuts)

  condition.template = template


def setCaloEsumTemplate(condition):
  logging.debug("setCaloEsumTemplate")

  template = getCorrelationTemplate()
  setCorrelation(template, condition.objects, condition.cuts)

  for ii in range(len(condition.objects)):
    tmp = template.objects[ii]
    obj = condition.objects[ii]

    cuts = condition.objects[ii].cuts
    setThreshold(tmp, 0, cuts)
    setPhiRange(tmp, 0, cuts)
    if obj.type_id in CaloCondition:
      setEtaRange(tmp, 0, cuts)
      setIsolationLUT(tmp, 0, cuts)

  condition.template = template


def setInvariantMassTemplate(condition):
  logging.info("setInvariantMassTemplate")

  combination = tmEventSetup.getObjectCombination(condition.objects[0].type_id,
                                                  condition.objects[1].type_id)
  if combination == tmEventSetup.MuonMuonCombination:
    setMuonMuonTemplate(condition)
    condition.type = conditionTypes[tmEventSetup.MuonMuonCorrelation]

  elif combination == tmEventSetup.CaloMuonCombination:
    setCaloMuonTemplate(condition)
    condition.type = conditionTypes[tmEventSetup.CaloMuonCorrelation]

  elif combination == tmEventSetup.CaloCaloCombination:
    setCaloCaloTemplate(condition)
    condition.type = conditionTypes[tmEventSetup.CaloCaloCorrelation]

  else:
    logging.error("Unknown combination: %s" % combination)
    raise NotImplementedError


def setBxCombination(dictionary):
  dictionary[keyBxComb] = set()

  for algorithm_name in dictionary[keyAlgoDict]:
    for condition_name in dictionary[keyAlgoDict][algorithm_name].conditions:
      condition_type = dictionary[keyAlgoDict][algorithm_name].conditions[condition_name].type_id

      bxSet = []
      if condition_type in (tmEventSetup.DoubleMuon,
                            tmEventSetup.TripleMuon,
                            tmEventSetup.QuadMuon,
                            tmEventSetup.MuonMuonCorrelation):
        for x in dictionary[keyAlgoDict][algorithm_name].conditions[condition_name].objects:
          bxSet.append(x.bx)
        bxSet = list(set(bxSet))
        if len(bxSet) == 1:
          bxCombination = bxSet[0], bxSet[0]
          dictionary[keyBxComb].add(bxCombination)
        else:
          raise NotImplementedError


def setConditionsInMenu(dictionary):
  condition_map = {}
  for algorithm_name in dictionary[keyAlgoDict]:
    for condition_name in dictionary[keyAlgoDict][algorithm_name].conditions:
      condition = dictionary[keyAlgoDict][algorithm_name].conditions[condition_name]
      condition_map.update({condition_name: condition})

  dictionary[keyCondDict] = condition_map

  translator = {}
  for x in condition_map.keys():
    hash = x.split('_')[1]
    translator.update({hash: [x,]})

  for algorithm_name in dictionary[keyAlgoDict]:
    algorithm = dictionary[keyAlgoDict][algorithm_name]
    tmGrammar.Algorithm_Logic.clear()
    tmGrammar.Algorithm_parser(algorithm.expression)

    for token in tmGrammar.Algorithm_Logic.getTokens():
      if token in tmGrammar.gateName: continue;
      if token[:3] == 'EXT': continue
      hash = "%s" % tmEventSetup.getHashUlong(token)
      if len(translator[hash]) == 2:
        if translator[hash][1] != token: raise NotImplementedError
        continue
      translator[hash].append(token)

  dictionary[keyTranslate] = {}
  for k, v in translator.iteritems():
    dictionary[keyTranslate].update({v[0]: v[1]})


def setObjectsForCorrelationConditions(dictionary):
  dictionary[keyObjInCorr] = set()
  dictionary[keyObjForScaleConv] = set()
  dictionary[keyObjPairForCorr] = set()

  objects = []
  conversion = []
  object_map = {}
  object_set = set()

  for algorithm_name in dictionary[keyAlgoDict]:
    for condition_name in dictionary[keyAlgoDict][algorithm_name].conditions:
      condition_type = dictionary[keyAlgoDict][algorithm_name].conditions[condition_name].type_id
      if condition_type in CorrelationCondition:
        pair = []
        for o in dictionary[keyAlgoDict][algorithm_name].conditions[condition_name].objects:
          key = "%s%s" % (o.type, o.bx)
          pair.append(key)
          object_map.update({key: o})
          if condition_type in (tmEventSetup.CaloMuonCorrelation, tmEventSetup.MuonEsumCorrelation):
            if key not in conversion:
              conversion.append(key)
              dictionary[keyObjForScaleConv].add(o)

          if key not in objects:
            objects.append(key)
            dictionary[keyObjInCorr].add(o)
        object_set.add((pair[0], pair[1]))

  for o1, o2 in object_set:
    dictionary[keyObjPairForCorr].add((object_map[o1], object_map[o2]))


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

  #for the reporter:
  data.info.datetime       = menu.getDatetime()
  data.info.version        = menu.getVersion()
  data.info.firmwareUuid   = menu.getFirmwareUuid()
  data.info.comment        = menu.getComment()



  return


def getCutInfo(esCut):
  cut = Object()
  cut.name = esCut.getName()
  cut.cut = esCut
  cut.target = esCut.getObjectType()
  cut.type = esCut.getCutType()
  cut.min_val = esCut.getMinimum().value
  cut.min_idx = esCut.getMinimum().index
  cut.max_val = esCut.getMaximum().value
  cut.max_idx = esCut.getMaximum().index
  cut.data = esCut.getData()

  return cut


def getObjectInfo(esObj):
  object = Object()
  object.type = objectTypes[esObj.getType()]
  object.type_id = esObj.getType()
  object.name = esObj.getName()
  object.operator = esObj.getComparisonOperator() == 0
  object.object = esObj
  object.bx = bx_encode(esObj.getBxOffset())
  object.bx_offset = esObj.getBxOffset()
  object.cuts = {}

  for esCut in esObj.getCuts():
    object.cuts[esCut.getName()] = getCutInfo(esCut)

  return object


def getConditionInfo(esCond, token):
  condition = Object()
  condition.name = esCond.getName()
  condition.token = token
  condition.type = conditionTypes[esCond.getType()]
  condition.type_id = esCond.getType()
  condition.template = None

  condition.cuts = []
  for esCut in esCond.getCuts():
    condition.cuts.append(getCutInfo(esCut))

  condition.objects = []
  for esObj in esCond.getObjects():
    condition.objects.append(getObjectInfo(esObj))

  return condition


def getAlgorithmInfo(esAlgo):
  algorithm = Object()
  algorithm.name = esAlgo.getName()
  algorithm.index = esAlgo.getIndex()
  algorithm.expression = esAlgo.getExpression()
  algorithm.expression_in_condition = esAlgo.getExpressionInCondition()
  algorithm.conditions = {}
  algorithm.conditionNames = []
  algorithm.module_id = esAlgo.getModuleId()
  algorithm.module_index = esAlgo.getModuleIndex()
  algorithm.rpn_vector = esAlgo.getRpnVector()
  return algorithm


def getReport(menu, version=False):
  data = Object()
  data.reporter = {}

  triggerGroups = {}
  triggerGroupsDict = {}
  
  for key in conditionTypes:
    triggerGroups[key] = {keyNBits: 0, keyBits: []}
    triggerGroupsDict[key] = {keyNBits: 0, keyBits: []}

  data.reporter[keyTriggerGroupsDict] = triggerGroupsDict
  data.reporter[keyTriggerGroups] = triggerGroups
  data.reporter[keyAlgoMap] = menu.getAlgorithmMapPtr()
  data.reporter[keyCondMap] = menu.getConditionMapPtr()
  data.reporter[keyScaleMap] = menu.getScaleMapPtr()

  setMenuInfo(menu, data, version)

  algoDict = {}
  for key, esAlgo in data.reporter[keyAlgoMap].iteritems():
    algoDict[esAlgo.getName()] = getAlgorithmInfo(esAlgo)
  data.reporter[keyAlgoDict] = algoDict

  condInUse = []
  for algorithm_name in data.reporter[keyAlgoDict]:
    algorithm = data.reporter[keyAlgoDict][algorithm_name]
    for token in algorithm.rpn_vector:
      if tmGrammar.isGate(token): continue

      esCond = data.reporter[keyCondMap][token]
      if esCond.getType() == tmEventSetup.Externals:
        updateExpressionInCondition(algorithm, esCond)
        continue

      algorithm.conditionNames.append(esCond.getName())
      if token in condInUse: continue
      condInUse.append(token)

      condition = getConditionInfo(esCond, token)
      algorithm.conditions[condition.name] = condition

      if condition.type_id in ObjectCondition:
        n = len(esCond.getObjects())
        if not n or n > 4:
          logging.error("# of objects not in [1,4]: %s" % n)
          raise NotImplementedError

        if condition.type_id in MuonCondition:
          setMuonTemplate(condition)

        elif condition.type_id in CaloCondition:
          setCalorimeterTemplate(condition)

        elif condition.type_id in EsumCondition:
          setEsumTemplate(condition)

        else:
          logging.error("unknown condition: %s" % condition.type)
          raise NotImplementedError

      elif condition.type_id in CorrelationCondition:
        esObjs = esCond.getObjects()
        n = len(esObjs)
        if n != 2:
          logging.error("# of esObjs != 2: %s" % n)
          raise NotImplementedError

        reorderObjects(condition)

        combination = tmEventSetup.getObjectCombination(esObjs[0].getType(),
                                                        esObjs[1].getType())
        if combination == tmEventSetup.MuonMuonCombination:
          setMuonMuonTemplate(condition)

        elif combination == tmEventSetup.MuonEsumCombination:
          setMuonEsumTemplate(condition)

        elif combination == tmEventSetup.CaloMuonCombination:
          setCaloMuonTemplate(condition)

        elif combination == tmEventSetup.CaloCaloCombination:
          setCaloCaloTemplate(condition)

        elif combination == tmEventSetup.CaloEsumCombination:
          setCaloEsumTemplate(condition)

        else:
          logging.error("Unknown combination: %s" % combination)
          raise NotImplementedError

      elif condition.type_id == tmEventSetup.InvariantMass:
        n = len(esCond.getObjects())
        if n != 2:
          logging.error("# of esObjs != 2: %s" % n)
          raise NotImplementedError

        reorderObjects(condition)

        setInvariantMassTemplate(condition)

      else:
        logging.error("Unknown condition: %s" % condition)
        raise NotImplementedError


  for algorithm_name in data.reporter[keyAlgoDict]:
    for condition_name in data.reporter[keyAlgoDict][algorithm_name].conditions:
      condition_type = data.reporter[keyAlgoDict][algorithm_name].conditions[condition_name].type

      data.reporter[keyTriggerGroupsDict][condition_type][keyNBits] += 1
      data.reporter[keyTriggerGroups][condition_type][keyNBits] += 1

      value = {keyIndex: data.reporter[keyAlgoDict][algorithm_name].index}
      value.update( {keyAlgoName: algorithm_name} )
      value.update( {keyAlgo: data.reporter[keyAlgoDict][algorithm_name]} )

      data.reporter[keyTriggerGroupsDict][condition_type][keyBits].append(value)
      data.reporter[keyTriggerGroups][condition_type][keyBits].append( data.reporter[keyAlgoDict][algorithm_name]  )

  data.reporter[keyNBitsSorted] = sortDictByKey(data.reporter[keyTriggerGroupsDict],
                                                keyNBits, True)
  data.reporter[keyIndexSorted] = sortDictByIndex(data.reporter[keyAlgoDict],
                                                  False)
  n = 0
  for tg in data.reporter[keyTriggerGroupsDict]:
    n += data.reporter[keyTriggerGroupsDict][tg][keyNBits]
  data.reporter[keyNAlgoDefined] = n

  condList = []
  for algorithm_name in data.reporter[keyIndexSorted]:
    condList.extend(data.reporter[keyAlgoDict][algorithm_name].conditions.keys())
  data.reporter[keyConditionSet] = set(condList)

  setBxCombination(data.reporter)
  setObjectsForCorrelationConditions(data.reporter)
  setConditionsInMenu(data.reporter)

  data.reporter["cutTypes"] = cutTypes

  return data

# eof
