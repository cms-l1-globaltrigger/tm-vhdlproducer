"""Template helper classes.

Overview of class hierarchy:

Basic template helpers for menu, modules and algorithms.

  * VhdlHelper
  * VersionHelper
  * MenuHelper
  * InfoHelper
  * ModuleHelper
  * AlgorithmHelper

Condition template helpers for needs of different condition types.

  * ConditionHelper
    * SimpleConditionHelper
    * CaloConditionHelper
    * MuonConditionHelper
    * ExternalConditionHelper
    * CorrelationConditionHelper
    * CorrelationConditionOvRmHelper
    * CaloConditionOvRmHelper

Unified object template helper (proably better to create dedicated for every
object type).

  * ObjectHelper

Cut template helper, calculating thresholds and ranges according to provided
scales.

  * CutHelper
    * ThresholdCutHelper
      * TwoBodyPtCutHelper
    * RangeCutHelper
      * DeltaEtaCutHelper
      * DeltaPhiCutHelper
      * DeltaRCutHelper
      * MassCutHelper

"""

import math
import string
import re, os

from distutils.version import StrictVersion

import tmEventSetup
import tmGrammar  # import after tmEventSetup

from . import algodist
from . import __version__

# -----------------------------------------------------------------------------
#  Precompiled regular expressions
# -----------------------------------------------------------------------------

RegexCamelSnake1=re.compile(r'([^_])([A-Z][a-z]+)')
RegexCamelSnake2=re.compile('([a-z0-9])([A-Z])')
RegexVhdlLabel=re.compile('[^A-Za-z0-9_]')

# -----------------------------------------------------------------------------
#  Conversion dictionaries
# -----------------------------------------------------------------------------

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
#    tmEventSetup.HTMHF: tmGrammar.HTMHF,
    tmEventSetup.HTM: tmGrammar.HTM,
    tmEventSetup.ASYMET: tmGrammar.ASYMET,
    tmEventSetup.ASYMHT: tmGrammar.ASYMHT,
    tmEventSetup.ASYMETHF: tmGrammar.ASYMETHF,
    tmEventSetup.ASYMHTHF: tmGrammar.ASYMHTHF,
    tmEventSetup.CENT0: tmGrammar.CENT0,
    tmEventSetup.CENT1: tmGrammar.CENT1,
    tmEventSetup.CENT2: tmGrammar.CENT2,
    tmEventSetup.CENT3: tmGrammar.CENT3,
    tmEventSetup.CENT4: tmGrammar.CENT4,
    tmEventSetup.CENT5: tmGrammar.CENT5,
    tmEventSetup.CENT6: tmGrammar.CENT6,
    tmEventSetup.CENT7: tmGrammar.CENT7,
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
#    tmEventSetup.HTMHF:      1,
    tmEventSetup.HTM:        1,
    tmEventSetup.ASYMET:     1,
    tmEventSetup.ASYMHT:     1,
    tmEventSetup.ASYMETHF:   1,
    tmEventSetup.ASYMHTHF:   1,
    tmEventSetup.CENT0:      1,
    tmEventSetup.CENT1:      1,
    tmEventSetup.CENT2:      1,
    tmEventSetup.CENT3:      1,
    tmEventSetup.CENT4:      1,
    tmEventSetup.CENT5:      1,
    tmEventSetup.CENT6:      1,
    tmEventSetup.CENT7:      1,
    tmEventSetup.EXT:        1,
    tmEventSetup.MBT0HFP:    1,
    tmEventSetup.MBT1HFP:    1,
    tmEventSetup.MBT0HFM:    1,
    tmEventSetup.MBT1HFM:    1,
    tmEventSetup.TOWERCOUNT: 1,
}

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
    subbed = RegexCamelSnake1.sub(rf'\1{separator}\2', label)
    return RegexCamelSnake2.sub(rf'\1{separator}\2', subbed).lower()

def unique_name(name, names):
    """Generate unique signal name to prevent name collisions."""
    count = 1
    def suffixed():
        if count > 1:
            return f'{name}_{count}'
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
    label = RegexVhdlLabel.sub('_', label.strip()) # Replace unsave characters by underscore.
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
    if value > 0: return f'p{value:d}'
    # Prefix negative values with m instead of minus sign (abs).
    if value < 0: return f'm{abs(value):d}'
    # Zero value is not prefixed according to VHDL documentation.
    return '0'

# -----------------------------------------------------------------------------
#  Factories
# -----------------------------------------------------------------------------

def conditionFactory(condition_handle):
    """Returns condition template helper class according to condition handle."""
    if condition_handle.isCaloCondition():
        return CaloConditionHelper(condition_handle)
    elif condition_handle.isMuonCondition():
        return MuonConditionHelper(condition_handle)
    elif condition_handle.isEsumsCondition():
        return EsumsConditionHelper(condition_handle)
    elif condition_handle.isSignalCondition():
        return SignalConditionHelper(condition_handle)
    elif condition_handle.isExternalCondition():
        return ExternalConditionHelper(condition_handle)
    elif condition_handle.isMinBiasCondition():
        return MinBiasConditionHelper(condition_handle)
    elif condition_handle.isTowerCountCondition():
        return TowerCountConditionHelper(condition_handle)
    elif condition_handle.isCorrelationCondition():
        return CorrelationConditionHelper(condition_handle)
    elif condition_handle.isCorrelation3Condition():
        return Correlation3ConditionHelper(condition_handle)
    elif condition_handle.isCorrelationConditionOvRm():
        return CorrelationConditionOvRmHelper(condition_handle)
    elif condition_handle.isCaloConditionOvRm():
        return CaloConditionOvRmHelper(condition_handle)
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
        version = StrictVersion(version).version
        self.major = version[0]
        self.minor = version[1]
        self.patch = version[2]

    def __str__(self):
        return f"{self.major}.{self.minor}.{self.patch}"

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
    """

    def __init__(self, collection):
        eventSetup = collection.eventSetup
        # Init attribiutes
        self.name = eventSetup.getName()
        self.uuid_menu = eventSetup.getMenuUuid()
        self.uuid_firmware = eventSetup.getFirmwareUuid()
        self.scale_set = eventSetup.getScaleSetName()
        self.version = VersionHelper(tmEventSetup.__version__)
        self.sw_version = VersionHelper(__version__)

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

        def add_algorithm(algorithm_handle):
            """Add algorithm helper asigning a unique name."""
            helper = AlgorithmHelper(algorithm_handle)
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
        return filter(lambda condition: condition.handle.isMuonCondition(), self.conditions)

    @property
    def caloConditions(self):
        return filter(lambda condition: condition.handle.isCaloCondition(), self.conditions)

    @property
    def caloConditionsOvRm(self):
        return filter(lambda condition: condition.handle.isCaloConditionOvRm(), self.conditions)

    @property
    def esumsConditions(self):
        return filter(lambda condition: condition.handle.isEsumsCondition(), self.conditions)

    @property
    def signalConditions(self):
        return filter(lambda condition: condition.handle.isSignalCondition(), self.conditions)

    @property
    def externalConditions(self):
        return filter(lambda condition: condition.handle.isExternalCondition(), self.conditions)

    @property
    def caloCaloCorrConditions(self):
        return filter(lambda condition: condition.handle.isCorrelationCondition() and \
             (condition.objects[0].is_calo_type and condition.objects[1].is_calo_type), self.conditions)

    @property
    def caloCaloCorrOvRmConditions(self):
        return filter(lambda condition: condition.handle.isCorrelationConditionOvRm() and \
             (condition.objects[0].is_calo_type and condition.objects[1].is_calo_type), self.conditions)

    @property
    def caloMuonCorrConditions(self):
        return filter(lambda condition: condition.handle.isCorrelationCondition() and \
             (condition.objects[0].is_calo_type and condition.objects[1].is_muon_type), self.conditions)

    @property
    def muonMuonCorrConditions(self):
        return filter(lambda condition: condition.handle.isCorrelationCondition() and \
             (condition.objects[0].is_muon_type and condition.objects[1].is_muon_type), self.conditions)

    @property
    def caloEsumCorrConditions(self):
        return filter(lambda condition: condition.handle.isCorrelationCondition() and \
             (condition.objects[0].is_calo_type and condition.objects[1].is_esums_type), self.conditions)

    @property
    def muonEsumCorrConditions(self):
        return filter(lambda condition: condition.handle.isCorrelationCondition() and \
             (condition.objects[0].is_muon_type and condition.objects[1].is_esums_type), self.conditions)

    @property
    def caloCorr3Conditions(self):
        return filter(lambda condition: condition.handle.isCorrelation3Condition() and \
             (condition.objects[0].is_calo_type and condition.objects[1].is_calo_type and condition.objects[2].is_calo_type), self.conditions)

    @property
    def muonCorr3Conditions(self):
        return filter(lambda condition: condition.handle.isCorrelation3Condition() and \
             (condition.objects[0].is_muon_type and condition.objects[1].is_muon_type and condition.objects[2].is_muon_type), self.conditions)

    @property
    def minBiasConditions(self):
        return filter(lambda condition: condition.handle.isMinBiasCondition(), self.conditions)

    @property
    def towerCountConditions(self):
        return filter(lambda condition: condition.handle.isTowerCountCondition(), self.conditions)

    @property
    def correlationCombinations(self):
        combinations = {}
        for condition in self.conditions:
            if isinstance(condition, CorrelationConditionHelper):
                a, b = condition.objects
                key = (a.type, b.type, a.bx, b.bx) # create custom hash
                combinations[key] = (a, b)
            if isinstance(condition, (CorrelationConditionOvRmHelper, Correlation3ConditionHelper)):
                if condition.nr_objects == 3:
                    a, b, c = condition.objects
                    key = (a.type, b.type, a.bx, b.bx) # a-b combination
                    combinations[key] = (a, b)
                    key = (a.type, c.type, a.bx, c.bx) # a-c combination
                    combinations[key] = (a, c)
                    key = (b.type, c.type, b.bx, c.bx) # b-c combination
                    combinations[key] = (b, c)
                else:
                    a = condition.objects[0]
                    b = condition.objects[1]
                    key = (a.type, b.type, a.bx, b.bx)
                    combinations[key] = (a, b)
            if isinstance(condition, CaloConditionOvRmHelper):
                a = condition.objects[0]
                b = condition.objects[condition.nr_objects-1]
                key = (a.type, b.type, a.bx, b.bx)
                combinations[key] = (a, b)
        return combinations.values()

    @property
    def correlationCombinationsInvMassDivDr(self):
        combinations = {}
        for condition in self.conditions:
            if hasattr(condition, 'mass') and condition.mass.enabled and condition.mass.type == condition.mass.InvariantMassDeltaRType:
                if isinstance(condition, CorrelationConditionHelper):
                    a, b = condition.objects
                    key = (a.type, b.type, a.bx, b.bx) # create custom hash
                    combinations[key] = (a, b)
        return combinations.values()

    @property
    def correlationObjects(self):
        """Retruns list of objects used by correlation conditions or any
        conditions using two body pt correlations.
        """
        def hasObjectCorrelation(condition):
            """True if either two body pt cut or correlation condtion type."""
            if condition.handle.isCorrelationCondition():
                return True
            if condition.handle.isCorrelation3Condition():
                return True
            if condition.handle.isCorrelationConditionOvRm():
                return True
            if condition.handle.isCaloConditionOvRm():
                return True
            if hasattr(condition, 'hasTwoBodyPtCut'):
                return bool(condition.twoBodyPt)
            return False
        objects = {}
        for condition in filter(hasObjectCorrelation, self.conditions):
            for obj in condition.objects:
                key = (obj.type, obj.bx) # create custom hash
                objects[key] = obj
        return objects.values()

    @property
    def conversionObjects(self):
        """Returns list of objects required for calo-muon and muon-esums correlations."""
        def isConversionCondition(condition):
            """Returns True if condition type requires eta/phi conversion."""
            if condition.handle.type in (tmEventSetup.CaloMuonCorrelation, tmEventSetup.MuonEsumCorrelation):
                return True
            # Muon-Esum combinations for transverse mass
            if condition.handle.type == tmEventSetup.TransverseMass:
                for obj in condition.objects:
                    if obj.is_esums_type:
                        return True
                return False
            # Calo-Muon combinations for invariant mass
            if condition.handle.type == tmEventSetup.InvariantMass:
                objects = condition.objects
                if objects[0].is_calo_type and \
                   objects[1].is_muon_type:
                    return True
                return False
        objects = {}
        for condition in filter(isConversionCondition, self.conditions):
            for obj in condition.objects:
                key = obj.type # create custom hash
                objects[key] = obj
        return objects.values()

    @property
    def muonBxCombinations(self):
        combinations = set()
        for condition in self.conditions:
            if isinstance(condition, (MuonConditionHelper, CorrelationConditionHelper)):
                if condition.nr_objects == 2:
                    a = condition.objects[0]
                    b = condition.objects[1]
                    combinations.add((a.bx, b.bx))
            elif isinstance(condition, Correlation3ConditionHelper):
                if condition.nr_objects == 3:
                    a = condition.objects[0]
                    b = condition.objects[1]
                    c = condition.objects[2]
                    combinations.add((a.bx, b.bx))
                    combinations.add((a.bx, c.bx))
                    combinations.add((b.bx, c.bx))
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
        handle           reference to underlying algorithm handle [AlgorithmHandle]
    """

    def __init__(self, algorithm_handle):
        self.index = algorithm_handle.index
        self.name = algorithm_handle.name
        self.module_id = algorithm_handle.module_id
        self.module_index = algorithm_handle.module_index
        self.expression = algorithm_handle.expression
        self.vhdl_signal = vhdl_label(algorithm_handle.name)
        self.vhdl_expression =  vhdl_expression( algorithm_handle.expression_in_condition )
        self.conditions = self.collect_conditions(algorithm_handle)
        self.handle = algorithm_handle

    def collect_conditions(self, algorithm_handle):
        """Collects list of conditions referenced by the algorithm expression from
        an AlgorithmHandle instance. Returns list of condition template helpers sorted
        by number of objects, condition type and name.
        """
        conditions = {}
        for condition_handle in algorithm_handle:
            if condition_handle.name not in conditions: # assumes condition name is unique
                conditions[condition_handle.name] = conditionFactory(condition_handle)
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
        handle       reference to underlying condition handle [ConditionHandle]
    """
    ReqObjects = 1
    """Number of required objects."""

    def __init__(self, condition_handle):
        # Default attributes
        self.name = condition_handle.name
        self.type = algodist.ConditionTypeKey[condition_handle.type] # type name!
        self.vhdl_signal = vhdl_label(condition_handle.name)
        self.handle = condition_handle
        self.init_objects()
        self.update_objects(condition_handle)

    def init_objects(self):
        """Initialize default condition objects."""
        self.objects = []
        for _ in range(self.ReqObjects):
            self.objects.append(ObjectHelper())

    def update_objects(self, condition_handle):
        """Update objects assigned to this condition."""
        objects = list(condition_handle.objects)
        assert 0 < len(objects) <= self.ReqObjects, "condition object count missmatch"
        # Objects are returned in correct order!
        for i, obj in enumerate(objects):
            self.objects[i].update(obj)

    @property
    def nr_objects(self):
        """Returns number of valid objects."""
        return len([obj for obj in self.objects if obj.isValid])

    def __len__(self):
        """Returns count of objects assigned to this condition."""
        return len(self.objects)

    def __iter__(self):
        """Iterate over objects."""
        return iter([obj for obj in self.objects])

class CaloConditionHelper(ConditionHelper):
    """Calorimeter condition template helper class.

    Attributes:
        name         condition name from event setup [str]
        type         condition type name [str]
        vhdl_signal  VHDL safe condition signal name [str]
        threshold    threshold bin index, alias for objects[0].threshold [int]
        objects      list of object template helpers contained by condition
        nr_objects   number of actually used objects [int]
        handle       reference to underlying condition handle [ConditionHandle]
        twoBodyPt    [TwoBodyPtCutHelper]
    """
    ReqObjects = 4
    """Number of required objects."""

    def __init__(self, condition_handle):
        super().__init__(condition_handle)
        # Default attributes
        self.twoBodyPt = TwoBodyPtCutHelper()
        self.update(condition_handle)

    def update(self, condition_handle):
        for cut_handle in condition_handle.cuts:
            if cut_handle.cut_type == tmEventSetup.TwoBodyPt:
                self.twoBodyPt.update(cut_handle)

class MuonConditionHelper(ConditionHelper):
    """Muon condition template helper class.

    Attributes:
        name              condition name from event setup [str]
        type              condition type name [str]
        vhdl_signal       VHDL safe condition signal name [str]
        objects           list of object template helpers contained by condition
        nr_objects        number of actually used objects [int]
        handle            reference to underlying condition handle [ConditionHandle]
        chargeCorrelation [ChargeCorrelationCutHelper]
        twoBodyPt         [TwoBodyPtCutHelper]
    """
    ReqObjects = 4
    """Number of required objects."""

    def __init__(self, condition_handle):
        super().__init__(condition_handle)
        # Default attributes
        self.chargeCorrelation = ChargeCorrelationCutHelper('ig')
        self.twoBodyPt = TwoBodyPtCutHelper()
        self.update_cuts(condition_handle)

    def update_cuts(self, condition_handle):
        for cut_handle in condition_handle.cuts:
            if cut_handle.cut_type == tmEventSetup.ChargeCorrelation:
                self.chargeCorrelation.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.TwoBodyPt:
                self.twoBodyPt.update(cut_handle)

class EsumsConditionHelper(ConditionHelper):
    """Esums condition template helper class."""
    ReqObjects = 1
    """Number of required objects."""

class SignalConditionHelper(ConditionHelper):
    """Signal condition template helper class."""
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
    """Correlation condition template helper class.

    Attributes:
        name              condition name from event setup [str]
        type              condition type name [str]
        vhdl_signal       VHDL safe condition signal name [str]
        objects           list of object template helpers contained by condition
        nr_objects        number of actually used objects [int]
        handle            reference to underlying condition handle [ConditionHandle]
        deltaEta          [DeltaEtaCutHelper]
        deltaPhi          [DeltaPhiCutHelper]
        deltaR            [DeltaRCutHelper]
        mass              [MassCutHelper]
        twoBodyPt         [TwoBodyPtCutHelper]
        chargeCorrelation [ChargeCorrelationCutHelper]
    """

    ReqObjects = 2
    """Number of required objects."""

    def __init__(self, condition_handle):
        super().__init__(condition_handle)
        # Default attributes
        self.deltaEta = DeltaEtaCutHelper()
        self.deltaPhi = DeltaPhiCutHelper()
        self.deltaR = DeltaRCutHelper()
        self.mass = MassCutHelper()
        self.twoBodyPt = TwoBodyPtCutHelper()
        self.chargeCorrelation = ChargeCorrelationCutHelper('ig')
        self.update(condition_handle)

    @property
    def objectsInSameBx(self):
        """Returns 'true' if all objects of same BX offset else returns 'false'."""
        return 1 == len(set([obj.bx for obj in self.objects]))

    def update(self, condition_handle):
        for cut_handle in condition_handle.cuts:
            if cut_handle.cut_type == tmEventSetup.DeltaEta:
                self.deltaEta.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.DeltaPhi:
                self.deltaPhi.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.DeltaR:
                self.deltaR.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.Mass:
                self.mass.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.MassUpt:
                self.mass.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.MassDeltaR:
                self.mass.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.TwoBodyPt:
                self.twoBodyPt.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.ChargeCorrelation:
                self.chargeCorrelation.update(cut_handle)

        # Set mass cut type
        self.mass.deduceType(condition_handle)

class Correlation3ConditionHelper(ConditionHelper):
    """Correlation of 3 objects condition template helper class.

    Attributes:
        name              condition name from event setup [str]
        type              condition type name [str]
        vhdl_signal       VHDL safe condition signal name [str]
        objects           list of object template helpers contained by condition
        nr_objects        number of actually used objects [int]
        handle            reference to underlying condition handle [ConditionHandle]
        mass              [MassCutHelper]
        chargeCorrelation [ChargeCorrelationCutHelper]
    """

    ReqObjects = 3
    """Number of required objects."""

    def __init__(self, condition_handle):
        super().__init__(condition_handle)
        # Default attributes
        self.mass = MassCutHelper()
        self.chargeCorrelation = ChargeCorrelationCutHelper('ig')
        self.update(condition_handle)

    @property
    def objectsInSameBx(self):
        """Returns 'true' if all objects of same BX offset else returns 'false'."""
        return 1 == len(set([obj.bx for obj in self.objects]))

    def update(self, condition_handle):
        for cut_handle in condition_handle.cuts:
            if cut_handle.cut_type == tmEventSetup.Mass:
                self.mass.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.ChargeCorrelation:
                self.chargeCorrelation.update(cut_handle)

        # Set mass cut type
        self.mass.deduceType(condition_handle)

class CorrelationConditionOvRmHelper(ConditionHelper):
    """Correlation condition template helper class.

    Attributes:
        name              condition name from event setup [str]
        type              condition type name [str]
        vhdl_signal       VHDL safe condition signal name [str]
        objects           list of object template helpers contained by condition
        nr_objects        number of actually used objects [int]
        handle            reference to underlying condition handle [ConditionHandle]
        deltaEtaOrm       [DeltaEtaCutHelper]
        deltaPhiOrm       [DeltaPhiCutHelper]
        deltaROrm         [DeltaRCutHelper]
        deltaEta          [DeltaEtaCutHelper]
        deltaPhi          [DeltaPhiCutHelper]
        deltaR            [DeltaRCutHelper]
        mass              [MassCutHelper]
        twoBodyPt         [TwoBodyPtCutHelper]
        chargeCorrelation [ChargeCorrelationCutHelper]
    """

    ReqObjects = 3
    """Number of required objects."""

    def __init__(self, condition_handle):
        super().__init__(condition_handle)
        # Default attributes
        self.deltaEtaOrm = DeltaEtaCutHelper()
        self.deltaPhiOrm = DeltaPhiCutHelper()
        self.deltaROrm = DeltaRCutHelper()
        self.deltaEta = DeltaEtaCutHelper()
        self.deltaPhi = DeltaPhiCutHelper()
        self.deltaR = DeltaRCutHelper()
        self.mass = MassCutHelper()
        self.twoBodyPt = TwoBodyPtCutHelper()
        self.chargeCorrelation = ChargeCorrelationCutHelper('ig')
        self.update(condition_handle)

    @property
    def objectsInSameBx(self):
        """Returns 'true' if all objects of same BX offset else returns 'false'."""
        return 1 == len(set([obj.bx for obj in self.objects]))

    def update(self, condition_handle):
        for cut_handle in condition_handle.cuts:
            if cut_handle.cut_type == tmEventSetup.DeltaEta:
                self.deltaEta.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.DeltaPhi:
                self.deltaPhi.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.DeltaR:
                self.deltaR.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.Mass:
                self.mass.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.TwoBodyPt:
                self.twoBodyPt.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.ChargeCorrelation:
                self.chargeCorrelation.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.OvRmDeltaEta:
                self.deltaEtaOrm.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.OvRmDeltaPhi:
                self.deltaPhiOrm.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.OvRmDeltaR:
                self.deltaROrm.update(cut_handle)

        # Set mass cut type
        self.mass.deduceType(condition_handle)

class CaloConditionOvRmHelper(ConditionHelper):
    """Correlation condition template helper class.

    Attributes:
        name         condition name from event setup [str]
        type         condition type name [str]
        vhdl_signal  VHDL safe condition signal name [str]
        objects      list of object template helpers contained by condition
        nr_objects   number of actually used objects [int]
        handle       reference to underlying condition handle [ConditionHandle]
        deltaEtaOrm  [DeltaEtaCutHelper]
        deltaPhiOrm  [DeltaPhiCutHelper]
        deltaROrm    [DeltaRCutHelper]
        twoBodyPt    [TwoBodyPtCutHelper]
    """

    ReqObjects = 5
    """Number of required objects."""

    def __init__(self, condition_handle):
        super().__init__(condition_handle)
        # Defaults
        self.deltaEtaOrm = DeltaEtaCutHelper(0, 0)
        self.deltaPhiOrm = DeltaPhiCutHelper(0, 0)
        self.deltaROrm = DeltaRCutHelper(0, 0)
        self.twoBodyPt = TwoBodyPtCutHelper()
        self.update(condition_handle)

    @property
    def objectsInSameBx(self):
        """Returns 'true' if all objects of same BX offset else returns 'false'."""
        return 1 == len(set([obj.bx for obj in self.objects]))

    def update(self, condition_handle):
        for cut_handle in condition_handle.cuts:
            if cut_handle.cut_type == tmEventSetup.OvRmDeltaEta:
                self.deltaEtaOrm.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.OvRmDeltaPhi:
                self.deltaPhiOrm.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.OvRmDeltaR:
                self.deltaROrm.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.TwoBodyPt:
                self.twoBodyPt.update(cut_handle)

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
        isolation           [IsolationCutHelper]
        quality             [QualityCutHelper]
        charge              [ChargeCutHelper]
        count               [CountCutHelper]
        upt                 [UptCutHelper]
        impactParameter     [ImpactParameterCutHelper]
        etaNrCuts           [int]
        etaLowerLimit       [list]
        etaLowerLimit       [list]
        phi                 [list of RangeCutHelper]
        phiFullRange        [bool]
        phiW2Ignore         [bool]
        slice               [SliceCutHelper]
        isValid             is False if object is not initialized [bool]
        is_muon_type        [bool]
        is_calo_type        [bool]
        is_esums_type       [bool]
        handle              handle to underlying object handle [None|ObjectHandle]
    """

    def __init__(self):
        # common attributes
        self.name = 'UNDEFINED'
        self.type = 'UNDEFINED'
        self.operator = True
        self.bx = bx_encode(0)
        self.externalSignalName = 'UNDEFINED'
        self.externalChannelId = 0
        # common cuts
        self.threshold = 0
        self.isolation = IsolationCutHelper(0xf)
        self.quality = QualityCutHelper(0xffff)
        self.charge = ChargeCutHelper('ign')
        self.count = CountCutHelper()
        self.upt = UptCutHelper()
        self.impactParameter = ImpactParameterCutHelper(0xf)
        # spatial cuts
        self.etaNrCuts = 0
        self.etaLowerLimit = [0, 0, 0, 0, 0]
        self.etaUpperLimit = [0, 0, 0, 0, 0]
        self.phiNrCuts = 0
        self.phiFullRange = True
        self.phiW1 = RangeCutHelper()
        self.phiW2Ignore = True
        self.phiW2 = RangeCutHelper()
        self.slice = SliceCutHelper()
        # State of object
        self.isValid = False
        self.handle = None

    def update(self, object_handle):
        self.name = object_handle.name
        self.type = ObjectTypes[object_handle.type]
        self.operator = ComparisonOperator[object_handle.comparison_operator]
        self.bx = bx_encode(object_handle.bx_offset)
        self.externalSignalName = object_handle.external_signal_name
        self.externalChannelId = object_handle.external_channel_id
        # set the default slice range to maxNum - 1 (e.g. 0-11)
        self.slice.upper = ObjectCount[object_handle.type] - 1
        etaCuts = []
        phiCuts = []
        # setup cuts
        for cut_handle in object_handle.cuts:
            if cut_handle.cut_type == tmEventSetup.Threshold:
                self.threshold = cut_handle.minimum.index
            elif cut_handle.cut_type == tmEventSetup.Isolation:
                self.isolation.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.Eta:
                etaCuts.append((cut_handle.minimum.index, cut_handle.maximum.index))
            elif cut_handle.cut_type == tmEventSetup.Phi:
                phiCuts.append((cut_handle.minimum.index, cut_handle.maximum.index))
            elif cut_handle.cut_type == tmEventSetup.Quality:
                self.quality.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.Charge:
                self.charge.update(cut_handle)
            if cut_handle.cut_type == tmEventSetup.Count:
                self.count.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.UnconstrainedPt:
                self.upt.update(cut_handle)
            elif cut_handle.cut_type == tmEventSetup.ImpactParameter:
                self.impactParameter.update(cut_handle)
            if cut_handle.cut_type == tmEventSetup.Slice:
                self.slice.update(cut_handle)
        # setup eta windows
        if len(etaCuts) > 0:
            self.etaNrCuts = 1
            self.etaLowerLimit[0] = etaCuts[0][0]
            self.etaUpperLimit[0] = etaCuts[0][1]
        if len(etaCuts) > 1:
            self.etaNrCuts = 2
            self.etaLowerLimit[1] = etaCuts[1][0]
            self.etaUpperLimit[1] = etaCuts[1][1]
        if len(etaCuts) > 2:
            self.etaNrCuts = 3
            self.etaLowerLimit[2] = etaCuts[2][0]
            self.etaUpperLimit[2] = etaCuts[2][1]
        if len(etaCuts) > 3:
            self.etaNrCuts = 4
            self.etaLowerLimit[3] = etaCuts[3][0]
            self.etaUpperLimit[3] = etaCuts[3][1]
        if len(etaCuts) > 4:
            self.etaNrCuts = 5
            self.etaLowerLimit[4] = etaCuts[4][0]
            self.etaUpperLimit[4] = etaCuts[4][1]
        # update phi window flags
        if len(phiCuts) > 0:
            self.phiNrCuts = 1
            self.phiFullRange = False
            self.phiW1.lower = phiCuts[0][0]
            self.phiW1.upper = phiCuts[0][1]
            self.phiW1.enabled = True
        if len(phiCuts) > 1:
            self.phiNrCuts = 2
            self.phiW2Ignore = False
            self.phiW2.lower = phiCuts[1][0]
            self.phiW2.upper = phiCuts[1][1]
            self.phiW2.enabled = True
        self.isValid = True
        self.handle = object_handle

    @property
    def is_muon_type(self):
        """Retruns True if object is of muon type."""
        return self.handle and self.handle.isMuonObject()

    @property
    def is_calo_type(self):
        """Retruns True if object is of calorimeter type."""
        return self.handle and self.handle.isCaloObject()

    @property
    def is_esums_type(self):
        """Retruns True if object is of energy sums type."""
        return self.handle and self.handle.isEsumsObject()

    @property
    def is_signal_type(self):
        """Retruns True if object is of energy sums type."""
        return self.handle and self.handle.isSignalObject()

# -----------------------------------------------------------------------------
#  Cut helper
# -----------------------------------------------------------------------------


class CutHelper(VhdlHelper):

    def __init__(self):
        self.enabled = False

    def __bool__(self):
        return self.enabled

class ThresholdCutHelper(CutHelper):

    def __init__(self, threshold=0):
        super().__init__()
        self.threshold = threshold

class CountCutHelper(ThresholdCutHelper):

    def update(self, cut_handle):
        """Updates threshold and enables cut."""
        self.threshold = cut_handle.minimum.index
        self.enabled = True

class TwoBodyPtCutHelper(ThresholdCutHelper):

    def update(self, cut_handle):
        """Updates threshold and enables cut."""
        scale = 10**cut_handle.precision
        assert cut_handle.precision_pt != 0
        scale_pt = 10**cut_handle.precision_pt
        assert cut_handle.precision_math != 0
        scale_math = 10**cut_handle.precision_math
        self.threshold = math.floor(cut_handle.minimum.value * scale) / scale * (scale_pt * scale_pt) * (scale_math * scale_math)
        self.enabled = True

class LookupTableCutHelper(CutHelper):

    def __init__(self, value=0):
        super().__init__()
        self.value = value

class IsolationCutHelper(LookupTableCutHelper):

    def update(self, cut_handle):
        """Updates LUT value and enables cut."""
        self.value = int(cut_handle.data)
        self.enabled = True

class QualityCutHelper(LookupTableCutHelper):

    def update(self, cut_handle):
        """Updates LUT value and enables cut."""
        self.value = int(cut_handle.data)
        self.enabled = True

class ImpactParameterCutHelper(LookupTableCutHelper):

    def update(self, cut_handle):
        """Updates LUT value and enables cut."""
        self.value = int(cut_handle.data)
        self.enabled = True

class ChargeCutHelper(CutHelper):

    def __init__(self, value):
        super().__init__()
        self.value = charge_encode(value)

    def update(self, cut_handle):
        """Updates LUT value and enables cut."""
        self.value = charge_encode(cut_handle.data)
        self.enabled = True

class ChargeCorrelationCutHelper(CutHelper):

    def __init__(self, value):
        super().__init__()
        self.value = charge_correlation_encode(value)

    def update(self, cut_handle):
        """Updates LUT value and enables cut."""
        self.value = charge_correlation_encode(cut_handle.data)
        self.enabled = True

class RangeCutHelper(CutHelper):

    def __init__(self, lower=0, upper=0):
        super().__init__()
        self.lower = lower
        self.upper = upper

class UptCutHelper(RangeCutHelper):

    def update(self, cut_handle):
        """Updates limits and enables cut."""
        self.lower = cut_handle.minimum.index
        self.upper = cut_handle.maximum.index
        self.enabled = True

class DeltaEtaCutHelper(RangeCutHelper):

    def update(self, cut_handle):
        """Updates limits and enables cut."""
        scale = 10.**cut_handle.precision
        self.lower = math.floor(cut_handle.minimum.value * scale)
        self.upper = math.ceil(cut_handle.maximum.value * scale)
        self.enabled = True

class DeltaPhiCutHelper(RangeCutHelper):

    def update(self, cut_handle):
        """Updates limits and enables cut."""
        scale = 10.**cut_handle.precision
        self.lower = math.floor(cut_handle.minimum.value * scale)
        self.upper = math.ceil(cut_handle.maximum.value * scale)
        self.enabled = True

class DeltaRCutHelper(RangeCutHelper):

    def update(self, cut_handle):
        """Updates limits and enables cut."""
        scale = 10.**cut_handle.precision
        self.lower = math.floor(cut_handle.minimum.value * scale) / scale * (scale * scale)
        self.upper = math.ceil(cut_handle.maximum.value * scale) / scale * (scale * scale)
        self.enabled = True

class MassCutHelper(RangeCutHelper):

    # VHDL enumeration
    InvariantMassType = "INVARIANT_MASS_TYPE"
    TransverseMassType = "TRANSVERSE_MASS_TYPE"
    InvariantMassUptType = "INVARIANT_MASS_UPT_TYPE"
    InvariantMassDeltaRType = "INVARIANT_MASS_DIV_DR_TYPE"

    MassCutTypes = {
        tmEventSetup.InvariantMass: InvariantMassType,
        tmEventSetup.TransverseMass: TransverseMassType,
        tmEventSetup.InvariantMassUpt: InvariantMassUptType,
        tmEventSetup.InvariantMassDeltaR: InvariantMassDeltaRType,
    }

    def __init__(self, lower=0, upper=0, type=InvariantMassType):
        super().__init__(lower, upper)
        self.type = type

    def deduceType(self, condition_handle):
        """Set mass cut type from condition handle."""
        self.type = self.MassCutTypes.get(condition_handle.type, self.InvariantMassType)

    def update(self, cut_handle):
        """Updates limits and enables cut."""
        scale = 10**cut_handle.precision
        assert cut_handle.precision_pt != 0
        scale_pt = 10**cut_handle.precision_pt
        assert cut_handle.precision_math != 0
        scale_math = 10**cut_handle.precision_math
        self.lower = math.floor(cut_handle.minimum.value * scale) / scale * (scale_pt * scale_pt) * scale_math
        self.upper = math.ceil(cut_handle.maximum.value * scale) / scale * (scale_pt * scale_pt) * scale_math
        self.enabled = True

class SliceCutHelper(RangeCutHelper):

    def update(self, cut_handle):
        """Updates limits and enables cut."""
        self.lower = int(cut_handle.minimum.value)
        self.upper = int(cut_handle.maximum.value)
        self.enabled = True

# -----------------------------------------------------------------------------
#  Tests
# -----------------------------------------------------------------------------

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('filename')
    parser.add_argument('-m', action='store_true', help="show modules")
    parser.add_argument('-c', action='store_true', help="show conditions")
    parser.add_argument('-o', action='store_true', help="show objects")
    args = parser.parse_args()

    # Create tray
    resource = os.path.join(os.path.dirname(__file__), '..', 'config', 'resource_default.json')
    tray = algodist.ResourceTray(resource)
    # Load event setup
    eventSetup = tmEventSetup.getTriggerMenu(args.filename)

    # Distribute modules
    collection = algodist.ModuleCollection(eventSetup, tray)
    collection.reverse_sorting = True
    collection.distribute(modules=6)
    # Create template helper
    menu = MenuHelper(collection)

    # Info
    print("*" * 80)
    print("menu.info.name          :", menu.info.name)
    print("menu.info.uuid_menu     :", menu.info.uuid_menu)
    print("menu.info.uuid_firmware :", menu.info.uuid_firmware)
    print("menu.info.scale_set     :", menu.info.scale_set)
    print("menu.info.version       :", menu.info.version)
    print("menu.info.sw_version    :", menu.info.sw_version)
    print("*" * 80)
    print("menu.algorithms|length  :", len(menu.algorithms))
    print("menu.conditions|length  :", len(menu.conditions))
    print("*" * 80)

    assert len(eventSetup.getAlgorithmMapPtr()) == len(menu.algorithms), "algorithm count missmatch"
    assert len(eventSetup.getConditionMapPtr()) == len(menu.conditions), "condition count missmatch"
    assert len(menu.algorithms) == sum([len(module) for module in menu.modules]), "algorithm distribution count missmatch"

    if args.m:
        # Modules
        for module in menu.modules:
            print("module.id                :", module.id)
            print("module.algorithms|length :", len(module.algorithms))
            print("module.conditions|length :", len(module.conditions))
            print("-" * 80)
            print("module.correlationCombinations:")
            for a, b in module.correlationCombinations:
                print(" ", a.type, a.bx, "<>", b.type, b.bx)
            print("-" * 80)
            print("module.correlationCombinationsInvMassDivDr:")
            for a, b in module.correlationCombinationsInvMassDivDr:
                print(" ", a.type, a.bx, "<>", b.type, b.bx)
            print("-" * 80)

            print("module.muonBxCombinations:")
            for a, b in module.muonBxCombinations:
                print(f"  {a} <> {b}")
            print("-" * 80)
            print("module.conversionObjects:")
            for o in module.conversionObjects:
                print(f"  {o.name} (type:{o.type}, threshold:{o.threshold}, bx:{o.bx})")
            print("-" * 80)
            print("module.correlationObjects:")
            for o in module.correlationObjects:
                print(f"  {o.name} (type:{o.type}, threshold:{o.threshold}, bx:{o.bx})")
            print("-" * 80)

            mass_condition_types = (
                tmEventSetup.InvariantMass,
                tmEventSetup.InvariantMass3,
                tmEventSetup.InvariantMassUpt,
                tmEventSetup.InvariantMassDeltaR,
                tmEventSetup.TransverseMass
            )

            if args.c:
                for condition in module.conditions:
                    print("condition.name        :", condition.name)
                    print("condition.vhdl_signal :", condition.vhdl_signal)
                    print("condition.type :", condition.type)
                    if condition.handle.type in mass_condition_types:
                        print("condition.mass.enabled :", condition.mass.enabled)
                        print("condition.mass.lower :", condition.mass.lower)
                        print("condition.mass.upper :", condition.mass.upper)
                        print("condition.mass.type :", condition.mass.type)
                    if args.o:
                        print("condition.objects:")
                        for obj in condition.objects:
                            print("  name      :", obj.name)
                            print("  type      :", obj.type)
                            print("  threshold :", obj.threshold)
                            print("  bx        :", obj.bx)
                    print()
        print("*" * 80)
