"""Handles to wrap and extend event setup container classes.

Classes:

 * CutHandle
 * ObjectHandle
 * ConditionHandle
 * AlgorithmHandle

"""

import tmEventSetup
import tmGrammar

from .constants import BRAMS_TOTAL, SLICELUTS_TOTAL, PROCESSORS_TOTAL

#
# Dictionaries
#

ObjectCollectionSize = {
    tmEventSetup.Egamma: 12,
    tmEventSetup.Jet: 12,
    tmEventSetup.Tau: 12,
    tmEventSetup.Muon: 8,
    tmEventSetup.ETT: 1,
    tmEventSetup.ETTEM: 1,
    tmEventSetup.HTT: 1,
    tmEventSetup.TOWERCOUNT: 1,
    tmEventSetup.ETM: 1,
    tmEventSetup.HTM: 1,
    tmEventSetup.ETMHF: 1,
#    tmEventSetup.HTMHF: 1,
    tmEventSetup.ASYMET: 1,
    tmEventSetup.ASYMHT: 1,
    tmEventSetup.ASYMETHF: 1,
    tmEventSetup.ASYMHTHF: 1,
    tmEventSetup.CENT0: 1,
    tmEventSetup.CENT1: 1,
    tmEventSetup.CENT2: 1,
    tmEventSetup.CENT3: 1,
    tmEventSetup.CENT4: 1,
    tmEventSetup.CENT5: 1,
    tmEventSetup.CENT6: 1,
    tmEventSetup.CENT7: 1,
    tmEventSetup.MBT0HFM: 1,
    tmEventSetup.MBT0HFP: 1,
    tmEventSetup.MBT1HFM: 1,
    tmEventSetup.MBT1HFP: 1,
    tmEventSetup.EXT: 1,
    tmEventSetup.MUS0: 1,
    tmEventSetup.MUS1: 1,
    tmEventSetup.MUSOOT0: 1,
    tmEventSetup.MUSOOT1: 1,
}
"""Dictionary for object collection size (slices)."""

MuonConditionTypes = [
    tmEventSetup.SingleMuon,
    tmEventSetup.DoubleMuon,
    tmEventSetup.TripleMuon,
    tmEventSetup.QuadMuon,
]

CaloConditionTypes = [
    tmEventSetup.SingleEgamma,
    tmEventSetup.DoubleEgamma,
    tmEventSetup.TripleEgamma,
    tmEventSetup.QuadEgamma,
    tmEventSetup.SingleTau,
    tmEventSetup.DoubleTau,
    tmEventSetup.TripleTau,
    tmEventSetup.QuadTau,
    tmEventSetup.SingleJet,
    tmEventSetup.DoubleJet,
    tmEventSetup.TripleJet,
    tmEventSetup.QuadJet,
]

EsumsConditionTypes = [
    tmEventSetup.TotalEt,
    tmEventSetup.TotalEtEM,
    tmEventSetup.TotalHt,
    tmEventSetup.MissingEt,
    tmEventSetup.MissingHt,
    tmEventSetup.MissingEtHF,
#    tmEventSetup.MissingHtHF,
    tmEventSetup.AsymmetryEt,
    tmEventSetup.AsymmetryHt,
    tmEventSetup.AsymmetryEtHF,
    tmEventSetup.AsymmetryHtHF,
]

SignalConditionTypes = [
    tmEventSetup.Centrality0,
    tmEventSetup.Centrality1,
    tmEventSetup.Centrality2,
    tmEventSetup.Centrality3,
    tmEventSetup.Centrality4,
    tmEventSetup.Centrality5,
    tmEventSetup.Centrality6,
    tmEventSetup.Centrality7,
    tmEventSetup.MuonShower0,
    tmEventSetup.MuonShower1,
    tmEventSetup.MuonShowerOOT0,
    tmEventSetup.MuonShowerOOT1,
]

ExternalConditionTypes = [
    tmEventSetup.Externals,
]

MinBiasConditionTypes = [
    tmEventSetup.MinBiasHFM0,
    tmEventSetup.MinBiasHFM1,
    tmEventSetup.MinBiasHFP0,
    tmEventSetup.MinBiasHFP1,
]

TowerCountConditionTypes = [
    tmEventSetup.TowerCount,
]

CorrelationConditionTypes = [
    tmEventSetup.MuonMuonCorrelation,
    tmEventSetup.MuonEsumCorrelation,
    tmEventSetup.CaloMuonCorrelation,
    tmEventSetup.CaloCaloCorrelation,
    tmEventSetup.CaloEsumCorrelation,
    tmEventSetup.InvariantMass,
    tmEventSetup.InvariantMassUpt,
    tmEventSetup.InvariantMassDeltaR,
    tmEventSetup.TransverseMass,
]

Correlation3ConditionTypes = [
    tmEventSetup.InvariantMass3,
]

CorrelationConditionOvRmTypes = [
    tmEventSetup.CaloCaloCorrelationOvRm,
    tmEventSetup.InvariantMassOvRm,
    tmEventSetup.TransverseMassOvRm,
]

CaloConditionOvRmTypes = [
    tmEventSetup.SingleEgammaOvRm,
    tmEventSetup.DoubleEgammaOvRm,
    tmEventSetup.TripleEgammaOvRm,
    tmEventSetup.QuadEgammaOvRm,
    tmEventSetup.SingleTauOvRm,
    tmEventSetup.DoubleTauOvRm,
    tmEventSetup.TripleTauOvRm,
    tmEventSetup.QuadTauOvRm,
    tmEventSetup.SingleJetOvRm,
    tmEventSetup.DoubleJetOvRm,
    tmEventSetup.TripleJetOvRm,
    tmEventSetup.QuadJetOvRm,
]

MuonObjectTypes = [
    tmEventSetup.Muon,
]

CaloObjectTypes = [
    tmEventSetup.Egamma,
    tmEventSetup.Tau,
    tmEventSetup.Jet,
]

EsumsObjectTypes = [
    tmEventSetup.ETT,
    tmEventSetup.ETTEM,
    tmEventSetup.HTT,
    tmEventSetup.ETM,
    tmEventSetup.HTM,
    tmEventSetup.ETMHF,
#    tmEventSetup.HTMHF,
    tmEventSetup.ASYMET,
    tmEventSetup.ASYMHT,
    tmEventSetup.ASYMETHF,
    tmEventSetup.ASYMHTHF,
]
"""List of energy sums object types."""

SignalObjectTypes = [
    tmEventSetup.CENT0,
    tmEventSetup.CENT1,
    tmEventSetup.CENT2,
    tmEventSetup.CENT3,
    tmEventSetup.CENT4,
    tmEventSetup.CENT5,
    tmEventSetup.CENT6,
    tmEventSetup.CENT7,
    tmEventSetup.MUS0,
    tmEventSetup.MUS1,
    tmEventSetup.MUSOOT0,
    tmEventSetup.MUSOOT1,
]
"""List of signal object types."""

ObjectsOrder = [
# objects used in correlation conditions
    tmEventSetup.Egamma,
    tmEventSetup.Jet,
    tmEventSetup.Tau,
    tmEventSetup.Muon,
    tmEventSetup.ETM,
    tmEventSetup.HTM,
    tmEventSetup.ETMHF,
#    tmEventSetup.HTMHF,
# other objects
    tmEventSetup.ETT,
    tmEventSetup.ETTEM,
    tmEventSetup.HTT,
    tmEventSetup.ASYMET,
    tmEventSetup.ASYMHT,
    tmEventSetup.ASYMETHF,
    tmEventSetup.ASYMHTHF,
    tmEventSetup.CENT0,
    tmEventSetup.CENT1,
    tmEventSetup.CENT2,
    tmEventSetup.CENT3,
    tmEventSetup.CENT4,
    tmEventSetup.CENT5,
    tmEventSetup.CENT6,
    tmEventSetup.CENT7,
    tmEventSetup.MUS0,
    tmEventSetup.MUS1,
    tmEventSetup.MUSOOT0,
    tmEventSetup.MUSOOT1,
    tmEventSetup.MBT0HFM,
    tmEventSetup.MBT0HFP,
    tmEventSetup.MBT1HFM,
    tmEventSetup.MBT1HFP,
    tmEventSetup.TOWERCOUNT,
    tmEventSetup.EXT,
    tmEventSetup.Precision,
]
"""Order of object types required by VHDL correlation conditions."""

#
# Functions
#

def filter_first(func, data):
    """Returns first result for filter() or None if not match found."""
    return (list(filter(func, data)) or [None])[0]

#
#  Utility classes
#

class Payload(object):
    """Implements a generic payload represented by multiple attributes.

    >>> payload = Payload(sliceLUTs, processors,brams)
    >>> payload < (payload + payload + payload)
    >>> payload.sliceLUTs, payload.processors, payload.brams
    """

    def __init__(self, brams=0, sliceLUTs=0, processors=0):
        self.brams = int(brams)
        self.sliceLUTs = int(sliceLUTs)
        self.processors = int(processors)

    def _astuple(self):
        """Retrurns tuple of payload attributes ordered by significance (most
        significant last, least first).
        """
        return self.brams, self.sliceLUTs, self.processors

    def _asdict(self):
        return dict(brams=self.brams, sliceLUTs=self.sliceLUTs, processors=self.processors)

    def __add__(self, payload):
        """Multiplicate payloads."""
        brams = self.brams + payload.brams
        sliceLUTs = self.sliceLUTs + payload.sliceLUTs
        processors = self.processors + payload.processors
        return Payload(brams, sliceLUTs, processors)

    def __eq__(self, payload):
        return self._astuple() == payload._astuple()

    def __lt__(self, payload):
        """Compare payloads by list of attributes ordered by significance."""
        return self._astuple() < payload._astuple()

    def __repr__(self):
        bramsPercent = self.brams / BRAMS_TOTAL * 100
        sliceLUTsPercent = self.sliceLUTs / SLICELUTS_TOTAL * 100
        processorsPercent = self.processors / PROCESSORS_TOTAL * 100
        return f"{self.__class__.__name__}(BRAMs={bramsPercent:.2f}%, sliceLUTs={sliceLUTsPercent:.2f}%, DSPs={processorsPercent:.2f}%)"

#
#  Handle classes
#

class Handle(object):
    """Base class for handles."""
    pass

class CutValueHandle(Handle):
    """Handle for cut values (storing c++ instance resulted in corrupt data)."""
    def __init__(self, cut_value):
        assert isinstance(cut_value, tmEventSetup.esCutValue)
        self.index = int(cut_value.index)
        self.value = float(cut_value.value)

class CutHandle(Handle):
    """Represents a cut."""
    def __init__(self, cut):
        assert isinstance(cut, tmEventSetup.esCut)
        self.name = cut.getName()
        self.object_type = cut.getObjectType()
        self.cut_type = cut.getCutType()
        self.minimum = CutValueHandle(cut.getMinimum())
        self.maximum = CutValueHandle(cut.getMaximum())
        self.data = cut.getData()
        self.precision = cut.getPrecision()
        #if self.cut_type == 19:
            #print("===> self.name:", self.name)
            #print("===> self.cut_type:", self.cut_type)
            #print("===> self.precision:", self.precision)
        self.precision_pt = 0
        self.precision_math = 0
        #self.precision_inverse_dr = 0

    def __repr__(self):
        return f"{self.__class__.__name__}(name={self.name})"

class ObjectHandle(Handle):
    """Represents an object."""

    def __init__(self, object_):
        assert isinstance(object_, tmEventSetup.esObject)
        self.name = object_.getName()
        self.type = object_.getType()
        self.comparison_operator = object_.getComparisonOperator()
        self.bx_offset = object_.getBxOffset()
        self.external_signal_name = object_.getExternalSignalName()
        self.external_channel_id = object_.getExternalChannelId()
        self.init_cuts(object_.getCuts())

    def init_cuts(self, cuts):
        """Initialize object cuts from list of esCuts."""
        self.cuts = []
        for cut in cuts:
            self.cuts.append(CutHandle(cut))

    @property
    def slice_size(self):
        """Returns size of object slice used from collection.
        >>> obj.slice_size
        8
        """
        # Check for object slice cut
        cut = filter_first(lambda cut: cut.cut_type == tmEventSetup.Slice, self.cuts)
        if cut:
            return int(cut.maximum.value - cut.minimum.value) + 1
        # Else use default size
        return ObjectCollectionSize[self.type]

    def isMuonObject(self):
        return self.type in MuonObjectTypes

    def isCaloObject(self):
        return self.type in CaloObjectTypes

    def isEsumsObject(self):
        return self.type in EsumsObjectTypes

    def isSignalObject(self):
        return self.type in SignalObjectTypes

    def __repr__(self):
        return f"{self.__class__.__name__}(name={self.name})"

class ConditionHandle(Handle):
    """Represents an condition."""
    def __init__(self, condition, payload):
        assert isinstance(condition, tmEventSetup.esCondition)
        assert isinstance(payload, Payload)
        self.name = condition.getName()
        self.type = condition.getType()
        self.objects = []
        for object_ in condition.getObjects():
            self.objects.append(ObjectHandle(object_))
        # Do not sort object by type for overlap removal conditions. # TODO
        if not (self.isCorrelationConditionOvRm() or
                self.isCaloConditionOvRm()):
           self.objects = self.sortedObjects(self.objects)
        self.cuts = []
        for cut in condition.getCuts():
            self.cuts.append(CutHandle(cut))
        self.payload = Payload(payload.brams, payload.sliceLUTs, payload.processors)

    def sortedObjects(self, objects):
        """Returns list of condition objects sorted by VHDL notation (object order
        required by correlation conditions).
        """
        return sorted(objects, key=lambda object_: ObjectsOrder.index(object_.type))

    @property
    def same_object_types(self):
        """Returns true if all objects are of same type."""
        return len(set([object_.type for object_ in self.objects])) == 1

    @property
    def same_object_bxs(self):
        """Returns true if all objects of condition are of same BX."""
        return len(set([object_.bx_offset for object_ in self.objects])) == 1

    def isMuonCondition(self):
        return self.type in MuonConditionTypes

    def isCaloCondition(self):
        return self.type in CaloConditionTypes

    def isEsumsCondition(self):
        return self.type in EsumsConditionTypes

    def isSignalCondition(self):
        return self.type in SignalConditionTypes

    def isExternalCondition(self):
        return self.type in ExternalConditionTypes

    def isMinBiasCondition(self):
        return self.type in MinBiasConditionTypes

    def isTowerCountCondition(self):
        return self.type in TowerCountConditionTypes

    def isCorrelationCondition(self):
        return self.type in CorrelationConditionTypes

    def isCorrelation3Condition(self):
        return self.type in Correlation3ConditionTypes

    def isCorrelationConditionOvRm(self):
        return self.type in CorrelationConditionOvRmTypes

    def isCaloConditionOvRm(self):
        return self.type in CaloConditionOvRmTypes

    def __repr__(self):
        return f"{self.__class__.__name__}(name={self.name}, payload={self.payload})"

class AlgorithmHandle(Handle):
    """Represents an algorithm."""
    def __init__(self, algorithm, conditions):
        assert isinstance(algorithm, tmEventSetup.esAlgorithm)
        self.module_id = None
        self.module_index = None
        self.index = algorithm.getIndex()
        self.name = algorithm.getName()
        self.conditions = conditions
        self.expression = algorithm.getExpression()
        self.expression_in_condition = algorithm.getExpressionInCondition()
        self.payload = Payload()
        for condition in conditions:
            self.payload += condition.payload

    def __len__(self):
        """Returns count of conditions."""
        return len(self.conditions)

    def __iter__(self):
        """Iterate over conditions."""
        return iter([condition for condition in self.conditions])

    def __repr__(self):
        return f"{self.__class__.__name__}(index={self.index}, name={self.name}, payload={self.payload})"
