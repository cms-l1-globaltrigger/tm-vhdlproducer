"""Smart distribution of algorithms on multiple modules.

Perform a quick distribution using the convenient distribution function.

>>> es = tmEventSetup.getTriggerMenu('sample.xml')
>>> collection = distribute(es, modules=2, config='path/to/spec.json', ratio=0.25)

Full detailed approach:

>>> tray = ResourceTray(config='path/to/spec.json')
>>> collection = ModuleCollection(es, tray)
>>> collection.distribute(modules=2, ratio=0.25)
>>> collection.validate()

Load distribution from JSON file
>>> collection.load(fp)

Dump distribution to JSON file
>>> collection.dump(fp)

"""

import argparse
import json
import logging
import uuid
import sys, os
from collections import namedtuple
from typing import Any, Callable, Dict, Iterable, List, Optional, Tuple

import tmEventSetup
import tmGrammar

from .constants import BRAMS_TOTAL, SLICELUTS_TOTAL, PROCESSORS_TOTAL, NR_CALOS, NR_MUONS

from .handles import Payload
from .handles import ObjectHandle
from .handles import ConditionHandle
from .handles import AlgorithmHandle

MinModules: int = 1
MaxModules: int = 6

ProjectDir: str = os.path.abspath(os.path.join(os.path.dirname(__file__)))
"""Projects root directory."""

DefaultConfigDir: str = os.path.join(ProjectDir, 'config')
"""Default directory for resource configuration files."""

DefaultConfigFile: str = os.path.join(DefaultConfigDir, 'resource_default.json')
"""Default resource configuration file."""

#
# Keys for object types
#

kMuon: str = 'Muon'
kEgamma: str = 'Egamma'
kTau: str = 'Tau'
kJet: str = 'Jet'
kETT: str = 'ETT'
kETTEM: str = 'ETTEM'
kHTT: str = 'HTT'
kTOWERCOUNT: str = 'TOWERCOUNT'
kETM: str = 'ETM'
kHTM: str = 'HTM'
kETMHF: str = 'ETMHF'
#kHTMHF: str = 'HTMHF'
kASYMET: str = 'ASYMET'
kASYMHT: str = 'ASYMHT'
kASYMETHF: str = 'ASYMETHF'
kASYMHTHF: str = 'ASYMHTHF'
kCENT0: str = 'CENT0'
kCENT1: str = 'CENT1'
kCENT2: str = 'CENT2'
kCENT3: str = 'CENT3'
kCENT4: str = 'CENT4'
kCENT5: str = 'CENT5'
kCENT6: str = 'CENT6'
kCENT7: str = 'CENT7'
kMUS0: str = 'MUS0'
kMUS1: str = 'MUS1'
kMUS2: str = 'MUS2'
kMUSOOT0: str = 'MUSOOT0'
kMUSOOT1: str = 'MUSOOT1'
kMBT0HFM: str = 'MBT0HFM'
kMBT0HFP: str = 'MBT0HFP'
kMBT1HFM: str = 'MBT1HFM'
kMBT1HFP: str = 'MBT1HFP'
kADT: str = 'ADT'
kZDCP: str = 'ZDCP'
kZDCM: str = 'ZDCM'
kAxol1tl: str = 'Axol1tl'
kTopological: str = 'Topological'
kCicada: str = 'Cicada'
kEXT: str = 'EXT'
kPrecision: str = 'Precision'

#
# Keys for condition types
#

kSingleMuon: str = 'SingleMuon'
kDoubleMuon: str = 'DoubleMuon'
kTripleMuon: str = 'TripleMuon'
kQuadMuon: str = 'QuadMuon'
kSingleEgamma: str = 'SingleEgamma'
kDoubleEgamma: str = 'DoubleEgamma'
kTripleEgamma: str = 'TripleEgamma'
kQuadEgamma: str = 'QuadEgamma'
kSingleTau: str = 'SingleTau'
kDoubleTau: str = 'DoubleTau'
kTripleTau: str = 'TripleTau'
kQuadTau: str = 'QuadTau'
kSingleJet: str = 'SingleJet'
kDoubleJet: str = 'DoubleJet'
kTripleJet: str = 'TripleJet'
kQuadJet: str = 'QuadJet'
kTotalEt: str = 'TotalEt'
kTotalEtEM: str = 'TotalEtEM'
kTotalHt: str = 'TotalHt'
kTowerCount: str = 'TowerCount'
kMissingEt: str = 'MissingEt'
kMissingHt: str = 'MissingHt'
kMissingEtHF: str = 'MissingEtHF'
#kMissingHtHF: str = 'MissingHtHF'
kAsymmetryEt: str = 'AsymmetryEt'
kAsymmetryHt: str = 'AsymmetryHt'
kAsymmetryEtHF: str = 'AsymmetryEtHF'
kAsymmetryHtHF: str = 'AsymmetryHtHF'
kCentrality0: str = 'Centrality0'
kCentrality1: str = 'Centrality1'
kCentrality2: str = 'Centrality2'
kCentrality3: str = 'Centrality3'
kCentrality4: str = 'Centrality4'
kCentrality5: str = 'Centrality5'
kCentrality6: str = 'Centrality6'
kCentrality7: str = 'Centrality7'
kMuonShower0: str = 'MuonShower0'
kMuonShower1: str = 'MuonShower1'
kMuonShower2: str = 'MuonShower2'
kMuonShowerOutOfTime0: str = 'MuonShowerOutOfTime0'
kMuonShowerOutOfTime1: str = 'MuonShowerOutOfTime1'
kMinBiasHFM0: str = 'MinBiasHFM0'
kMinBiasHFM1: str = 'MinBiasHFM1'
kMinBiasHFP0: str = 'MinBiasHFP0'
kMinBiasHFP1: str = 'MinBiasHFP1'
kZDCPlus: str = 'ZDCPlus'
kZDCMinus: str = 'ZDCMinus'
kExternals: str = 'Externals'
kMuonMuonCorrelation: str = 'MuonMuonCorrelation'
kMuonEsumCorrelation: str = 'MuonEsumCorrelation'
kCaloMuonCorrelation: str = 'CaloMuonCorrelation'
kCaloCaloCorrelation: str = 'CaloCaloCorrelation'
kCaloEsumCorrelation: str = 'CaloEsumCorrelation'
kInvariantMass: str = 'InvariantMass'
kInvariantMass3: str = 'InvariantMass3'
kInvariantMassUpt: str = 'InvariantMassUpt'
kInvariantMassDeltaR: str = 'InvariantMassDeltaR'
kTransverseMass: str = 'TransverseMass'
kCaloCaloCorrelationOvRm: str = 'CaloCaloCorrelationOvRm'
kInvariantMassOvRm: str = 'InvariantMassOvRm'
kTransverseMassOvRm: str = 'TransverseMassOvRm'
kSingleEgammaOvRm: str = 'SingleEgammaOvRm'
kDoubleEgammaOvRm: str = 'DoubleEgammaOvRm'
kTripleEgammaOvRm: str = 'TripleEgammaOvRm'
kQuadEgammaOvRm: str = 'QuadEgammaOvRm'
kSingleTauOvRm: str = 'SingleTauOvRm'
kDoubleTauOvRm: str = 'DoubleTauOvRm'
kTripleTauOvRm: str = 'TripleTauOvRm'
kQuadTauOvRm: str = 'QuadTauOvRm'
kSingleJetOvRm: str = 'SingleJetOvRm'
kDoubleJetOvRm: str = 'DoubleJetOvRm'
kTripleJetOvRm: str = 'TripleJetOvRm'
kQuadJetOvRm: str = 'QuadJetOvRm'
kAnomalyDetectionTrigger: str = 'AnomalyDetectionTrigger'
kAxol1tlTrigger: str = 'Axol1tlTrigger'
kTopologicalTrigger: str = 'TopologicalTrigger'
kCicadaTrigger: str = 'CicadaTrigger'
#
# Keys for cut types
#

kThreshold: str = 'Threshold'
kEta: str = 'Eta'
kIndex: str = 'Index'
kPhi: str = 'Phi'
kUnconstrainedPt: str = 'UnconstrainedPt'
kImpactParameter: str = 'ImpactParameter'
kCharge: str = 'Charge'
kQuality: str = 'Quality'
kIsolation: str = 'Isolation'
kDisplaced: str = 'Displaced'
kDeltaEta: str = 'DeltaEta'
kDeltaPhi: str = 'DeltaPhi'
kDeltaR: str = 'DeltaR'
kMass: str = 'Mass'
kMassUpt: str = 'MassUpt'
kMassDeltaR: str = 'MassDeltaR'
kTwoBodyPt: str = 'TwoBodyPt'
kSlice: str = 'Slice'
kChargeCorrelation: str = 'ChargeCorrelation'
kCount: str = 'Count'
kOvRmDeltaEta: str = 'OvRmDeltaEta'
kOvRmDeltaPhi: str = 'OvRmDeltaPhi'
kOvRmDeltaR: str = 'OvRmDeltaR'
kAnomalyScore: str = 'AnomalyScore'
kScore: str = 'Score'
kCicadaScore: str = 'CicadaScore'
kModel: str = 'Model'

#
# Operators
#

Operators: List[str] = [
    tmGrammar.AND,
    tmGrammar.OR,
    tmGrammar.XOR,
    tmGrammar.NOT,
]
"""List of valid algorithm expression operators."""

#
# Dictionaries
#

CutTypeKey: Dict[int, str] = {
    tmEventSetup.Threshold: kThreshold,
    tmEventSetup.Eta: kEta,
    tmEventSetup.Index: kIndex,
    tmEventSetup.Phi: kPhi,
    tmEventSetup.UnconstrainedPt: kUnconstrainedPt,
    tmEventSetup.ImpactParameter: kImpactParameter,
    tmEventSetup.Charge: kCharge,
    tmEventSetup.Quality: kQuality,
    tmEventSetup.Isolation: kIsolation,
    tmEventSetup.Displaced: kDisplaced,
    tmEventSetup.DeltaEta: kDeltaEta,
    tmEventSetup.DeltaPhi: kDeltaPhi,
    tmEventSetup.DeltaR: kDeltaR,
    tmEventSetup.Mass: kMass,
    tmEventSetup.MassUpt: kMassUpt,
    tmEventSetup.MassDeltaR: kMassDeltaR,
    tmEventSetup.TwoBodyPt: kTwoBodyPt,
    tmEventSetup.Slice: kSlice,
    tmEventSetup.ChargeCorrelation: kChargeCorrelation,
    tmEventSetup.Count: kCount,
    tmEventSetup.OvRmDeltaEta: kOvRmDeltaEta,
    tmEventSetup.OvRmDeltaPhi: kOvRmDeltaPhi,
    tmEventSetup.OvRmDeltaR: kOvRmDeltaR,
    tmEventSetup.AnomalyScore: kAnomalyScore,
    tmEventSetup.Score: kScore,
    tmEventSetup.Model: kModel,
    tmEventSetup.CicadaScore: kCicadaScore,
}
"""Dictionary for cut type enumerations."""

ObjectTypeKey: Dict[int, str] = {
    tmEventSetup.Muon: kMuon,
    tmEventSetup.Egamma: kEgamma,
    tmEventSetup.Tau: kTau,
    tmEventSetup.Jet: kJet,
    tmEventSetup.ETT: kETT,
    tmEventSetup.ETTEM: kETTEM,
    tmEventSetup.HTT: kHTT,
    tmEventSetup.TOWERCOUNT: kTOWERCOUNT,
    tmEventSetup.ETM: kETM,
    tmEventSetup.HTM: kHTM,
    tmEventSetup.ETMHF: kETMHF,
#    tmEventSetup.HTMHF: kHTMHF,
    tmEventSetup.ASYMET: kASYMET,
    tmEventSetup.ASYMHT: kASYMHT,
    tmEventSetup.ASYMETHF: kASYMETHF,
    tmEventSetup.ASYMHTHF: kASYMHTHF,
    tmEventSetup.CENT0: kCENT0,
    tmEventSetup.CENT1: kCENT1,
    tmEventSetup.CENT2: kCENT2,
    tmEventSetup.CENT3: kCENT3,
    tmEventSetup.CENT4: kCENT4,
    tmEventSetup.CENT5: kCENT5,
    tmEventSetup.CENT6: kCENT6,
    tmEventSetup.CENT7: kCENT7,
    tmEventSetup.MUS0: kMUS0,
    tmEventSetup.MUS1: kMUS1,
    tmEventSetup.MUS2: kMUS2,
    tmEventSetup.MUSOOT0: kMUSOOT0,
    tmEventSetup.MUSOOT1: kMUSOOT1,
    tmEventSetup.MBT0HFM: kMBT0HFM,
    tmEventSetup.MBT0HFP: kMBT0HFP,
    tmEventSetup.MBT1HFM: kMBT1HFM,
    tmEventSetup.MBT1HFP: kMBT1HFP,
    tmEventSetup.ADT: kADT,
    tmEventSetup.ZDCP: kZDCP,
    tmEventSetup.ZDCM: kZDCM,
    tmEventSetup.Axol1tl: kAxol1tl,
    tmEventSetup.Topological: kTopological,
    tmEventSetup.Cicada: kCicada,
    tmEventSetup.EXT: kEXT,
    tmEventSetup.Precision: kPrecision,
}
"""Dictionary for object type enumerations."""

ObjectGrammarKey: Dict[int, str] = {
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
    tmEventSetup.MUS0: tmGrammar.MUS0,
    tmEventSetup.MUS1: tmGrammar.MUS1,
    tmEventSetup.MUS2: tmGrammar.MUS2,
    tmEventSetup.MUSOOT0: tmGrammar.MUSOOT0,
    tmEventSetup.MUSOOT1: tmGrammar.MUSOOT1,
    tmEventSetup.ZDCP: tmGrammar.ZDCP,
    tmEventSetup.ZDCM: tmGrammar.ZDCM,
    tmEventSetup.EXT: tmGrammar.EXT,
    tmEventSetup.MBT0HFP: tmGrammar.MBT0HFP,
    tmEventSetup.MBT1HFP: tmGrammar.MBT1HFP,
    tmEventSetup.MBT0HFM: tmGrammar.MBT0HFM,
    tmEventSetup.MBT1HFM: tmGrammar.MBT1HFM,
    tmEventSetup.TOWERCOUNT: tmGrammar.TOWERCOUNT,
    tmEventSetup.ADT: tmGrammar.ADT,
    tmEventSetup.Axol1tl: tmGrammar.AXO,
    tmEventSetup.Topological: tmGrammar.TOPO,
    tmEventSetup.Cicada: tmGrammar.CICADA,
}
"""Dictionary for object grammar type enumerations."""

ObjectCategoryKey: Dict[int, str] = {
    tmEventSetup.Muon: "muon",
    tmEventSetup.Egamma: "calo",
    tmEventSetup.Tau: "calo",
    tmEventSetup.Jet: "calo",
    tmEventSetup.ETT: "esums",
    tmEventSetup.HTT: "esums",
    tmEventSetup.ETM: "esums",
    tmEventSetup.HTM: "esums",
    tmEventSetup.ETTEM: "esums",
    tmEventSetup.ETMHF: "esums",
}
"""Mapping object types to object category keys (for deltas)."""

ConditionTypeKey: Dict[int, str] = {
    tmEventSetup.SingleMuon: kSingleMuon,
    tmEventSetup.DoubleMuon: kDoubleMuon,
    tmEventSetup.TripleMuon: kTripleMuon,
    tmEventSetup.QuadMuon: kQuadMuon,
    tmEventSetup.SingleEgamma: kSingleEgamma,
    tmEventSetup.DoubleEgamma: kDoubleEgamma,
    tmEventSetup.TripleEgamma: kTripleEgamma,
    tmEventSetup.QuadEgamma: kQuadEgamma,
    tmEventSetup.SingleTau: kSingleTau,
    tmEventSetup.DoubleTau: kDoubleTau,
    tmEventSetup.TripleTau: kTripleTau,
    tmEventSetup.QuadTau: kQuadTau,
    tmEventSetup.SingleJet: kSingleJet,
    tmEventSetup.DoubleJet: kDoubleJet,
    tmEventSetup.TripleJet: kTripleJet,
    tmEventSetup.QuadJet: kQuadJet,
    tmEventSetup.TotalEt: kTotalEt,
    tmEventSetup.TotalEtEM: kTotalEtEM,
    tmEventSetup.TotalHt: kTotalHt,
    tmEventSetup.TowerCount: kTowerCount,
    tmEventSetup.MissingEt: kMissingEt,
    tmEventSetup.MissingHt: kMissingHt,
    tmEventSetup.MissingEtHF: kMissingEtHF,
#    tmEventSetup.MissingHtHF: kMissingHtHF,
    tmEventSetup.AsymmetryEt: kAsymmetryEt,
    tmEventSetup.AsymmetryHt: kAsymmetryHt,
    tmEventSetup.AsymmetryEtHF: kAsymmetryEtHF,
    tmEventSetup.AsymmetryHtHF: kAsymmetryHtHF,
    tmEventSetup.Centrality0: kCentrality0,
    tmEventSetup.Centrality1: kCentrality1,
    tmEventSetup.Centrality2: kCentrality2,
    tmEventSetup.Centrality3: kCentrality3,
    tmEventSetup.Centrality4: kCentrality4,
    tmEventSetup.Centrality5: kCentrality5,
    tmEventSetup.Centrality6: kCentrality6,
    tmEventSetup.Centrality7: kCentrality7,
    tmEventSetup.MuonShower0: kMuonShower0,
    tmEventSetup.MuonShower1: kMuonShower1,
    tmEventSetup.MuonShower2: kMuonShower2,
    tmEventSetup.MuonShowerOutOfTime0: kMuonShowerOutOfTime0,
    tmEventSetup.MuonShowerOutOfTime1: kMuonShowerOutOfTime1,
    tmEventSetup.MinBiasHFM0: kMinBiasHFM0,
    tmEventSetup.MinBiasHFM1: kMinBiasHFM1,
    tmEventSetup.MinBiasHFP0: kMinBiasHFP0,
    tmEventSetup.MinBiasHFP1: kMinBiasHFP1,
    tmEventSetup.ZDCPlus: kZDCPlus,
    tmEventSetup.ZDCMinus: kZDCMinus,
    tmEventSetup.Externals: kExternals,
    tmEventSetup.MuonMuonCorrelation: kMuonMuonCorrelation,
    tmEventSetup.MuonEsumCorrelation: kMuonEsumCorrelation,
    tmEventSetup.CaloMuonCorrelation: kCaloMuonCorrelation,
    tmEventSetup.CaloCaloCorrelation: kCaloCaloCorrelation,
    tmEventSetup.CaloEsumCorrelation: kCaloEsumCorrelation,
    tmEventSetup.InvariantMass: kInvariantMass,
    tmEventSetup.InvariantMass3: kInvariantMass3,
    tmEventSetup.InvariantMassUpt: kInvariantMassUpt,
    tmEventSetup.InvariantMassDeltaR: kInvariantMassDeltaR,
    tmEventSetup.TransverseMass: kTransverseMass,
    tmEventSetup.CaloCaloCorrelationOvRm: kCaloCaloCorrelationOvRm,
    tmEventSetup.InvariantMassOvRm: kInvariantMassOvRm,
    tmEventSetup.TransverseMassOvRm: kTransverseMassOvRm,
    tmEventSetup.SingleEgammaOvRm: kSingleEgammaOvRm,
    tmEventSetup.DoubleEgammaOvRm: kDoubleEgammaOvRm,
    tmEventSetup.TripleEgammaOvRm: kTripleEgammaOvRm,
    tmEventSetup.QuadEgammaOvRm: kQuadEgammaOvRm,
    tmEventSetup.SingleTauOvRm: kSingleTauOvRm,
    tmEventSetup.DoubleTauOvRm: kDoubleTauOvRm,
    tmEventSetup.TripleTauOvRm: kTripleTauOvRm,
    tmEventSetup.QuadTauOvRm: kQuadTauOvRm,
    tmEventSetup.SingleJetOvRm: kSingleJetOvRm,
    tmEventSetup.DoubleJetOvRm: kDoubleJetOvRm,
    tmEventSetup.TripleJetOvRm: kTripleJetOvRm,
    tmEventSetup.QuadJetOvRm: kQuadJetOvRm,
    tmEventSetup.AnomalyDetectionTrigger: kAnomalyDetectionTrigger,
    tmEventSetup.Axol1tlTrigger: kAxol1tlTrigger,
    tmEventSetup.CicadaTrigger: kCicadaTrigger,
    tmEventSetup.TopologicalTrigger: kTopologicalTrigger,
}
"""Dictionary for condition type enumerations."""

#
# Functions
#

def constraint_t(value: str) -> Tuple[str, List[int]]:
    tokens = value.split(':')
    try:
        return tokens[0], parse_range(tokens[1])
    except IndexError:
        pass
    raise ValueError(value)

def filter_first(func: Callable, data: Iterable[Any]) -> Optional[Any]:
    """Returns first result for filter() or None if not match found."""
    return (list(filter(func, data)) or [None])[0]

def get_condition_names(algorithm: tmEventSetup.esAlgorithm) -> List[str]:
    """Returns list of condition names of an algorithm (from RPN vector)."""
    return [label for label in algorithm.getRpnVector() if label not in Operators]

def short_name(name: str, length: int) -> str:
    """Shortens long names, if longer then length replaces last characters by ..."""
    if len(name) > length:
        return f"{name[:length-3]}..."
    return name[:length]

def expand_range(expr: str) -> List[int]:
    """Parse and resolves numeric ranges.
    >>> parse_range("3")
    [3]
    >>> parse_range("4-7")
    [4, 5, 6, 7]
    """
    tokens = expr.split('-')
    if len(tokens) == 2:
        return [int(tokens[0]), int(tokens[1])]
    if len(tokens) == 1:
        return [int(tokens[0])]
    raise ValueError(f"invalid range '{expr}'")

def parse_range(expr: str) -> List[int]:
    """Parse and resolves numeric ranges.
    >>> parse_range("2,4-7,5,9")
    [2, 4, 5, 6, 7, 9]
    """
    result = set()
    for token in expr.split(','):
        result.update(expand_range(token))
    return list(result)

def obj_type_to_str(object_type: int) -> Optional[str]:
    """Converts object type to string representation."""
    if object_type not in ObjectTypeKey:
        raise ValueError(f"invalid object type: {object_type!r}")
    return ObjectTypeKey[object_type]

def object_category(object_type: int) -> str:
    """Converts object type to object category representation."""
    if object_type not in ObjectCategoryKey:
        raise ValueError(f"invalid object type: {object_type!r}")
    return ObjectCategoryKey[object_type]

#
# Classes
#

class VersionError(ValueError):
    pass

class ResourceOverflowError(RuntimeError):
    """Custom exception class for reosurce overflow errors."""
    pass

class ResourceTray:
    """Scale tray for calculating condition and algorithm payloads. It loads
    payload and threshold specifications from a JSON file.

    >>> tray = ResourceTray('algo_dist.json')
    >>> tray.measure(condition)
    """

    Version = 3

    # Instances used in resource configuration
    kMuonCondition = 'MuonCondition'
    kCaloCondition = 'CaloCondition'
    kCaloConditionOvRm = 'CaloConditionOvRm'
    kCorrelationCondition = 'CorrelationCondition'
    kCorrelation3Condition = 'Correlation3Condition'
    kCorrelationConditionOvRm = 'CorrelationConditionOvRm'

    def __init__(self, filename):
        """Attribute *filename* is a filename of an JSON payload configuration file."""
        with open(filename) as fp:
            data = json.load(fp, object_hook=self._object_hook)
        if data.version != type(self).Version:
            raise VersionError(f"invalid JSON file version: {data.version}")
        self.resources = data.resources
        self.filename = filename

    def _object_hook(self, d):
        """Convert a dict into a namedtuple, used to convert JSON input.
        http://stackoverflow.com/questions/35898270/trying-to-make-a-dict-behave-like-a-clean-class-method-structure
        """
        for k, v in d.items():
            if isinstance(v, dict):
                d[k] = self._object_hook(v)
        return namedtuple('resource', d.keys())(**d)

    def map_instance(self, key: str) -> str:
        """Returns mapped condition instance type for *key*."""
        return self.resources.mapping.instances._asdict()[key]

    def map_object(self, key: str) -> str:
        """Returns mapped condition object type for *key*.
        >>> tray.map_object("Egamma")
        'calo'
        """
        return self.resources.mapping.objects._asdict()[key]

    def map_objects(self, keys: List[str]) -> List[str]:
        """Returns mapped condition object types for *keys*.
        >>> tray.map_objects(["Jet", "Tau"])
        ['calo', 'calo']
        """
        return [self.map_object(key) for key in keys]

    def map_cut(self, key: str) -> str:
        """Returns mapped condition cut type for *key*.
        >>> tray.map_cut("ORMDETA")
        'deta'
        """
        return self.resources.mapping.cuts._asdict()[key]

    def floor(self) -> Payload:
        """Returns minimum resource consumption payload.
        >>> tray.floor()
        """
        floor = self.resources.floor
        return Payload(brams=floor.brams, sliceLUTs=floor.sliceLUTs, processors=floor.processors)

    def ceiling(self) -> Payload:
        """Returns maximum payload threshold for resource consumption.
        >>> tray.ceiling()
        """
        ceiling = self.resources.ceiling
        return Payload(brams=ceiling.brams, sliceLUTs=ceiling.sliceLUTs, processors=ceiling.processors)

    def frame(self) -> Payload:
        """Returns resource consumption payload for "frame".
        >>> tray.frame()
        """
        frame = self.resources.frame
        return Payload(brams=frame.brams, sliceLUTs=frame.sliceLUTs, processors=frame.processors)

    def fdl_algo_slice(self) -> Payload:
        """Returns resource consumption payload for one FDL algo slice.
        >>> tray.fdl_algo_slice()
        """
        fdl_algo_slice = self.resources.fdl.algo_slice
        return Payload(brams=fdl_algo_slice.brams, sliceLUTs=fdl_algo_slice.sliceLUTs, processors=fdl_algo_slice.processors)

    def fdl_algo_floor(self) -> Payload:
        """Returns resource consumption payload for FDL "floor".
        >>> tray.fdl_algo_floor()
        """
        fdl_algo_floor = self.resources.fdl.floor
        return Payload(brams=fdl_algo_floor.brams, sliceLUTs=fdl_algo_floor.sliceLUTs, processors=fdl_algo_floor.processors)

    def calc_deta_integer(self) -> Payload:
        """Returns resource consumption payload for one unit of calc_deta_integer calculation.
        >>> tray.calc_deta_integer()
        """
        calc_deta_integer = self.resources.calc_deta_integer
        return Payload(brams=calc_deta_integer.brams, sliceLUTs=calc_deta_integer.sliceLUTs, processors=calc_deta_integer.processors)

    def calc_dphi_integer(self) -> Payload:
        """Returns resource consumption payload for one unit of calc_dphi_integer calculation.
        >>> tray.calc_dphi_integer()
        """
        calc_dphi_integer = self.resources.calc_dphi_integer
        return Payload(brams=calc_dphi_integer.brams, sliceLUTs=calc_dphi_integer.sliceLUTs, processors=calc_dphi_integer.processors)

    def calc_cut_deta(self, obj0, obj1) -> Payload:
        """Returns resource consumption payload for one unit of calc_cut_deta calculation.
        >>> tray.calc_cut_deta()
        """
        brams = self.resources.calc_cut_deta._asdict()[obj0]._asdict()[obj1].brams
        sliceLUTs = self.resources.calc_cut_deta._asdict()[obj0]._asdict()[obj1].sliceLUTs
        processors = self.resources.calc_cut_deta._asdict()[obj0]._asdict()[obj1].processors
        return Payload(brams, sliceLUTs, processors)

    def calc_cut_dphi(self, obj0, obj1) -> Payload:
        """Returns resource consumption payload for one unit of calc_cut_dphi calculation.
        >>> tray.calc_cut_dphi()
        """
        brams = self.resources.calc_cut_dphi._asdict()[obj0]._asdict()[obj1].brams
        sliceLUTs = self.resources.calc_cut_dphi._asdict()[obj0]._asdict()[obj1].sliceLUTs
        processors = self.resources.calc_cut_dphi._asdict()[obj0]._asdict()[obj1].processors
        return Payload(brams, sliceLUTs, processors)

    def calc_cut_dr(self, obj0, obj1) -> Payload:
        """Returns resource consumption payload for one unit of calc_cut_dr calculation.
        >>> tray.calc_cut_dr()
        """
        brams = self.resources.calc_cut_dr._asdict()[obj0]._asdict()[obj1].brams
        sliceLUTs = self.resources.calc_cut_dr._asdict()[obj0]._asdict()[obj1].sliceLUTs
        processors = self.resources.calc_cut_dr._asdict()[obj0]._asdict()[obj1].processors
        return Payload(brams, sliceLUTs, processors)

    def calc_cut_mass(self, obj0, obj1) -> Payload:
        """Returns resource consumption payload for one unit of calc_cut_mass calculation for mass.
        >>> tray.calc_cut_mass()
        """
        brams = self.resources.calc_cut_mass._asdict()[obj0]._asdict()[obj1].brams
        sliceLUTs = self.resources.calc_cut_mass._asdict()[obj0]._asdict()[obj1].sliceLUTs
        processors = self.resources.calc_cut_mass._asdict()[obj0]._asdict()[obj1].processors
        return Payload(brams, sliceLUTs, processors)

    def find_object_cut(self, object):
        """Returns object cut resource namedtuple for *key* or None if not found."""
        assert isinstance(object, ObjectHandle)
        def compare(instance):
            return instance.type == self.map_object(ObjectTypeKey[object.type])
        return filter_first(compare, self.resources.object_cuts)

    def find_instance(self, condition):
        """Returns instance resource namedtuple for *key* or None if not found."""
        assert isinstance(condition, ConditionHandle)
        instance_map = self.resources.mapping.instances._asdict()
        def compare(instance):
            return instance.type == self.map_instance(ConditionTypeKey[condition.type])
        return filter_first(compare, self.resources.instances)

    def calc_factor(self, condition):
        """Returns calculated multiplication factor for base resources.

        >>> tray.calc_factor(condition)
        1.234
        """
        assert isinstance(condition, ConditionHandle)
        # condition type dependent factor calculation (see also config/README.md)
        objects = condition.objects
        n_requirements = len(objects)
        n_objects = objects[0].slice_size
        n_objects_ovrm = objects[-1].slice_size
        object_keys = [ObjectTypeKey[object_.type] for object_ in condition.objects]
        mapped_objects = self.map_objects(object_keys)
        # instance
        instance = self.map_instance(ConditionTypeKey[condition.type])
        # select
        if instance in (self.kMuonCondition, self.kCaloCondition, self.kCaloConditionOvRm):
            return n_objects * n_requirements
        elif instance == self.kCorrelationCondition:
            if condition.same_object_types and condition.same_object_bxs:
                return n_objects * (n_objects - 1) * 0.5
            else:
                n_objects_1 = objects[0].slice_size
                n_objects_2 = objects[1].slice_size
                return n_objects_1 * n_objects_2
        elif instance == self.kCorrelation3Condition:
            if mapped_objects == ['calo', 'calo', 'calo']:
                return n_objects * (n_objects - 1) * (n_objects - 2) / 6
            elif mapped_objects == ['muon', 'muon', 'muon']:
                return n_objects * (n_objects - 1) * (n_objects - 2) / 6
            raise RuntimeError(f"missing mapped objects for '{instance}': {mapped_objects}")
        elif instance == self.kCorrelationConditionOvRm:
            if mapped_objects == ['calo', 'calo', 'calo']:
                return n_objects * (n_objects - 1) * 0.5
            elif mapped_objects == ['calo', 'calo']:
                return n_objects * n_objects_ovrm
            raise RuntimeError(f"missing mapped objects for '{instance}': {mapped_objects}")
        return 1.

    def calc_cut_factor(self, condition, cut: str):
        """Returns calculated multiplication factor for cut resources.
        Argument *cut* must be an event setup cut name (not a mapped one).

        >>> tray.calc_cut_factor(condition, "OvRmDeltaR")
        1.234
        """
        assert isinstance(condition, ConditionHandle)
        assert isinstance(cut, str)
        # condition type dependent factor calculation (see also config/README.md)
        mapped_cut = self.map_cut(cut)
        objects = condition.objects
        n_requirements = len(objects)
        n_objects = objects[0].slice_size
        n_objects_ovrm = objects[-1].slice_size
        object_keys = [ObjectTypeKey[object_.type] for object_ in condition.objects]
        mapped_objects = self.map_objects(object_keys)
        # instance
        instance = self.map_instance(ConditionTypeKey[condition.type])
        # select
        if instance in (self.kMuonCondition, self.kCaloCondition):
            if mapped_cut == 'tbpt':
                return n_objects * (n_objects - 1) * 0.5
        elif instance  == self.kCaloConditionOvRm:
            if mapped_cut == 'tbpt':
                return n_objects * (n_objects - 1) * 0.5
            elif mapped_cut in ('deta', 'dphi', 'dr'):
                return n_objects * n_objects_ovrm
        elif instance == self.kCorrelationCondition:
            if condition.same_object_types and condition.same_object_bxs:
                return n_objects * (n_objects - 1) * 0.5
            else:
                n_objects_1 = objects[0].slice_size
                n_objects_2 = objects[1].slice_size
                return n_objects_1 * n_objects_2
        elif instance == self.kCorrelation3Condition:
            if mapped_objects == ['calo', 'calo', 'calo']:
                return n_objects * (n_objects - 1) * (n_objects - 2) / 6
                #return n_objects * (n_objects - 1) * 0.5
            elif mapped_objects == ['muon', 'muon', 'muon']:
                return n_objects * (n_objects - 1) * (n_objects - 2) / 6
                #return n_objects * (n_objects - 1) * 0.5
            raise RuntimeError(f"missing mapped objects for '{instance}': {mapped_objects}")
        elif instance == self.kCorrelationConditionOvRm:
            if mapped_objects == ['calo', 'calo', 'calo']:
                if cut in (kOvRmDeltaEta, kOvRmDeltaPhi, kOvRmDeltaR):
                    return n_objects * n_objects_ovrm
                else:
                    return n_objects * (n_objects - 1) * 0.5
            elif mapped_objects == ['calo', 'calo']:
                return n_objects * n_objects_ovrm
            raise RuntimeError(f"missing mapped objects for '{instance}': {mapped_objects}")
        return 1.

    def measure(self, condition):
        """Calculates the payload of a condition by its type and objects.
        Conditions can be of type `tmEventSetup.esCondition` or `ConditionHandle`.
        >>> tray.measure(condition)
        Payload(sliceLUTs=0.42%, processors=0.00%)
        """
        if isinstance(condition, tmEventSetup.esCondition):
            condition = ConditionHandle(condition, Payload()) # cast to handle with empty payload

        # Pick resource instance
        instance = self.find_instance(condition)
        if not instance:
            condition_type = ConditionTypeKey[condition.type]
            objects_types = [ObjectTypeKey[object_.type] for object_ in condition.objects]
            message = f"Missing configuration for condition of type '{condition_type}' with " \
                      f"objects {objects_types} in file '{self.filename}'."
            raise RuntimeError(message)

        # Pick object configuration
        objects_types = [ObjectTypeKey[object_.type] for object_ in condition.objects]
        if objects_types[0] == 'EXT':
            for object in condition.objects:
                mapped_objects = self.map_objects(objects_types)
                instance_objects = filter_first(lambda item: item.types == mapped_objects, instance.objects)
        else:
            mapped_objects = self.map_objects(objects_types)
            instance_objects = filter_first(lambda item: item.types == mapped_objects, instance.objects)

        if not instance_objects:
            condition_type = ConditionTypeKey[condition.type]
            message = f"Missing configuration for condition of type '{condition_type}' with " \
                      f"objects {objects_types} in file '{self.filename}'."
            raise RuntimeError(message)

        # calculate object cuts payload
        brams = instance_objects.brams
        sliceLUTs = instance_objects.sliceLUTs
        processors = instance_objects.processors
        for object in condition.objects:
            object_key = self.map_object(ObjectTypeKey[object.type])
            for cut in object.cuts:
                cut_key = CutTypeKey[cut.cut_type]
                object_cuts = self.resources.object_cuts._asdict().get(object_key)
                if object_cuts is not None:
                    object_cut = object_cuts._asdict().get(cut_key)
                    if object_cut is not None:
                        brams += object_cut.brams * object.slice_size
                        sliceLUTs += object_cut.sliceLUTs * object.slice_size
                        processors += object_cut.processors * object.slice_size
                        # add optional cut data dependent resources
                        data_cut = object_cut._asdict().get("data")
                        if data_cut is not None:
                            # TODO extend with regex in future?
                            if cut.data not in data_cut._asdict():
                                raise RuntimeError(f"missing cut data entry for: {cut.data!r}")
                            for data_key, cut_data in data_cut._asdict().items():
                                if cut.data == data_key:
                                    brams += cut_data.brams * object.slice_size
                                    sliceLUTs += cut_data.sliceLUTs * object.slice_size
                                    processors += cut_data.processors * object.slice_size
                    else:
                        logging.warning(f"no object cut entry for cut type: {cut_key}")
                else:
                    logging.warning(f"no object cut entry for object type: {object_key}")
        payload = Payload(brams, sliceLUTs, processors)

        # calculate correlation cuts payload
        for cut in condition.cuts:
            name = CutTypeKey[cut.cut_type]
            try: # only for cuts listed in configuration... might be error prone
                mapped_cut = self.map_cut(name)
            except KeyError as e:
                logging.warning("skipping cut '%s' (not defined in resource config)", name)
            else:
                result = filter_first(lambda cut: cut.type == mapped_cut, instance_objects.cuts)
                if result:
                    factor = self.calc_cut_factor(condition, name)
                    logging.debug("%s.calc_cut_factor(<instance %s>, '%s') => %s", self.__class__.__name__, condition.name, name, factor)
                    brams = result.brams * int(factor)
                    sliceLUTs = result.sliceLUTs * int(factor)
                    processors = result.processors * int(factor)
                    cut_payload = Payload(brams, sliceLUTs, processors)
                    payload += cut_payload
        logging.debug("%s.measure(<instance %s>) => %s", self.__class__.__name__, condition.name, payload)
        return payload

class Module:
    """Represents a uGT module implementation holding a subset of algorithms."""

    def __init__(self, id, tray):
        """Attribute *id* is the module index."""
        assert isinstance(tray, ResourceTray)
        self.tray = tray
        self.id = id
        self.algorithms = []
        self.floor = tray.floor()
        self.ceiling = tray.ceiling()
        self.frame = tray.frame()
        self.fdl_algo_slice = tray.fdl_algo_slice()
        self.fdl_algo_floor = tray.fdl_algo_floor()
        self.calc_deta_integer = tray.calc_deta_integer()
        self.calc_dphi_integer = tray.calc_dphi_integer()
        self.debug = False

    def __len__(self):
        """Returns count of algorithms assigned to this module."""
        return len(self.algorithms)

    def __iter__(self):
        """Iterate over algorithms."""
        return iter([algorithm for algorithm in self.algorithms])

    @property
    def conditions(self):
        """Returns list of conditions assigned to this module."""
        conditions = set()
        for algorithm in self.algorithms:
            for condition in algorithm.conditions:
                conditions.add(condition)
        return list(conditions)

    @property
    def payload(self):
        payload = self.floor
        calc_name = "ctrl, datapath, infra, readout, ttc:"
        sum_name = "summary"
        n_a = " "
        if self.debug:
            logging.debug(f"| {calc_name:<92} |")
            logging.debug(f"| {sum_name:<37} | {int(self.floor.sliceLUTs):>5} | {int(self.floor.processors):>5} | {int(self.floor.brams):>5} | {n_a:<7} | {n_a:<7}| {n_a:<4}| {n_a:<4}|")

        corr_cond_2_obj = [
            tmEventSetup.CaloCaloCorrelation,
            tmEventSetup.CaloEsumCorrelation,
            tmEventSetup.CaloMuonCorrelation,
            tmEventSetup.MuonMuonCorrelation,
            tmEventSetup.MuonEsumCorrelation,
            tmEventSetup.InvariantMass,
            tmEventSetup.InvariantMassUpt,
            tmEventSetup.TransverseMass,
        ]
        corr_cond_orm = [
            tmEventSetup.CaloCaloCorrelationOvRm,
            tmEventSetup.InvariantMassOvRm,
            tmEventSetup.TransverseMassOvRm,
            tmEventSetup.InvariantMass3,
        ]
        cond_orm = [
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
        mass_cond = [
            tmEventSetup.InvariantMass,
            tmEventSetup.InvariantMassUpt,
            tmEventSetup.TransverseMass,
            tmEventSetup.InvariantMassOvRm,
            tmEventSetup.TransverseMassOvRm,
            tmEventSetup.InvariantMass3,
            tmEventSetup.InvariantMassDeltaR,
        ]
        muon_type = [
            tmEventSetup.Muon,
        ]
        calo_type = [
            tmEventSetup.Egamma,
            tmEventSetup.Tau,
            tmEventSetup.Jet
        ]
        esums_type = [
            tmEventSetup.ETM,
            tmEventSetup.HTM,
            tmEventSetup.ETMHF
        ]

        def calc_factor(combination) -> float:
            left, right = combination[0], combination[1]
            if combination[2] != combination[3]:
                if left in muon_type:
                    return NR_MUONS * NR_MUONS
                else:
                    return NR_CALOS * NR_CALOS
            elif left == right:
                if left in muon_type:
                    return NR_MUONS * (NR_MUONS - 1) / 2
                else:
                    return NR_CALOS * (NR_CALOS - 1) / 2
            else:
                if left in calo_type and right in calo_type:
                    return NR_CALOS * NR_CALOS
                elif left in calo_type and right in muon_type:
                    return NR_CALOS * NR_MUONS
                elif left in calo_type and right in esums_type:
                    return NR_CALOS
                elif left in muon_type and right in esums_type:
                    return NR_MUONS
                else:
                    message = f"Invalid correlation combination: {left}, {right}"
                    raise RuntimeError(message)

        def calc_frame_payload() -> Payload:
            """Payload for FDL algo slices."""
            calc_name = "frame:"
            brams = self.frame.brams
            sliceLUTs = self.frame.sliceLUTs
            processors = self.frame.processors
            if self.debug:
                logging.debug(f"| {n_a:<92} |")
                logging.debug(f"| {calc_name:<92} |")
                logging.debug(f"| {sum_name:<37} | {int(sliceLUTs):>5} | {int(processors):>5} | {int(brams):>5} | {n_a:<7} | {n_a:<7}| {n_a:<4}| {n_a:<4}|")
            return Payload(brams, sliceLUTs, processors)

        def calc_fdl_payload() -> Payload:
            """Payload for FDL."""
            calc_name = "fdl_module:"
            floor_name = "base"
            slice_name = "slices"
            gtl_name = "gtl_module:"
            brams = 0
            sliceLUTs = 0
            processors = 0
            size = len(self.algorithms)
            brams_slice = self.fdl_algo_slice.brams * size
            sliceLUTs_slice = self.fdl_algo_slice.sliceLUTs * size
            processors_slice = self.fdl_algo_slice.processors * size
            brams += self.fdl_algo_slice.brams * size
            sliceLUTs += self.fdl_algo_slice.sliceLUTs * size
            processors += self.fdl_algo_slice.processors * size
            brams_floor = self.fdl_algo_floor.brams
            sliceLUTs_floor = self.fdl_algo_floor.sliceLUTs
            processors_floor = self.fdl_algo_floor.processors
            brams += self.fdl_algo_floor.brams
            sliceLUTs += self.fdl_algo_floor.sliceLUTs
            processors += self.fdl_algo_floor.processors
            if self.debug:
                logging.debug(f"| {n_a:<92} |")
                logging.debug(f"| {calc_name:<92} |")
                logging.debug(f"| {floor_name:<37} | {int(sliceLUTs_floor):>5} | {int(processors_floor):>5} | {int(brams_floor):>5} | {n_a:<7} | {n_a:<7}| {n_a:<4}| {n_a:<4}|")
                logging.debug(f"| {slice_name:<37} | {int(sliceLUTs_slice):>5} | {int(processors_slice):>5} | {int(brams_slice):>5} | {n_a:<7} | {n_a:<7}| {n_a:<4}| {n_a:<4}|")
                logging.debug(f"| {sum_name:<37} | {int(sliceLUTs):>5} | {int(processors):>5} | {int(brams):>5} | {n_a:<7} | {n_a:<7}| {n_a:<4}| {n_a:<4}|")
                logging.debug(f"| {n_a:<92} |")
                logging.debug(f"| {gtl_name:<92} |")
            return Payload(brams, sliceLUTs, processors)

        def calc_deta_dphi_combinations() -> dict:
            """Object combinations for instances of "deta_dphi_integer" calculations."""
            combinations = {}
            for algorithm in self.algorithms:
                for condition in algorithm.conditions:
                    if condition.type in corr_cond_2_obj:
                        a, b = condition.objects
                        key = (a.type, b.type, a.bx_offset, b.bx_offset) # create custom hash
                        combinations[key] = (a, b)
                    if condition.type in corr_cond_orm:
                        if len(condition.objects) == 3:
                            a, b, c = condition.objects
                            key = (a.type, b.type, a.bx_offset, b.bx_offset) # a-b combination
                            combinations[key] = (a, b)
                            key = (a.type, c.type, a.bx_offset, c.bx_offset) # a-c combination
                            combinations[key] = (a, c)
                            key = (b.type, c.type, b.bx_offset, c.bx_offset) # b-c combination
                            combinations[key] = (b, c)
                        else:
                            a = condition.objects[0]
                            b = condition.objects[1]
                            key = (a.type, b.type, a.bx_offset, b.bx_offset)
                            combinations[key] = (a, b)
                    if condition.type in cond_orm:
                        a = condition.objects[0]
                        b = condition.objects[len(condition.objects)-1]
                        key = (a.type, b.type, a.bx_offset, b.bx_offset)
                        combinations[key] = (a, b)
                    if condition.type == tmEventSetup.InvariantMassDeltaR:
                        a = condition.objects[0]
                        b = condition.objects[1]
                        key = (a.type, b.type, a.bx_offset, b.bx_offset)
                        combinations[key] = (a, b)
            return combinations

        def calc_deta_dphi_payload() -> Payload:
            """Payload for instances of "deta_dphi_integer" calculations."""
            calc_name = "calc_deta_dphi_integer"
            brams = 0
            sliceLUTs = 0
            processors = 0
            for combination in calc_deta_dphi_combinations():
                obj_0 = combination[0]
                obj_1 = combination[1]
                factor = calc_factor(combination)
                if obj_1 in (tmEventSetup.ETM, tmEventSetup.HTM, tmEventSetup.ETMHF):
                    sliceLUTs += self.calc_dphi_integer.sliceLUTs * factor
                    sliceLUTs_inst = self.calc_dphi_integer.sliceLUTs * factor
                else:
                    sliceLUTs += self.calc_deta_integer.sliceLUTs * factor
                    sliceLUTs_inst = self.calc_deta_integer.sliceLUTs * factor
                    sliceLUTs += self.calc_dphi_integer.sliceLUTs * factor
                    sliceLUTs_inst += self.calc_dphi_integer.sliceLUTs * factor
                if self.debug:
                    logging.debug(f"| {calc_name:<37} | {int(sliceLUTs_inst):>5} | {processors:>5} | {brams:>5} | {obj_type_to_str(combination[0]):<7} | {obj_type_to_str(combination[1]):<7}| {combination[2]:<4}| {combination[3]:<4}|")
            return Payload(brams, sliceLUTs, processors)

        def calc_cut_deta_combinations() -> dict:
            """Object combinations for instances of "deltaR" calculations."""
            combinations = {}
            for algorithm in self.algorithms:
                for condition in algorithm.conditions:
                    if condition.type in corr_cond_2_obj:
                        for cut in condition.cuts:
                            if cut.cut_type == tmEventSetup.DeltaEta:
                                a = condition.objects[0]
                                b = condition.objects[1]
                                key = (a.type, b.type, a.bx_offset, b.bx_offset) # create custom hash
                                combinations[key] = (a, b)
                    if condition.type in corr_cond_orm:
                        for cut in condition.cuts:
                            if cut.cut_type == tmEventSetup.OvRmDeltaEta:
                                a = condition.objects[0]
                                b = condition.objects[-1]
                                key = (a.type, b.type, a.bx_offset, b.bx_offset) # create custom hash
                                combinations[key] = (a, b)
                    if condition.type in cond_orm:
                        for cut in condition.cuts:
                            if cut.cut_type == tmEventSetup.OvRmDeltaEta:
                                a = condition.objects[0]
                                b = condition.objects[-1]
                                key = (a.type, b.type, a.bx_offset, b.bx_offset) # create custom hash
                                combinations[key] = (a, b)
            return combinations

        def calc_cut_deta_payload() -> Payload:
            """Payload for instances of "deta" calculations."""
            calc_name = "calc_cut_deta"
            brams = 0
            sliceLUTs = 0
            processors = 0
            for combination in calc_cut_deta_combinations():
                obj0 = object_category(combination[0])
                obj1 = object_category(combination[1])
                factor = calc_factor(combination)
                sliceLUTs += self.tray.calc_cut_deta(obj0, obj1).sliceLUTs * factor
                processors += self.tray.calc_cut_deta(obj0, obj1).processors * factor
                sliceLUTs_inst = self.tray.calc_cut_deta(obj0, obj1).sliceLUTs * factor
                processors_inst = self.tray.calc_cut_deta(obj0, obj1).processors * factor
                if self.debug:
                    logging.debug(f"| {calc_name:<37} | {int(sliceLUTs_inst):>5} | {processors:>5} | {brams:>5} | {obj_type_to_str(combination[0]):<7} | {obj_type_to_str(combination[1]):<7}| {combination[2]:<4}| {combination[3]:<4}|")
            return Payload(brams, sliceLUTs, processors)

        def calc_cut_dphi_combinations() -> dict:
            """Object combinations for instances of "deltaR" calculations."""
            combinations = {}
            for algorithm in self.algorithms:
                for condition in algorithm.conditions:
                    if condition.type in corr_cond_2_obj:
                        for cut in condition.cuts:
                            if cut.cut_type == tmEventSetup.DeltaPhi:
                                a = condition.objects[0]
                                b = condition.objects[1]
                                key = (a.type, b.type, a.bx_offset, b.bx_offset) # create custom hash
                                combinations[key] = (a, b)
                    if condition.type in corr_cond_orm:
                        for cut in condition.cuts:
                            if cut.cut_type == tmEventSetup.OvRmDeltaPhi:
                                a = condition.objects[0]
                                b = condition.objects[-1]
                                key = (a.type, b.type, a.bx_offset, b.bx_offset) # create custom hash
                                combinations[key] = (a, b)
                    if condition.type in cond_orm:
                        for cut in condition.cuts:
                            if cut.cut_type == tmEventSetup.OvRmDeltaPhi:
                                a = condition.objects[0]
                                b = condition.objects[-1]
                                key = (a.type, b.type, a.bx_offset, b.bx_offset) # create custom hash
                                combinations[key] = (a, b)
            return combinations

        def calc_cut_dphi_payload() -> Payload:
            """Payload for instances of "cosh_dphi_cos_dphi" calculations."""
            calc_name = "calc_cut_dphi"
            brams = 0
            sliceLUTs = 0
            processors = 0
            for combination in calc_cut_dphi_combinations():
                obj0 = object_category(combination[0])
                obj1 = object_category(combination[1])
                factor = calc_factor(combination)
                sliceLUTs += self.tray.calc_cut_dphi(obj0, obj1).sliceLUTs * factor
                processors += self.tray.calc_cut_dphi(obj0, obj1).processors * factor
                sliceLUTs_inst = self.tray.calc_cut_dphi(obj0, obj1).sliceLUTs * factor
                processors_inst = self.tray.calc_cut_dphi(obj0, obj1).processors * factor
                if self.debug:
                    logging.debug(f"| {calc_name:<37} | {int(sliceLUTs_inst):>5} | {processors:>5} | {brams:>5} | {obj_type_to_str(combination[0]):<7} | {obj_type_to_str(combination[1]):<7}| {combination[2]:<4}| {combination[3]:<4}|")
            return Payload(brams, sliceLUTs, processors)

        def calc_cut_dr_combinations() -> dict:
            """Object combinations for instances of "deltaR" calculations."""
            combinations = {}
            for algorithm in self.algorithms:
                for condition in algorithm.conditions:
                    if condition.type in corr_cond_2_obj:
                        for cut in condition.cuts:
                            if cut.cut_type == tmEventSetup.DeltaR:
                                a = condition.objects[0]
                                b = condition.objects[1]
                                key = (a.type, b.type, a.bx_offset, b.bx_offset) # create custom hash
                                combinations[key] = (a, b)
                    if condition.type in corr_cond_orm:
                        for cut in condition.cuts:
                            if cut.cut_type == tmEventSetup.OvRmDeltaR:
                                a = condition.objects[0]
                                b = condition.objects[-1]
                                key = (a.type, b.type, a.bx_offset, b.bx_offset) # create custom hash
                                combinations[key] = (a, b)
                    if condition.type in cond_orm:
                        for cut in condition.cuts:
                            if cut.cut_type == tmEventSetup.OvRmDeltaR:
                                a = condition.objects[0]
                                b = condition.objects[-1]
                                key = (a.type, b.type, a.bx_offset, b.bx_offset) # create custom hash
                                combinations[key] = (a, b)
            return combinations

        def calc_cut_dr_payload() -> Payload:
            """Payload for instances of "deltaR" calculations."""
            calc_name = "calc_cut_deltaR"
            brams = 0
            sliceLUTs = 0
            processors = 0
            for combination in calc_cut_dr_combinations():
                obj0 = object_category(combination[0])
                obj1 = object_category(combination[1])
                factor = calc_factor(combination)
                sliceLUTs += self.tray.calc_cut_dr(obj0, obj1).sliceLUTs * factor
                processors += self.tray.calc_cut_dr(obj0, obj1).processors * factor
                sliceLUTs_inst = self.tray.calc_cut_dr(obj0, obj1).sliceLUTs * factor
                processors_inst = self.tray.calc_cut_dr(obj0, obj1).processors * factor
                if self.debug:
                    logging.debug(f"| {calc_name:<37} | {int(sliceLUTs_inst):>5} | {int(processors_inst):>5} | {brams:>5} | {obj_type_to_str(combination[0]):<7} | {obj_type_to_str(combination[1]):<7}| {combination[2]:<4}| {combination[3]:<4}|")
            return Payload(brams, sliceLUTs, processors)

        def calc_cut_mass_combinations() -> dict:
            """Object combinations for instances of "mass" calculations."""
            combinations = {}
            for algorithm in self.algorithms:
                for condition in algorithm.conditions:
                    if condition.type in mass_cond:
                        a = condition.objects[0]
                        b = condition.objects[1]
                        key = (a.type, b.type, a.bx_offset, b.bx_offset) # create custom hash
                        combinations[key] = (a, b)
            return combinations

        def calc_cut_mass_payload() -> Payload:
            """Payload for instances of "mass" calculations."""
            calc_name = "calc_cut_mass_inv_pt"
            brams = 0
            sliceLUTs = 0
            processors = 0
            for combination in calc_cut_mass_combinations():
                obj0 = object_category(combination[0])
                obj1 = object_category(combination[1])
                factor = calc_factor(combination)
                sliceLUTs += self.tray.calc_cut_mass(obj0, obj1).sliceLUTs * factor
                processors += self.tray.calc_cut_mass(obj0, obj1).processors * factor
                sliceLUTs_inst = self.tray.calc_cut_mass(obj0, obj1).sliceLUTs * factor
                processors_inst = self.tray.calc_cut_mass(obj0, obj1).processors * factor
                if self.debug:
                    logging.debug(f"| {calc_name:<37} | {int(sliceLUTs_inst):>5} | {int(processors_inst):>5} | {brams:>5} | {obj_type_to_str(combination[0]):<7} | {obj_type_to_str(combination[1]):<7}| {combination[2]:<4}| {combination[3]:<4}|")
            return Payload(brams, sliceLUTs, processors)

        # payload for "frame"
        payload += calc_frame_payload()

        # payload for FDL
        payload += calc_fdl_payload()

        # payload for instances of "deltaR" calculations
        payload += calc_cut_dr_payload()

        # payload for instances of "deltaEta" calculations
        payload += calc_cut_deta_payload()

        # payload for instances of "deltaPhi" calculations
        payload += calc_cut_dphi_payload()

        # payload for instances of "mass" calculations
        payload += calc_cut_mass_payload()

        # payload for instances of "deta dphi integer" calculations
        payload += calc_deta_dphi_payload()

# =================================================================================

        payloadMap = {}
        for algorithm in self.algorithms:
            for condition in algorithm.conditions:
                payloadMap[condition.name] = condition.payload

        for name, payload_ in payloadMap.items():
            payload += payload_
        return payload

    def append(self, algorithm):
        """Appends an algorithm, updates module id and index of assigned algorithm."""
        payload = self.payload + algorithm.payload
        if payload.brams > self.ceiling.brams:
             raise ResourceOverflowError() # no more BRAM resources left, ceiling exceeded
        if payload.sliceLUTs > self.ceiling.sliceLUTs:
             raise ResourceOverflowError() # no more sliceLUT resources left, ceiling exceeded
        if payload.processors > self.ceiling.processors:
             raise ResourceOverflowError() # no more processor resources left, ceiling exceeded
        algorithm.module_id = self.id
        algorithm.module_index = len(self) # enumerate
        self.algorithms.append(algorithm)

    def __repr__(self):
        return f"{self.__class__.__name__}(id={self.id}, algorithms={len(self)}, payload={self.payload})"

class ModuleCollection:
    """Collection of modules permitting various operations."""
    def __init__(self, es, tray):
        """Attribute *modules* represents the number of instantiated modules."""
        assert isinstance(es, tmEventSetup.esTriggerMenu)
        assert isinstance(tray, ResourceTray)
        self.eventSetup = es
        self.tray = tray
        self.modules = []
        self.ratio = .0
        self.reverse_sorting = False
        self.regenerate_uuid = True
        self.constraints = {}
        # Calculate condition handles
        self.condition_handles = {}
        for name, condition in es.getConditionMapPtr().items():
            payload = tray.measure(condition)
            self.condition_handles[name] = ConditionHandle(condition, payload)
        # Calculate algorithms handles, sort them descending by payload
        self.algorithm_handles = []
        for name, algorithm in es.getAlgorithmMapPtr().items():
            conditions = [self.condition_handles[condition] for condition in get_condition_names(algorithm)]
            self.algorithm_handles.append(AlgorithmHandle(algorithm, conditions))
        # pre sort
        self.algorithm_handles.sort(key=lambda algorithm: algorithm.payload, reverse=self.reverse_sorting)
        #
        # HACK TODO batch updating condition cuts
        # * assigning precision_pt
        # * assigning precision_math
        # * assigning precision_inverse_deltaR
        # * assigning precision_cscore
        #
        def precision_key(left, right, name):
            """Returns precision key for scales map."""
            left = ObjectGrammarKey[left.type]
            right = ObjectGrammarKey[right.type]
            return f'PRECISION-{left}-{right}-{name}'
        scales = self.eventSetup.getScaleMapPtr()

        for condition in self.condition_handles.values():
            for object in condition.objects:
                for cut in object.cuts:
                    if cut.cut_type == tmEventSetup.CicadaScore:
                        cut.precision_cscore = scales['PRECISION-CICADA-CScore'].getNbits()
            for cut in condition.cuts:
                if cut.cut_type == tmEventSetup.TwoBodyPt:
                    left = condition.objects[0]
                    right = condition.objects[1]
                    cut.precision_pt = 1 # for all
                    cut.precision_math = scales[precision_key(left, right, 'TwoBodyPtMath')].getNbits()
                elif cut.cut_type in (tmEventSetup.Mass, tmEventSetup.MassUpt):
                    left = condition.objects[0]
                    right = condition.objects[1]
                    cut.precision_pt = scales[precision_key(left, right, 'MassPt')].getNbits()
                    cut.precision_math = scales[precision_key(left, right, 'Math')].getNbits()
                elif cut.cut_type == tmEventSetup.MassDeltaR:
                    left = condition.objects[0]
                    right = condition.objects[1]
                    cut.precision_pt = scales[precision_key(left, right, 'MassPt')].getNbits()
                    cut.precision_math = scales[precision_key(left, right, 'Math')].getNbits()
                    cut.precision_inverse_dr = scales[precision_key(left, right, 'InverseDeltaRMath')].getNbits()
        #
        # /END HACK
        #

    def __len__(self):
        """Returns count of modules assigned to this collection."""
        return len(self.modules)

    def __iter__(self):
        """Iterate over modules."""
        return iter([module for module in self.modules])

    def setConstraint(self, condition, modules):
        """Set module constraint for condition type."""
        # Force list for single numbers
        modules = modules if isinstance(modules, (list, tuple)) else [modules]
        assert condition in ConditionTypeKey.values(), f"no such constraint condition type '{condition}'"
        assert max(modules) <= MaxModules, "exceeding constraint module range 'modules'"
        self.constraints[condition] = modules

    def capableModules(self):
        """Return modules below payload ceiling."""
        return filter(lambda module: (module.payload) < module.ceiling, self.modules)

    def lightestModule(self, constraints=None):
        """Retruns module with the least payload. Assign constraints to limit modules."""
        modules = self.modules
        if constraints:
            modules = [module for module in self.modules if module.id in constraints]
        return sorted(modules, key=lambda module: module.payload)[0]

    @property
    def algorithms(self):
        """Returns list of all algorithms."""
        return [algorithm for algorithm in self.algorithm_handles]

    def byConditionType(self):
        """Returns dictionary with lists of conditions grouped by their types."""
        conditions = {}
        for condition in self.conditions:
            type = condition.type
            if type not in conditions:
                conditions[type] = []
            conditions[type].append(condition)
        return conditions

    @property
    def conditions(self):
        """Retruns unsorted list of all conditions."""
        return [condition for _, condition in self.condition_handles.items()]

    def distribute(self, modules: int):
        """Distribute algorithms to modules, applying shadow ratio.
        """
        # sort algorithms
        self.algorithm_handles.sort(key=lambda algorithm: algorithm.payload, reverse=self.reverse_sorting)
        # regenerate firmware UUID
        if self.regenerate_uuid:
            self.eventSetup.setFirmwareUuid(str(uuid.uuid4()))
        logging.info("starting algorithm distribution for %d algorithms on %d " \
                     "modules using shadow ratio of %.1f", len(self.algorithm_handles), modules, self.ratio)
        self.modules = [Module(id, self.tray) for id in range(modules)]
        stack = list(self.algorithm_handles) # copy list
        try:
            while stack:
                algorithm = stack.pop(0) # POP
                module = self.lightestModule()
                # ######## constraints ########
                for condition in algorithm:
                    condition_type_name = ConditionTypeKey[condition.type]
                    if condition_type_name in self.constraints:
                        module = self.lightestModule(self.constraints[condition_type_name])
                        logging.info("[*] applying condition constraint %r => module %r", condition_type_name, module.id)
                        break
                # ######## /constraints ########
                logging.info(" . adding %s (%d) to module %s", algorithm.name, algorithm.index, module.id)
                module.append(algorithm)
                condition_names = [condition.name for condition in algorithm.conditions]
                for shadowed in self.getShadowed(stack, condition_names, self.ratio):
                    # ######## constraints ########
                    has_constraint = False
                    i = stack.index(shadowed)
                    for condition in stack[i]:
                        condition_type_name = ConditionTypeKey[condition.type]
                        if condition_type_name in self.constraints:
                            if module.id != self.constraints[condition_type_name]:
                                logging.info("[*] applying condition constraint %r, ignoring shadowed algorithm %s", condition_type_name, stack[i].name)
                                has_constraint = True
                                break
                    if has_constraint:
                        continue
                    # ######## /constraints ########
                    stack.pop(stack.index(shadowed)) # POP
                    logging.info(" ... adding shadowed %s %s to module %s", shadowed.name, shadowed.index, module.id)
                    module.append(shadowed)
        except ResourceOverflowError:
            logging.error("no resources left to implement menu")
            logging.error("there are %d unassigned algorithms left:", len(stack))
            for algorithm in stack:
                logging.error("%s %s", algorithm.index, algorithm.name)
            logging.error("previously assigned resources:")
            for module in self.modules:
                logging.error("module: %s %s ceiling: %s algorithms: %s", module.id, module.payload, module.ceiling, len(module))
            raise

    def validate(self):
        """Raises an asserion exception on errors."""
        for module in self:
            for algorithm in module:
                names = [condition.name for condition in algorithm.conditions]
                assert module.id == algorithm.module_id

    def load(self, fp):
        """Loads distribution from JSON."""
        data = json.load(fp)
        modules = [Module(id, self.tray) for id in range(data['n_modules'])]
        stack = list(self.algorithm_handles)
        try:
            for algorithm in sorted(data['algorithms'], key=lambda a: a['module_index']):
                index = algorithm['index']
                name = algorithm['name']
                module_id = algorithm['module_id']
                module_index = algorithm['module_index']
                algorithm_handle = filter_first(lambda handle: handle.index == index and handle.name == name, self.algorithm_handles)
                stack.pop(stack.index(algorithm_handle))
                # insert in correct order!
                modules[module_id].append(algorithm_handle)
        except ResourceOverflowError:
            logging.error("no resources left to implement menu")
            logging.error("there are %d unassigned algorithms left:", len(stack))
            for algorithm in stack:
                logging.error("%s %s", algorithm.index, algorithm.name)
            logging.error("previously assigned resources:")
            for module in modules:
                logging.error("module: %s %s ceiling: %s algorithms: %s", module.id, module.payload, module.ceiling, len(module))
            raise
        self.modules = modules

    def dump(self, fp, indent=2):
        """Dumps distribution to JSON."""
        algorithms = []
        for module in self:
            for algorithm in module:
                algorithms.append({
                    'name': algorithm.name,
                    'index': algorithm.index,
                    'module_id': algorithm.module_id,
                    'module_index': algorithm.module_index,
                })
        # Sort by global index
        algorithms.sort(key=lambda algorithm: algorithm['index'])
        data = {
            'name': self.eventSetup.getName(),
            'menu_uuid': self.eventSetup.getMenuUuid(),
            'firmware_uuid': self.eventSetup.getFirmwareUuid(),
            'n_modules': len(self),
            'algorithms': algorithms,
        }
        json.dump(data, fp, indent=indent)

    def getShadowed(self, stack, conditions, ratio, depth=1):
        """Returns list of shadowed conditions from a stack of algorithms.
        Attribute *ratio* (0.0 < ratio <= 1.0) regulates the minimum amount of a shadowed algorithm.
        Depth param is used for recursive call!
        """
        shadowed = []
        a = conditions
        for algorithm in stack:
            if algorithm in shadowed:
                continue
            b = [condition.name for condition in algorithm.conditions]
            # is shadowed at all?
            if (set(a) & set(b)): # abc & bcd -> bc
                left = len(set(a) & set(b)) # number of identical conditions len(bc)
                right = len(set(a + b) - (set(a) & set(b))) # number of other conditions len(ad)
                total = left + right # total number of conditions
                percent = total/100.
                if ratio <= (left/percent/100.):
                    indent = " +-{0}".format("-" * depth)
                    logging.info("%s %s shadowed ratio %.1f %%", indent, algorithm.name, (left/percent))
                    shadowed.append(algorithm)
                    shadowed += self.getShadowed(set(stack)-set(shadowed), list(set(a+b)), ratio, depth+1) # add recursive....
                    shadowed = list(set(shadowed))
        return shadowed

    def __repr__(self):
        return f"{self.__class__.__name__}(modules={len(self)})"

#
# Application
#

def float_percent(value: float) -> float:
    value = float(value)
    if .0 <= value <= 1.:
        return value
    raise ValueError("percentage value must be within 0.0 and 1.0")

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('filename', metavar='<file>', type=os.path.abspath, help="XML menu")
    parser.add_argument('--config', metavar='<file>', default=DefaultConfigFile, type=os.path.abspath, help=f"JSON resource configuration file, default {DefaultConfigFile}")
    parser.add_argument('--modules', metavar='<n>', default=2, type=int, help="number of modules, default is 2")
    parser.add_argument('--ratio', metavar='<f>', default=0.0, type=float, help="algorithm shadow ratio (0.0 < ratio <= 1.0, default 0.0)")
    parser.add_argument('--sorting', metavar='asc|desc', choices=('asc', 'desc'), default='asc', help="sort order for weighting (asc or desc, default asc)")
    parser.add_argument('--constraint', metavar='<condition:module>', type=constraint_t, action='append', help="limit condition type to a specific module")
    parser.add_argument('-o', metavar='<file>', type=os.path.abspath, help="write calculated distribution to JSON file")
    parser.add_argument('--list', action='store_true', help="list resource scales and exit")
    parser.add_argument("--verbose", dest="verbose", action="store_true")
    return parser.parse_args()

def list_resources(tray: ResourceTray) -> None:
    logging.info(":: listing resources...")
    def section(name, instance):
        bramsPercent = instance.brams / BRAMS_TOTAL * 100
        sliceLUTsPercent = instance.sliceLUTs / SLICELUTS_TOTAL * 100
        processorsPercent = instance.processors / PROCESSORS_TOTAL * 100
        return f" * {name}: brams={bramsPercent:.2f}%, sliceLUTs={sliceLUTsPercent:.2f}%, processors={processorsPercent:.2f}%"
    logging.info("thresholds:")
    logging.info(section("floor", tray.floor()))
    logging.info(section("ceiling", tray.ceiling()))
    logging.info("instances:")
    for instance in tray.resources.instances:
        for object_ in instance.objects:
            object_list = ', '.join(object_.types)
            name = f"{instance.type}[ {object_list} ]"
            logging.info(section(name, object_))
            if hasattr(object_, 'cuts'):
                for cut in object_.cuts:
                    logging.info("  %s", section(cut.type, cut))

def list_algorithms(collection: ModuleCollection) -> None:
    logging.info("|---------------------------------------------------------------------------------------|")
    logging.info("|                                                                                       |")
    logging.info("| Algorithms sorted by payload (descending)                                             |")
    logging.info("|                                                                                       |")
    logging.info("|---------------------------------------------------------------------------------------|")
    logging.info("|-------|---------|-----------|---------|-----------------------------------------------|")
    logging.info("| Index | BRAMs   | SliceLUTs | DSPs    | Name                                          |")
    logging.info("|-------|---------|-----------|---------|-----------------------------------------------|")
    for algorithm in collection.algorithm_handles:
        brams = algorithm.payload.brams / BRAMS_TOTAL  * 100.
        sliceLUTs = algorithm.payload.sliceLUTs / SLICELUTS_TOTAL * 100.
        processors = algorithm.payload.processors / PROCESSORS_TOTAL * 100.
        name = short_name(algorithm.name, 41)
        logging.info(f"| {algorithm.index:>5d} | {brams:>6.3f}% | {sliceLUTs:>8.3f}% | {processors:>6.3f}% | {name:<45} |")
    logging.info("|-------|---------|-----------|---------|-----------------------------------------------|")
    logging.info("|---------------------------------------------------------------------------------------|")

def list_distribution(collection: ModuleCollection) -> None:
    message = f"Detailed distribition on {len(collection)} modules, shadow ratio: {collection.ratio:.1f}"
    logging.info("|-----------------------------------------------------------------------------|")
    logging.info("|                                                                             |")
    logging.info(f"| {message:<75} |")
    logging.info("|                                                                             |")
    logging.info("|------------|----------------------------------------------------------------|")
    logging.info("| Module     | Algorithm                                                      |")
    logging.info("| ID | Index | Index | Name                                                   |")
    logging.info("|----|-------|-------|--------------------------------------------------------|")
    for module in collection:
        indices = sorted(str(algorithm.index) for algorithm in module)
        for algorithm in module:
            name = short_name(algorithm.name, 50)
            line = f"| {algorithm.module_id:>2d} | {algorithm.module_index:>5d} " \
                   f"| {algorithm.index:>5d} | {name:<54} |"
            logging.info(line)
    logging.info("|----|-------|-------|--------------------------------------------------------|")
    logging.info("|-----------------------------------------------------------------------------|")
    logging.info("|                                                                             |")
    if collection.reverse_sorting:
        logging.info("| Condition distribution, sorted by weight (descending)                       |")
    else:
        logging.info("| Condition distribution, sorted by weight (ascending)                        |")
    logging.info("|                                                                             |")
    logging.info("|-----------------------------------------------------------------------------|")
    logging.info("|-----------------------------------------------------------------------------------|")
    logging.info("| Name                                             | Modules | sLUTs | DSPs | BRAMs |")
    logging.info("|--------------------------------------------------|---------|-------|------|-------|")
    conditions = sorted(collection.conditions, key=lambda condition: condition.payload, reverse=collection.reverse_sorting)
    for condition in conditions:
        modules = []
        for module in collection:
            if condition in module.conditions:
                modules.append(module.id)
        modules_list = ','.join([str(module) for module in modules])
        logging.info(f"| {condition.name:<48} | {modules_list:<7} | {condition.payload.sliceLUTs:<6}| {condition.payload.processors:<5}| {condition.payload.brams:<5} |")
    logging.info("|--------------------------------------------------|---------|-------|------|-------|")

def list_summary(collection: ModuleCollection) -> None:
    message = f"Summary for distribution on {len(collection)} modules, shadow ratio: {collection.ratio:.1f}"
    logging.info("|--------------------------------------------------------------------------------------|")
    logging.info("|                                                                                      |")
    logging.info(f"| {message:<84} |")
    logging.info("|                                                                                      |")
    logging.info("|-------------------------------------|------------------------------------------------|")
    logging.info("|                                     |                    Payload                     |")
    logging.info("|-------------------------------------|------------------------------------------------|")
    logging.info("|              Module                 |   SliceLUTs    |     BRAMs     |     DSPs      |")
    logging.info("|-------------------------------------|------------------------------------------------|")
    logging.info("| ID | Algorithms | Conditions | Rel. | Value  |  [%]  | Value |  [%]  | Value |  [%]  |")
    logging.info("|----|------------|------------|------|--------|-------|-------|-------|-------|-------|")
    for module in collection:
        algorithms = len(module)
        conditions = len(module.conditions)
        proportion = float(conditions) / algorithms if algorithms else 1.0
        brams_val = module.payload.brams
        sliceLUTs_val = module.payload.sliceLUTs
        processors_val = module.payload.processors
        brams = module.payload.brams / BRAMS_TOTAL * 100.
        sliceLUTs = module.payload.sliceLUTs / SLICELUTS_TOTAL * 100.
        processors = module.payload.processors / PROCESSORS_TOTAL * 100.
        logging.info(f"| {module.id:>2} | {algorithms:>10} | {conditions:>10} | {proportion:>4.2f} | " \
                     f"{sliceLUTs_val:>6.0f} | {sliceLUTs:>5.2f} | {brams_val:>5.0f} | {brams:>5.2f} | {processors_val:>5.0f} | {processors:>5.2f} |")
    logging.info("|----|------------|------------|------|--------|-------|-------|-------|-------|-------|")

def list_instantiations_debug(collection: ModuleCollection) -> None:
    n_a = " "
    message = f"Summary of instantiations resources on {len(collection)} modules"
    logging.debug("|----------------------------------------------------------------------------------------------|")
    logging.debug("|                                                                                              |")
    logging.debug(f"| {message:<92} |")
    logging.debug("|                                                                                              |")
    logging.debug("|----------------------------------------------------------------------------------------------|")
    for module in collection:
        module.debug = True
        logging.debug("|                                                                                              |")
        logging.debug("| module_%s:                                                                                    |", module.id)
        logging.debug("|                                                                                              |")
        logging.debug("| instantiation name                    | sLUTs | DSPs  | BRAMs | obj 1   | obj 2  | bx 1| bx 2|")
        logging.debug("|---------------------------------------|-------|-------|-------|---------|--------|-----|-----|")
        module_payload = module.payload # dummy for debug listing of calculation instantiations resources
        for algorithm in module:
            for condition in algorithm.conditions:
                cond_name =  "cond_" + condition.name
                logging.debug(f"| {cond_name:<37} | {condition.payload.sliceLUTs:>5} | {condition.payload.processors:>5} | {condition.payload.brams:>5} | {n_a:<7} | {n_a:<7}| {n_a:<4}| {n_a:<4}|")
        logging.debug("|----------------------------------------------------------------------------------------------|")

def dump_distribution(collection: ModuleCollection, filename: str):
    logging.info(":: writing menu distribution JSON dump: %s", filename)
    with open(filename, 'w') as fp:
        collection.dump(fp)

def distribute(eventSetup, modules: int, config: str, ratio: float, reverse_sorting: bool, constraints: Dict[str, str] = None) -> ModuleCollection:
    """Distribution wrapper function, provided for convenience."""
    logging.info("distributing menu...")

    constraints = constraints or {}

    logging.info("loading resource information from JSON: %s", config)
    # Load resource file
    tray = ResourceTray(config)
    # Diagnostic output
    list_resources(tray)

    # Create empty module collection
    collection = ModuleCollection(eventSetup, tray)

    # Diagnostic output
    list_algorithms(collection)

    logging.info("distributing algorithms, shadow ratio: %s", ratio)
    collection.ratio = ratio
    collection.reverse_sorting = reverse_sorting
    for k, v in constraints.items():
        collection.setConstraint(k, v)
    collection.distribute(modules)

    # Diagnostic output
    list_distribution(collection)
    list_summary(collection)
    list_instantiations_debug(collection)

    # Perform some checks
    collection.validate()

    return collection

def main() -> int:
    args = parse_args()
    print("args.resource_list:",args.resource_list)
    level = logging.DEBUG if args.verbose else logging.INFO
    logging.getLogger().setLevel(level)

    logging.info("reading event setup from XML menu: %s", args.filename)
    es = tmEventSetup.getTriggerMenu(args.filename)

    logging.info("loading resource information from JSON: %s", args.config)
    tray = ResourceTray(args.config)

    # List resource scales and exit.
    if args.list:
        list_resources(tray)
        logging.info("done.")
        return 0

    # Create module stubs
    collection = ModuleCollection(es, tray)

    list_algorithms(collection)

    logging.info("distributing algorithms, shadow ratio: %s", args.ratio)
    collection.ratio = args.ratio
    # Set sort order (asc or desc)
    collection.reverse_sorting = (args.sorting == 'desc')
    # Collect condition constraints
    if args.constraint:
        for k, v in args.constraint:
            collection.setConstraint(k, v)
    # Run distibution
    collection.distribute(args.modules)



    list_distribution(collection)

    list_summary(collection)

    list_instantiations_debug(collection)

    if args.o:
        dump_distribution(collection, args.o)

    logging.info("done.")

    return 0

if __name__ == '__main__':
    sys.exit(main())
