# -*- coding: utf-8 -*-
#
# Repository path   : $HeadURL: $
# Last committed    : $Revision: $
# Last changed by   : $Author: $
# Last changed date : $Date: $
#

"""Template helper classes.

Overview of class hierarchy:

    class VhdlHelper
    class VersionHelper
    class MenuHelper
    class InfoHelper
    class ModuleHelper
    class AlgorithmHelper
    class ConditionHelper
        class SimpleConditionHelper
        class CaloConditionHelper
        class MuonConditionHelper
        class ExternalConditionHelper
        class CorrelationConditionHelper
        class CorrelationConditionOvRmHelper
        class CaloConditionOvRmHelper
        class ObjectHelper

"""

import string
import uuid
import re, math
import sys, os

import tmEventSetup
import tmGrammar  # import after tmEventSetup
import algodist

from tmVhdlProducer import __version__

# -----------------------------------------------------------------------------
#  Precompiled regular expressions
# -----------------------------------------------------------------------------

regexCamelSnake1=re.compile(r'([^_])([A-Z][a-z]+)')
regexCamelSnake2=re.compile('([a-z0-9])([A-Z])')
regexVhdlLabel=re.compile('[^A-Za-z0-9_]')

# -----------------------------------------------------------------------------
#  Conversion dictionaries
# -----------------------------------------------------------------------------

# HB 2016-10-13: inserted TOWERCOUNT
ObjectTypes = {
    tmEventSetup.Muon: tmGrammar.MU,
    tmEventSetup.Egamma: tmGrammar.EG,
    tmEventSetup.Tau: tmGrammar.TAU,
    tmEventSetup.Jet: tmGrammar.JET,
    tmEventSetup.ETT: tmGrammar.ETT,
    tmEventSetup.ETTEM: tmGrammar.ETTEM,
    tmEventSetup.HTT: tmGrammar.HTT,
    tmEventSetup.ETM: tmGrammar.ETM,
    tmEventSetup.ETMHF: tmGrammar.ETMHF,
    tmEventSetup.HTM: tmGrammar.HTM,
    tmEventSetup.EXT: tmGrammar.EXT,
    tmEventSetup.MBT0HFP: tmGrammar.MBT0HFP,
    tmEventSetup.MBT1HFP: tmGrammar.MBT1HFP,
    tmEventSetup.MBT0HFM: tmGrammar.MBT0HFM,
    tmEventSetup.MBT1HFM: tmGrammar.MBT1HFM,
    tmEventSetup.TOWERCOUNT: tmGrammar.TOWERCOUNT,
}

# Has the number of Objects of each Type
ObjectCount = {
    tmEventSetup.Muon:       8,
    tmEventSetup.Egamma:    12,
    tmEventSetup.Tau:       12,
    tmEventSetup.Jet:       12,
    tmEventSetup.ETT:        1,
    tmEventSetup.ETTEM:      1,
    tmEventSetup.HTT:        1,
    tmEventSetup.ETM:        1,
    tmEventSetup.ETMHF:      1,
    tmEventSetup.HTM:        1,
    tmEventSetup.EXT:        1,
    tmEventSetup.MBT0HFP:    1,
    tmEventSetup.MBT1HFP:    1,
    tmEventSetup.MBT0HFM:    1,
    tmEventSetup.MBT1HFM:    1,
    tmEventSetup.TOWERCOUNT: 1,
}

CaloTypes = [
    tmGrammar.EG,
    tmGrammar.TAU,
    tmGrammar.JET,
]

MuonTypes = [
    tmGrammar.MU,
]

EsumsTypes = [
    tmGrammar.ETT,
    tmGrammar.ETTEM,
    tmGrammar.ETM,
    tmGrammar.ETMHF,
    tmGrammar.HTT,
    tmGrammar.HTM,
]

# HB 2016-10-13: inserted TOWERCOUNT
TowerCountTypes = [
    tmGrammar.TOWERCOUNT,
]

MinBiasTypes = [
    tmGrammar.MBT0HFP,
    tmGrammar.MBT1HFP,
    tmGrammar.MBT0HFM,
    tmGrammar.MBT1HFM,
]

# HB 2016-10-13: inserted ETTEM, TOWERCOUNT and ETMHF
ObjectsOrder = [
    tmEventSetup.Egamma,
    tmEventSetup.Jet,
    tmEventSetup.Tau,
    tmEventSetup.Muon,
    tmEventSetup.ETT,
    tmEventSetup.ETTEM,
    tmEventSetup.HTT,
    tmEventSetup.TOWERCOUNT,
    tmEventSetup.ETM,
    tmEventSetup.HTM,
    tmEventSetup.ETMHF,
    tmEventSetup.MBT0HFM,
    tmEventSetup.MBT0HFP,
    tmEventSetup.MBT1HFM,
    tmEventSetup.MBT1HFP,
    tmEventSetup.EXT,
    tmEventSetup.Precision,
]
"""Order of objects required by VHDL implementation."""

ComparisonOperator = {
    tmEventSetup.GE: True,
    tmEventSetup.EQ: False,
}
"""See utm/tmEventSetup/esTypes.hh"""

# -----------------------------------------------------------------------------
#  Filters
# -----------------------------------------------------------------------------

def snakecase(label, separator='_'):
    """Transformes camel case label to spaced lower case (snaked) label.
    >>> snakecase('CamelCaseLabel')
    'camel_case_label'
    """
    subbed = regexCamelSnake1.sub(r'\1{sep}\2'.format(sep=separator), label)
    return regexCamelSnake2.sub(r'\1{sep}\2'.format(sep=separator), subbed).lower()

def unique_name(name, names):
    """Generate unique signal name to prevent name collisions."""
    count = 1
    def suffixed():
        if count > 1:
            return '{name}_{count}'.format(**locals())
        return name
    while suffixed() in names:
        count += 1
    return suffixed()

def vhdl_bool(value): # TODO add to filters
    """Returns VHDL boolean equivalent to value."""
    return 'true' if bool(value) else 'false'

def vhdl_label(label): # TODO add to filters
    """Return normalized VHDL label for signal or instance names.
    >>> vhdl_label('001FooBar.value__@2_')
    'd001_foo_bar_value_2'
    """
    label = regexVhdlLabel.sub('_', label.strip()) # Replace unsave characters by underscore.
    # Suppress multible underlines (VHDL spec)
    label = re.sub(r'[_]+', r'_', label)
    # Suppress leading/trailing underlines (VHDL spec)
    label = label.strip('_')
    # Prepend char if starts with digit (starting with underline not allowed in VHDL spec).
    if label[0] in string.digits:
        label = ''.join(('d', label))
    return snakecase(label) # Convert to spaced lower case

def vhdl_expression(expression): # TODO add to filters
    """Return safe VHDL expression string using normalized signals for conditions.
    >>> vhdl_expression('(singleMu_1 and doubleMu_2)')
    '( single_mu_1 and double_mu_2 )'
    """
    expression = re.sub(r'([\(\)])', r' \1 ', expression) # separate braces
    expression = re.sub(r'[\ ]+', r' ', expression) # suppress multiple spaces
    tokens = []
    for token in expression.split():
        if token not in ['(', ')']:
            token = vhdl_label(token)
        tokens.append(token)
    return ' '.join(tokens)

def charge_encode(value):
    """Encode charge value to VHDL string literal."""
    if value in ('positive', 'pos', '1'):
        return 'pos' # positive
    if value in ('negative', 'neg', '-1'):
        return 'neg' # negative
    return 'ign' # ignore

def charge_correlation_encode(value):
    """Encode charge correlation value to VHDL string literal."""
    if value in ('like', 'ls', '0'):
        return 'ls' # like sign
    if value in ('opposite', 'os', '1'):
        return 'os' # opposite sign
    return 'ig' # ignore

def bx_encode(value):
    """Encode relative bunch crossings into VHDL notation.
    All positive values with the exception of zero are prefixed with m, all
    negative values are prefixed with p instead of the minus sign.
    """
    # Prefix positive values greater then zero with p.
    if value > 0: return 'p{0:d}'.format(value)
    # Prefix negative values with m instead of minus sign (abs).
    if value < 0: return 'm{0:d}'.format(abs(value))
    # Zero value is not prefixed according to VHDL documentation.
    return '0'

# -----------------------------------------------------------------------------
#  Factories
# -----------------------------------------------------------------------------

def conditionFactory(condition):
    """Returns condition template helper class according to condition stub."""
    if condition.isCaloCondition():
        return CaloConditionHelper(condition)
    elif condition.isMuonCondition():
        return MuonConditionHelper(condition)
    elif condition.isEsumsCondition():
        return EsumsConditionHelper(condition)
    elif condition.isExternalCondition():
        return ExternalConditionHelper(condition)
    elif condition.isMinBiasCondition():
        return MinBiasConditionHelper(condition)
    elif condition.isTowerCountCondition():
        return TowerCountConditionHelper(condition)
    elif condition.isCorrelationCondition():
        return CorrelationConditionHelper(condition)
    elif condition.isCorrelationConditionOvRm():
        return CorrelationConditionOvRmHelper(condition)
    elif condition.isCaloConditionOvRm():
        return CaloConditionOvRmHelper(condition)
    else:
        raise RuntimeError("unknown condition type")

# -----------------------------------------------------------------------------
#  Template helpers
# -----------------------------------------------------------------------------

class VhdlHelper(object):
    """Base tamplate helper class."""
    pass

class VersionHelper(VhdlHelper):
    """Version template helper, splitting string version numbers.
    >>> version = VersionHelper('1.2.3')
    >>> version.major, version.minor, version.patch
    (1, 2, 3)
    """
    def __init__(self, version):
        version = ([int(value) for value in version.split('.')] + [0, 0, 0])[:3]
        self.major = version[0]
        self.minor = version[1]
        self.patch = version[2]

    def __str__(self):
        return "{self.major}.{self.minor}.{self.patch}".format(**locals())

class MenuHelper(VhdlHelper):
    """Menu template helper.

    Attributes:
        info [struct]
        algorithms  [list]
        conditions  [list]
        modules  [list]
    """

    def __init__(self, collection):
        # Init attribiutes
        self.info = InfoHelper(collection)
        self.algorithms = collection.algorithms
        self.conditions = collection.conditions
        self.modules = []
        for module in collection:
            self.modules.append(ModuleHelper(module))

    def __len__(self):
        """Returns count of modules assigned to this menu."""
        return len(self.modules)

    def __iter__(self):
        """Iterate over modules."""
        return iter([module for module in self.modules])

class InfoHelper(VhdlHelper):
    """Menu information template helper.

    Attributes:
        name  [str]
        uuid_menu  [str]
        uuid_firmware  [str]
        scale_set  [str]
        version  [str]
        sw_version  [str]
        svn_revision  [int]
    """

    def __init__(self, collection):
        eventSetup = collection.eventSetup
        # Init attribiutes
        self.name = eventSetup.getName()
        self.uuid_menu = eventSetup.getMenuUuid()
        self.uuid_firmware = eventSetup.getFirmwareUuid()
        self.scale_set = eventSetup.getScaleSetName()
        self.version = VersionHelper(eventSetup.getVersion())
        self.sw_version = VersionHelper(__version__)
        self.svn_revision = eventSetup.svnRevision # HACK

class ModuleHelper(VhdlHelper):
    """Module template helper.

    Attributes:
        id  [int]
        algorithms  [list]
        conditions  sorted list of condition helper instances [list]
    """

    def __init__(self, module):
        self.id = module.id
        self.algorithms = []

        def vhdl_signals():
            """Returns all signal names."""
            return [algorithm.vhdl_signal for algorithm in self.algorithms]

        def add_algorithm(algorithm):
            """Add algorithm helper asigning a unique name."""
            helper = AlgorithmHelper(algorithm)
            # Prevent name collisions
            helper.vhdl_signal = unique_name(helper.vhdl_signal, vhdl_signals())
            self.algorithms.append(helper)

        for algorithm in module:
            add_algorithm(algorithm)

    @property
    def conditions(self):
        """Returns list of condition template helper instances referenced by this
        module, sorted by number of objects, condition type and name.
        """
        conditions = {}
        for algorithm in self.algorithms:
            for condition in algorithm.conditions:
                conditions[condition.name] = condition
        return sorted(conditions.values(), key=lambda condition: (len(condition.objects), condition.type, condition.vhdl_signal))

    @property
    def muonConditions(self):
        return filter(lambda condition: condition.type in algodist.MuonConditionTypes, self.conditions)

    @property
    def caloConditions(self):
        return filter(lambda condition: condition.type in algodist.CaloConditionTypes, self.conditions)

    @property
    def caloConditionsOvRm(self):
        return filter(lambda condition: condition.type in algodist.CaloConditionOvRmTypes, self.conditions)

    @property
    def esumsConditions(self):
        return filter(lambda condition: condition.type in algodist.EsumsConditionTypes, self.conditions)

    @property
    def externalConditions(self):
        return filter(lambda condition: condition.type in algodist.ExternalConditionTypes, self.conditions)

    @property
    def caloCaloCorrConditions(self):
        return filter(lambda condition: condition.type in algodist.CorrelationConditionTypes and \
             (condition.objects[0].type in CaloTypes and condition.objects[1].type in CaloTypes), self.conditions)

    @property
    def caloCaloCorrOvRmConditions(self):
        return filter(lambda condition: condition.type in algodist.CorrelationConditionOvRmTypes and \
             (condition.objects[0].type in CaloTypes and condition.objects[1].type in CaloTypes), self.conditions)

    @property
    def caloMuonCorrConditions(self):
        return filter(lambda condition: condition.type in algodist.CorrelationConditionTypes and \
             (condition.objects[0].type in CaloTypes and condition.objects[1].type in MuonTypes), self.conditions)

    @property
    def muonMuonCorrConditions(self):
        return filter(lambda condition: condition.type in algodist.CorrelationConditionTypes and \
             (condition.objects[0].type in MuonTypes and condition.objects[1].type in MuonTypes), self.conditions)

    @property
    def caloEsumCorrConditions(self):
        return filter(lambda condition: condition.type in algodist.CorrelationConditionTypes and \
             (condition.objects[0].type in CaloTypes and condition.objects[1].type in EsumsTypes), self.conditions)

    @property
    def muonEsumCorrConditions(self):
        return filter(lambda condition: condition.type in algodist.CorrelationConditionTypes and \
             (condition.objects[0].type in MuonTypes and condition.objects[1].type in EsumsTypes), self.conditions)


    @property
    def minBiasConditions(self):
        return filter(lambda condition: condition.type in algodist.MinBiasConditionTypes, self.conditions)

    @property
    def towerCountConditions(self):
        return filter(lambda condition: condition.type in algodist.TowerCountConditionTypes, self.conditions)

    @property
    def correlationCombinations(self):
        class ObjectHelperStub(VhdlHelper):
            def __init__(self, helper):
                self.type = helper.type
                self.bx = helper.bx
        combinations = {}
        for condition in self.conditions:
            if isinstance(condition, CorrelationConditionHelper):
                a, b = condition.objects
                key = (a.type, b.type, a.bx, b.bx) # create custom hash
                combinations[key] = (ObjectHelperStub(a), ObjectHelperStub(b))
            if isinstance(condition, CorrelationConditionOvRmHelper):
                if condition.nr_objects == 3:
                    a, b, c = condition.objects
                    key = (a.type, b.type, a.bx, b.bx) # a-b combination
                    combinations[key] = (ObjectHelperStub(a), ObjectHelperStub(b))
                    key = (a.type, c.type, a.bx, c.bx) # a-c combination
                    combinations[key] = (ObjectHelperStub(a), ObjectHelperStub(c))
                    key = (b.type, c.type, b.bx, c.bx) # b-c combination
                    combinations[key] = (ObjectHelperStub(b), ObjectHelperStub(c))
                else:
                    a = condition.objects[0]
                    b = condition.objects[1]
                    key = (a.type, b.type, a.bx, b.bx)
                    combinations[key] = (ObjectHelperStub(a), ObjectHelperStub(b))
            if isinstance(condition, CaloConditionOvRmHelper):
                a = condition.objects[0]
                b = condition.objects[condition.nr_objects-1]
                key = (a.type, b.type, a.bx, b.bx)
                combinations[key] = (ObjectHelperStub(a), ObjectHelperStub(b))
        return combinations.values()

    @property
    def correlationObjects(self):
        """Retruns list of objects used by correlation conditions or any
        conditions using two body pt correlations.
        """
        def hasObjectCorrelation(condition):
            """True if either two body pt cut or correlation condtion type."""
            if condition.type in algodist.CorrelationConditionTypes:
                return True
            if condition.type in algodist.CorrelationConditionOvRmTypes:
                return True
            if condition.type in algodist.CaloConditionOvRmTypes:
                return True
            if hasattr(condition, 'hasTwoBodyPtCut'):
                return bool(condition.hasTwoBodyPtCut)
            return False
        objects = {}
        for condition in filter(hasObjectCorrelation, self.conditions):
            for object in condition.objects:
                key = (object.type, object.bx) # create custom hash
                objects[key] = object
        return objects.values()

    @property
    def conversionObjects(self):
        """Returns list of objects required for calo-muon and muon-esums correlations."""
        def isConversionCondition(condition):
            """Returns True if condition type requires eta/phi conversion."""
            if condition.type in (algodist.kCaloMuonCorrelation, algodist.kMuonEsumCorrelation):
                return True
            # Muon-Esum combinations for transverse mass
            if condition.type == algodist.kTransverseMass:
                for object in condition.objects:
                    if object.type in algodist.EsumsObjectTypes:
                        return True
                return False
            # Calo-Muon combinations for invariant mass
            if condition.type == algodist.kInvariantMass:
                object = condition.objects
                if (object[0].type == 'EG' or 'TAU' or 'JET') and (object[1].type == 'MU'):
                    return True
                return False
        objects = {}
        for condition in filter(isConversionCondition, self.conditions):
            for object in condition.objects:
                key = object.type # create custom hash
                objects[key] = object
        return objects.values()

    @property
    def muonBxCombinations(self):
        combinations = set()
        for condition in self.conditions:
            if type(condition) in (MuonConditionHelper, CorrelationConditionHelper):
                if len(condition) > 1:
                    a = condition.objects[0]
                    b = condition.objects[1]
                    combinations.add((a.bx, b.bx))
        return list(combinations)

    def __len__(self):
        """Returns count of algorithms assigned to this module."""
        return len(self.algorithms)

    def __iter__(self):
        """Iterate over modules."""
        return iter([algorithm for algorithm in self.algorithms])

# -----------------------------------------------------------------------------
#  Algorithm helpers
# -----------------------------------------------------------------------------

class AlgorithmHelper(VhdlHelper):
    """Algorithm template helper class.

    Attributes:
        index            algorithm index [int]
        name             algorithm name from event setup [str]
        module_id        module ID of algorithm [int]
        module_index     local module index of algorithm [int]
        expression       algorithm expression in grammar [str]
        vhdl_signal      VHDL safe algorithm signal name [str]
        vhdl_expression  VHDL safe algorithm expression [str]
        conditions       sorted list of condition template helpers referenced by expression [list]
    """

    def __init__(self, algorithm):
        self.index = algorithm.index
        self.name = algorithm.name
        self.module_id = algorithm.module_id
        self.module_index = algorithm.module_index
        self.expression = algorithm.expression
        self.vhdl_signal = vhdl_label(algorithm.name)
        self.vhdl_expression =  vhdl_expression( algorithm.expression_in_condition )
        self.conditions = self.collect_conditions(algorithm)

    def collect_conditions(self, algorithm):
        """Collects list of conditions referenced by the algorithm expression from
        an esAlgorithm instance. Returns list of condition template helpers sorted
        by number of objects, condition type and name.
        """
        conditions = {}
        for condition in algorithm:
            if condition.name not in conditions: # assumes condition name is unique
                conditions[condition.name] = conditionFactory(condition)
        return sorted(conditions.values(), key=lambda condition: (len(condition.objects), condition.type, condition.name))

    def __len__(self):
        """Returns count of conditions assigned to this algorithm."""
        return len(self.conditions)

    def __iter__(self):
        """Iterate over conditions."""
        return iter([condition for condition in self.conditions])

# -----------------------------------------------------------------------------
#  Condition helpers
# -----------------------------------------------------------------------------

class ConditionHelper(VhdlHelper):
    """Generic condition template helper class.

    Attributes:
        name         condition name from event setup [str]
        type         condition type name [str]
        vhdl_signal  VHDL safe condition signal name [str]
        objects      list of object template helpers contained by condition [list]
        nr_objects   number of actually used objects [int]
    """
    ReqObjects = 1
    """Number of required objects."""

    def __init__(self, condition):
        # Default attributes
        self.name = condition.name
        self.type = condition.type
        self.vhdl_signal = vhdl_label(condition.name)
        self.objects = [ObjectHelper() for _ in range(self.ReqObjects)]
        self.update_objects(condition)

    def update_objects(self, condition):
        """Update objects assigned to this condition."""
        esObjects = list(condition.ptr.getObjects())
        assert 0 < len(esObjects) <= self.ReqObjects, "condition object count missmatch"
        # Do not sort objects by type for overlap removal conditions!
        if not (condition.type in algodist.CorrelationConditionOvRmTypes or
                condition.type in algodist.CaloConditionOvRmTypes):
            esObjects.sort(key=lambda key: ObjectsOrder.index(key.getType()))
        for i, esObject in enumerate(esObjects):
            self.objects[i].update(esObject)

    @property
    def nr_objects(self):
        """Returns number of valid objects."""
        return len([object for object in self.objects if object.isValid])

    def __len__(self):
        """Returns count of objects assigned to this condition."""
        return len(self.objects)

    def __iter__(self):
        """Iterate over objects."""
        return iter([object for object in self.objects])

class CaloConditionHelper(ConditionHelper):
    """Calorimeter condition template helper class.

    Attributes:
        name         condition name from event setup [str]
        type         condition type name [str]
        vhdl_signal  VHDL safe condition signal name [str]
        threshold    threshold bin index, alias for objects[0].threshold [int]
        objects      list of object template helpers contained by condition
    """
    ReqObjects = 4
    """Number of required objects."""

    def __init__(self, condition):
        super(CaloConditionHelper, self).__init__(condition)
        self.hasTwoBodyPtCut = vhdl_bool(False)
        self.twoBodyPtThres = .0
        self.update(condition)

    def update(self, condition):
        def lowerLimit(esCut):
            """Returns rounded floating point for minimum."""
            value = esCut.getMinimum().value
            precision = esCut.getPrecision()
            scale = 10.**precision
            return math.floor(value * scale) / scale

        for esCut in condition.ptr.getCuts():
            if esCut.getCutType() == tmEventSetup.TwoBodyPt:
                self.hasTwoBodyPtCut = vhdl_bool(True)
                self.twoBodyPtThres = lowerLimit(esCut)

class MuonConditionHelper(ConditionHelper):
    """Muon condition template helper class.

    Attributes:
        name         condition name from event setup [str]
        type         condition type name [str]
        vhdl_signal  VHDL safe condition signal name [str]
        objects      list of object template helpers contained by condition
        chargeCorrelation [str]
    """
    ReqObjects = 4
    """Number of required objects."""

    def __init__(self, condition):
        super(MuonConditionHelper, self).__init__(condition)
        self.chargeCorrelation = 'ig'
        self.hasTwoBodyPtCut = vhdl_bool(False)
        self.twoBodyPtThres = .0
        self.update_cuts(condition)

    def update_cuts(self, condition):
        def lowerLimit(esCut):
            """Returns rounded floating point for minimum."""
            value = esCut.getMinimum().value
            precision = esCut.getPrecision()
            scale = 10.**precision
            return math.floor(value * scale) / scale

        for esCut in condition.ptr.getCuts():
            if esCut.getCutType() == tmEventSetup.ChargeCorrelation:
                self.chargeCorrelation = esCut.getData()
            elif esCut.getCutType() == tmEventSetup.TwoBodyPt:
                self.hasTwoBodyPtCut = vhdl_bool(True)
                self.twoBodyPtThres = lowerLimit(esCut)

class EsumsConditionHelper(ConditionHelper):
    """Esums condition template helper class."""
    ReqObjects = 1
    """Number of required objects."""

class ExternalConditionHelper(ConditionHelper):
    """External condition template helper class."""
    ReqObjects = 1
    """Number of required objects."""

class MinBiasConditionHelper(ConditionHelper):
    """Minimum bias condition template helper class."""
    ReqObjects = 1
    """Number of required objects."""

class TowerCountConditionHelper(ConditionHelper):
    """Minimum bias condition template helper class."""
    ReqObjects = 1
    """Number of required objects."""

class CorrelationConditionHelper(ConditionHelper):
    """Correlation condition template helper class."""
    ReqObjects = 2
    """Number of required objects."""

    def __init__(self, condition):
        super(CorrelationConditionHelper, self).__init__(condition)
        # Flags
        self.hasDetaCut = vhdl_bool(False)
        self.hasDphiCut = vhdl_bool(False)
        self.hasDrCut = vhdl_bool(False)
        self.hasMassCut = vhdl_bool(False)
        self.massType = 0
        self.hasTwoBodyPtCut = vhdl_bool(False)
        # Limits
        self.diffEtaLowerLimit = .0
        self.diffEtaUpperLimit = .0
        self.diffPhiLowerLimit = .0
        self.diffPhiUpperLimit = .0
        self.deltaRLowerLimit = .0
        self.deltaRUpperLimit = .0
        self.massLowerLimit = .0
        self.massUpperLimit = .0
        self.twoBodyPtThres = .0
        #
        self.chargeCorrelation = charge_correlation_encode('ig')
        self.update(condition)

    @property
    def objectsInSameBx(self):
        """Returns 'true' if all objects of same BX offset else returns 'false'."""
        return vhdl_bool(len(set([object.bx for object in self.objects])) == 1)

    def update(self, condition):
        def lowerLimit(esCut):
            """Returns rounded floating point for minimum."""
            value = esCut.getMinimum().value
            precision = esCut.getPrecision()
            scale = 10.**precision
            return math.floor(value * scale) / scale
        def upperLimit(esCut):
            """Returns rounded floating point for maximum."""
            value = esCut.getMaximum().value
            precision = esCut.getPrecision()
            scale = 10.**precision
            return math.ceil(value * scale) / scale

        #hasTwoBodyPtCut = False
        for esCut in condition.ptr.getCuts():
            if esCut.getCutType() == tmEventSetup.DeltaEta:
                self.hasDetaCut = vhdl_bool(True)
                self.diffEtaLowerLimit = lowerLimit(esCut)
                self.diffEtaUpperLimit = upperLimit(esCut)
            elif esCut.getCutType() == tmEventSetup.DeltaPhi:
                self.hasDphiCut = vhdl_bool(True)
                self.diffPhiLowerLimit = lowerLimit(esCut)
                self.diffPhiUpperLimit = upperLimit(esCut)
            elif esCut.getCutType() == tmEventSetup.DeltaR:
                self.hasDrCut = vhdl_bool(True)
                self.deltaRLowerLimit = lowerLimit(esCut)
                self.deltaRUpperLimit = upperLimit(esCut)
            elif esCut.getCutType() == tmEventSetup.Mass:
                self.hasMassCut = vhdl_bool(True)
                self.massLowerLimit = lowerLimit(esCut)
                self.massUpperLimit = upperLimit(esCut)
            elif esCut.getCutType() == tmEventSetup.TwoBodyPt:
                self.hasTwoBodyPtCut = vhdl_bool(True)
                self.twoBodyPtThres = lowerLimit(esCut)
            elif esCut.getCutType() == tmEventSetup.ChargeCorrelation:
                self.chargeCorrelation = charge_correlation_encode(esCut.getData())

        # Definition of mass_type:
        # 0 => invariant mass
        # 1 => transverse mass

        if condition.ptr.getType() == tmEventSetup.InvariantMass:
            self.massType = 0
        elif condition.ptr.getType() == tmEventSetup.TransverseMass:
            self.massType = 1

class CorrelationConditionOvRmHelper(ConditionHelper):
    """Correlation condition template helper class."""
    ReqObjects = 3
    """Number of required objects."""

    def __init__(self, condition):
        super(CorrelationConditionOvRmHelper, self).__init__(condition)
        # Flags
        self.hasDetaOrmCut = vhdl_bool(False)
        self.hasDphiOrmCut = vhdl_bool(False)
        self.hasDrOrmCut = vhdl_bool(False)
        self.hasDetaCut = vhdl_bool(False)
        self.hasDphiCut = vhdl_bool(False)
        self.hasDrCut = vhdl_bool(False)
        self.hasMassCut = vhdl_bool(False)
        self.massType = 0
        self.hasTwoBodyPtCut = vhdl_bool(False)
        # Limits
        self.diffEtaOrmLowerLimit = .0
        self.diffEtaOrmUpperLimit = .0
        self.diffPhiOrmLowerLimit = .0
        self.diffPhiOrmUpperLimit = .0
        self.deltaROrmLowerLimit = .0
        self.deltaROrmUpperLimit = .0
        self.diffEtaLowerLimit = .0
        self.diffEtaUpperLimit = .0
        self.diffPhiLowerLimit = .0
        self.diffPhiUpperLimit = .0
        self.deltaRLowerLimit = .0
        self.deltaRUpperLimit = .0
        self.massLowerLimit = .0
        self.massUpperLimit = .0
        self.twoBodyPtThres = .0
        #
        self.chargeCorrelation = charge_correlation_encode('ig')
        self.update(condition)

    @property
    def objectsInSameBx(self):
        """Returns 'true' if all objects of same BX offset else returns 'false'."""
        return vhdl_bool(len(set([object.bx for object in self.objects])) == 1)

    def update(self, condition):
        def lowerLimit(esCut):
            """Returns rounded floating point for minimum."""
            value = esCut.getMinimum().value
            precision = esCut.getPrecision()
            scale = 10.**precision
            return math.floor(value * scale) / scale
        def upperLimit(esCut):
            """Returns rounded floating point for maximum."""
            value = esCut.getMaximum().value
            precision = esCut.getPrecision()
            scale = 10.**precision
            return math.ceil(value * scale) / scale

        #hasTwoBodyPtCut = False
        for esCut in condition.ptr.getCuts():
            if esCut.getCutType() == tmEventSetup.DeltaEta:
                self.hasDetaCut = vhdl_bool(True)
                self.diffEtaLowerLimit = lowerLimit(esCut)
                self.diffEtaUpperLimit = upperLimit(esCut)
            elif esCut.getCutType() == tmEventSetup.DeltaPhi:
                self.hasDphiCut = vhdl_bool(True)
                self.diffPhiLowerLimit = lowerLimit(esCut)
                self.diffPhiUpperLimit = upperLimit(esCut)
            elif esCut.getCutType() == tmEventSetup.DeltaR:
                self.hasDrCut = vhdl_bool(True)
                self.deltaRLowerLimit = lowerLimit(esCut)
                self.deltaRUpperLimit = upperLimit(esCut)
            elif esCut.getCutType() == tmEventSetup.Mass:
                self.hasMassCut = vhdl_bool(True)
                self.massLowerLimit = lowerLimit(esCut)
                self.massUpperLimit = upperLimit(esCut)
            elif esCut.getCutType() == tmEventSetup.TwoBodyPt:
                self.hasTwoBodyPtCut = vhdl_bool(True)
                self.twoBodyPtThres = lowerLimit(esCut)
            elif esCut.getCutType() == tmEventSetup.ChargeCorrelation:
                self.chargeCorrelation = charge_correlation_encode(esCut.getData())
            elif esCut.getCutType() == tmEventSetup.OvRmDeltaEta:
                self.hasDetaOrmCut = vhdl_bool(True)
                self.diffEtaOrmLowerLimit = lowerLimit(esCut)
                self.diffEtaOrmUpperLimit = upperLimit(esCut)
            elif esCut.getCutType() == tmEventSetup.OvRmDeltaPhi:
                self.hasDphiOrmCut = vhdl_bool(True)
                self.diffPhiOrmLowerLimit = lowerLimit(esCut)
                self.diffPhiOrmUpperLimit = upperLimit(esCut)
            elif esCut.getCutType() == tmEventSetup.OvRmDeltaR:
                self.hasDrOrmCut = vhdl_bool(True)
                self.deltaROrmLowerLimit = lowerLimit(esCut)
                self.deltaROrmUpperLimit = upperLimit(esCut)

        # Definition of mass_type:
        # 0 => invariant mass
        # 1 => transverse mass

        if condition.ptr.getType() == tmEventSetup.InvariantMassOvRm:
            self.massType = 0
        elif condition.ptr.getType() == tmEventSetup.TransverseMassOvRm:
            self.massType = 1

class CaloConditionOvRmHelper(ConditionHelper):
    """Correlation condition template helper class."""
    ReqObjects = 5
    """Number of required objects."""

    def __init__(self, condition):
        super(CaloConditionOvRmHelper, self).__init__(condition)
        # Flags
        self.hasDetaOrmCut = vhdl_bool(False)
        self.hasDphiOrmCut = vhdl_bool(False)
        self.hasDrOrmCut = vhdl_bool(False)
        self.hasTwoBodyPtCut = vhdl_bool(False)
        # Limits
        self.diffEtaOrmLowerLimit = .0
        self.diffEtaOrmUpperLimit = .0
        self.diffPhiOrmLowerLimit = .0
        self.diffPhiOrmUpperLimit = .0
        self.deltaROrmLowerLimit = .0
        self.deltaROrmUpperLimit = .0
        self.twoBodyPtThres = .0
        self.update(condition)

    @property
    def objectsInSameBx(self):
        """Returns 'true' if all objects of same BX offset else returns 'false'."""
        return vhdl_bool(len(set([object.bx for object in self.objects])) == 1)

    def update(self, condition):
        def lowerLimit(esCut):
            """Returns rounded floating point for minimum."""
            value = esCut.getMinimum().value
            precision = esCut.getPrecision()
            scale = 10.**precision
            return math.floor(value * scale) / scale
        def upperLimit(esCut):
            """Returns rounded floating point for maximum."""
            value = esCut.getMaximum().value
            precision = esCut.getPrecision()
            scale = 10.**precision
            return math.ceil(value * scale) / scale

        for esCut in condition.ptr.getCuts():
            if esCut.getCutType() == tmEventSetup.OvRmDeltaEta:
                self.hasDetaOrmCut = vhdl_bool(True)
                self.diffEtaOrmLowerLimit = lowerLimit(esCut)
                self.diffEtaOrmUpperLimit = upperLimit(esCut)
            elif esCut.getCutType() == tmEventSetup.OvRmDeltaPhi:
                self.hasDphiOrmCut = vhdl_bool(True)
                self.diffPhiOrmLowerLimit = lowerLimit(esCut)
                self.diffPhiOrmUpperLimit = upperLimit(esCut)
            elif esCut.getCutType() == tmEventSetup.OvRmDeltaR:
                self.hasDrOrmCut = vhdl_bool(True)
                self.deltaROrmLowerLimit = lowerLimit(esCut)
                self.deltaROrmUpperLimit = upperLimit(esCut)
            elif esCut.getCutType() == tmEventSetup.TwoBodyPt:
                self.hasTwoBodyPtCut = vhdl_bool(True)
                self.twoBodyPtThres = lowerLimit(esCut)

# -----------------------------------------------------------------------------
#  Object helpers
# -----------------------------------------------------------------------------

class ObjectHelper(VhdlHelper):
    """Generic object helper.

    Attributes:
        name                [str]
        type                [str]
        operator            [str]
        bx                  [str]
        externalSignalName  [str]
        externalChannelId   [int]
        threshold           [int]
        isolationLUT        [int]
        qualityLUT          [int]
        charge              [str]
        count               [int]
        etaFullRange        [str]
        etaW1LowerLimit     [int]
        etaW1UpperLimit     [int]
        etaW2Ignore         [str]
        etaW2LowerLimit     [int]
        etaW2UpperLimit     [int]
        phiFullRange        [str]
        phiW1LowerLimit     [int]
        phiW1UpperLimit     [int]
        phiW2Ignore         [str]
        phiW2LowerLimit     [int]
        phiW2UpperLimit     [int]
        isValid             is False if object is not initialized [bool]
    """

    def __init__(self):
        # common attributes
        self.name = 'UNDEFINED'
        self.type = 'UNDEFINED'
        self.operator = vhdl_bool(True)
        self.bx = bx_encode(0)
        self.externalSignalName = 'UNDEFINED'
        self.externalChannelId = 0
        # common cuts
        self.threshold = 0
        self.isolationLUT = 0xf
        self.qualityLUT = 0xffff
        self.charge = charge_encode('ign')
        self.count = 0
        # spatial cuts
        self.etaFullRange = vhdl_bool(True)
        self.etaW1LowerLimit = 0
        self.etaW1UpperLimit = 0
        self.etaW2Ignore = vhdl_bool(True)
        self.etaW2LowerLimit = 0
        self.etaW2UpperLimit = 0
        self.phiFullRange = vhdl_bool(True)
        self.phiW1LowerLimit = 0
        self.phiW1UpperLimit = 0
        self.phiW2Ignore = vhdl_bool(True)
        self.phiW2LowerLimit = 0
        self.phiW2UpperLimit = 0
        self.sliceLow = 0
        self.sliceHigh = 0
        # State of object
        self.isValid = False

    def update(self, esObject):
        self.name = esObject.getName()
        self.type = ObjectTypes[esObject.getType()]
        self.operator = vhdl_bool(ComparisonOperator[esObject.getComparisonOperator()])
        self.bx = bx_encode(esObject.getBxOffset())
        self.externalSignalName = esObject.getExternalSignalName()
        self.externalChannelId = esObject.getExternalChannelId()
        # set the default slice range to maxNum - 1 (e.g. 0-11)
        self.sliceHigh = ObjectCount[esObject.getType()] - 1
        etaCuts = []
        phiCuts = []
        # setup cuts
        for cut in esObject.getCuts():
            if cut.getCutType() == tmEventSetup.Threshold:
                self.threshold = cut.getMinimumIndex()
            elif cut.getCutType() == tmEventSetup.Isolation:
                self.isolationLUT = int(cut.getData())
            elif cut.getCutType() == tmEventSetup.Eta:
                etaCuts.append((cut.getMinimumIndex(), cut.getMaximumIndex()))
            elif cut.getCutType() == tmEventSetup.Phi:
                phiCuts.append((cut.getMinimumIndex(), cut.getMaximumIndex()))
            elif cut.getCutType() == tmEventSetup.Quality:
                self.qualityLUT = int(cut.getData())
            elif cut.getCutType() == tmEventSetup.Charge:
                self.charge = charge_encode(cut.getData())
            if cut.getCutType() == tmEventSetup.Count:
                self.count = cut.getMinimumIndex()
            if cut.getCutType() == tmEventSetup.Slice:
                self.sliceLow  =  int(cut.getMinimumValue())
                self.sliceHigh =  int(cut.getMaximumValue())
        # setup eta windows
        if len(etaCuts) > 0:
            self.etaFullRange = vhdl_bool(False)
            self.etaW1LowerLimit = etaCuts[0][0]
            self.etaW1UpperLimit = etaCuts[0][1]
        if len(etaCuts) > 1:
            self.etaW2Ignore = vhdl_bool(False)
            self.etaW2LowerLimit = etaCuts[1][0]
            self.etaW2UpperLimit = etaCuts[1][1]
        # setup phi windows
        if len(phiCuts) > 0:
            self.phiFullRange = vhdl_bool(False)
            self.phiW1LowerLimit = phiCuts[0][0]
            self.phiW1UpperLimit = phiCuts[0][1]
        if len(phiCuts) > 1:
            self.phiW2Ignore = vhdl_bool(False)
            self.phiW2LowerLimit = phiCuts[1][0]
            self.phiW2UpperLimit = phiCuts[1][1]
        self.isValid = True

# -----------------------------------------------------------------------------
#  Tests
# -----------------------------------------------------------------------------

if __name__ == '__main__':
    # Create tray
    resource = os.path.join(os.path.dirname(__file__), '..', 'config', 'resource_default.json')
    tray = algodist.ResourceTray(resource)
    # Load event setup
    eventSetup = tmEventSetup.getTriggerMenu(sys.argv[1])
    # Distribute modules
    collection = algodist.ModuleCollection(eventSetup, tray)
    collection.distribute(modules=2, ratio=.5)
    # Create template helper
    menu = MenuHelper(collection)

    # Info
    print "*" * 80
    print "menu.info.name          :", menu.info.name
    print "menu.info.uuid_menu     :", menu.info.uuid_menu
    print "menu.info.uuid_firmware :", menu.info.uuid_firmware
    print "menu.info.scale_set     :", menu.info.scale_set
    print "menu.info.version       :", menu.info.version
    print "menu.info.sw_version    :", menu.info.sw_version
    print "menu.info.svn_revision  :", menu.info.svn_revision
    print "*" * 80
    print "menu.algorithms|length  :", len(menu.algorithms)
    print "menu.conditions|length  :", len(menu.conditions)
    print "*" * 80

    assert len(eventSetup.getAlgorithmMapPtr()) == len(menu.algorithms), "algorithm count missmatch"
    assert len(eventSetup.getConditionMapPtr()) == len(menu.conditions), "condition count missmatch"
    assert len(menu.algorithms) == sum([len(module) for module in menu.modules]), "algorithm distribution count missmatch"

    # Modules
    for module in menu.modules:
        print "module.id                :", module.id
        print "module.algorithms|length :", len(module.algorithms)
        print "module.conditions|length :", len(module.conditions)
        print "-" * 80
        print "module.correlationCombinations:"
        for a, b in module.correlationCombinations:
            print " ", a.type, a.bx, "<>", b.type, b.bx
        print "-" * 80
        print "module.muonBxCombinations:"
        for a, b in module.muonBxCombinations:
            print "  {a} <> {b}".format(a=a, b=b)
        print "-" * 80
        print "module.conversionObjects:"
        for o in module.conversionObjects:
            print "  {o.name} (type:{o.type}, threshold:{o.threshold}, bx:{o.bx})".format(o=o)
        print "-" * 80
        print "module.correlationObjects:"
        for o in module.correlationObjects:
            print "  {o.name} (type:{o.type}, threshold:{o.threshold}, bx:{o.bx})".format(o=o)
        print "-" * 80

        for condition in module.conditions:
            print "condition.name        :", condition.name
            print "condition.vhdl_signal :", condition.vhdl_signal
            print "condition.type :", condition.type
            if condition.type == 'InvariantMass':
                print "condition.massLowerLimit :", condition.massLowerLimit
                print "condition.massUpperLimit :", condition.massUpperLimit
            print "condition.objects:"
            for object in condition.objects:
                print "  name      :", object.name
                print "  type      :", object.type
                print "  threshold :", object.threshold
                print "  bx        :", object.bx
        print "*" * 80
