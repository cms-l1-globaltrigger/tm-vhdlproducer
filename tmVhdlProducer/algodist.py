#!/usr/bin/env python2

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

import tmEventSetup
import tmGrammar
import tmTable

from collections import namedtuple
import argparse
import logging
import json, uuid
import sys, os

ProjectDir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
"""Projects root directory."""

DefaultConfigDir = os.path.join(ProjectDir, 'config')
"""Default directory for resource configuration files."""

DefaultConfigFile = os.path.join(DefaultConfigDir, 'resource_default.json')
"""Default resource configuration file."""

Operators = (
    tmGrammar.AND,
    tmGrammar.OR,
    tmGrammar.XOR,
    tmGrammar.NOT,
)
"""List of valid algorithm expression operators."""

esCutType = {
  tmEventSetup.Threshold: 'Threshold',
  tmEventSetup.Eta: 'Eta',
  tmEventSetup.Phi: 'Phi',
  tmEventSetup.Charge: 'Charge',
  tmEventSetup.Quality: 'Quality',
  tmEventSetup.Isolation: 'Isolation',
  tmEventSetup.DeltaEta: 'DeltaEta',
  tmEventSetup.DeltaPhi: 'DeltaPhi',
  tmEventSetup.DeltaR: 'DeltaR',
  tmEventSetup.Mass: 'Mass',
  tmEventSetup.ChargeCorrelation: 'ChargeCorrelation',
}
"""Dictionary for cut type enumerations."""

esObjectType = {
    tmEventSetup.Muon: 'Muon',
    tmEventSetup.Egamma: 'Egamma',
    tmEventSetup.Tau: 'Tau',
    tmEventSetup.Jet: 'Jet',
    tmEventSetup.ETT: 'ETT',
    tmEventSetup.HTT: 'HTT',
    tmEventSetup.ETM: 'ETM',
    tmEventSetup.HTM: 'HTM',
    tmEventSetup.MBT0HFM: 'MBT0HFM',
    tmEventSetup.MBT0HFP: 'MBT0HFP',
    tmEventSetup.MBT1HFM: 'MBT1HFM',
    tmEventSetup.MBT1HFP: 'MBT1HFP',
    tmEventSetup.EXT: 'EXT',
    tmEventSetup.Precision: 'Precision',
}
"""Dictionary for object type enumerations."""

esConditionType = {
    tmEventSetup.SingleMuon: 'SingleMuon',
    tmEventSetup.DoubleMuon: 'DoubleMuon',
    tmEventSetup.TripleMuon: 'TripleMuon',
    tmEventSetup.QuadMuon: 'QuadMuon',
    tmEventSetup.SingleEgamma: 'SingleEgamma',
    tmEventSetup.DoubleEgamma: 'DoubleEgamma',
    tmEventSetup.TripleEgamma: 'TripleEgamma',
    tmEventSetup.QuadEgamma: 'QuadEgamma',
    tmEventSetup.SingleTau: 'SingleTau',
    tmEventSetup.DoubleTau: 'DoubleTau',
    tmEventSetup.TripleTau: 'TripleTau',
    tmEventSetup.QuadTau: 'QuadTau',
    tmEventSetup.SingleJet: 'SingleJet',
    tmEventSetup.DoubleJet: 'DoubleJet',
    tmEventSetup.TripleJet: 'TripleJet',
    tmEventSetup.QuadJet: 'QuadJet',
    tmEventSetup.TotalEt: 'TotalEt',
    tmEventSetup.TotalHt: 'TotalHt',
    tmEventSetup.MissingEt: 'MissingEt',
    tmEventSetup.MissingHt: 'MissingHt',
    tmEventSetup.MinBiasHFM0: 'MinBiasHFM0',
    tmEventSetup.MinBiasHFM1: 'MinBiasHFM1',
    tmEventSetup.MinBiasHFP0: 'MinBiasHFP0',
    tmEventSetup.MinBiasHFP1: 'MinBiasHFP1',
    tmEventSetup.Externals: 'Externals',
    tmEventSetup.MuonMuonCorrelation: 'MuonMuonCorrelation',
    tmEventSetup.MuonEsumCorrelation: 'MuonEsumCorrelation',
    tmEventSetup.CaloMuonCorrelation: 'CaloMuonCorrelation',
    tmEventSetup.CaloCaloCorrelation: 'CaloCaloCorrelation',
    tmEventSetup.CaloEsumCorrelation: 'CaloEsumCorrelation',
    tmEventSetup.InvariantMass: 'InvariantMass',
}
"""Dictionary for condition type enumerations."""

MuonConditionTypes = [
    'SingleMuon',
    'DoubleMuon',
    'TripleMuon',
    'QuadMuon',
]

CaloConditionTypes = [
    'SingleEgamma',
    'DoubleEgamma',
    'TripleEgamma',
    'QuadEgamma',
    'SingleTau',
    'DoubleTau',
    'TripleTau',
    'QuadTau',
    'SingleJet',
    'DoubleJet',
    'TripleJet',
    'QuadJet',
]

EsumsConditionTypes = [
    'TotalEt',
    'TotalHt',
    'MissingEt',
    'MissingHt',
]

ExternalConditionTypes = [
    'Externals',
]

MinBiasConditionTypes = [
    'MinBiasHFM0',
    'MinBiasHFM1',
    'MinBiasHFP0',
    'MinBiasHFP1',
]

CorrelationConditionTypes = [
    'MuonMuonCorrelation',
    'MuonEsumCorrelation',
    'CaloMuonCorrelation',
    'CaloCaloCorrelation',
    'CaloEsumCorrelation',
    'InvariantMass',
]

ObjectsOrder = [
    'Egamma',
    'Jet',
    'Tau',
    'Muon',
    'ETT',
    'HTT',
    'ETM',
    'HTM',
    'MBT0HFM',
    'MBT0HFP',
    'MBT1HFM',
    'MBT1HFP',
    'EXT',
    'Precision',
]

#
# Functions
#

def get_condition_names(algorithm):
    """Returns list of condition names of an algorithm (from RPN vector)."""
    return [label for label in algorithm.getRpnVector() if label not in Operators]

def short_name(name, length):
    """Shortens long names, if longer then length replaces last characters by ..."""
    if len(name) > length:
        return "{name}...".format(name=name[:length-3])
    return name[:length]

#
# Classes
#

class ResourceOverflowError(RuntimeError):
    pass

class Payload(object):
    """Implements a generic payload represented by multiple attributes.

    >>> payload = Payload(sliceLUTs, processors)
    >>> payload < (payload + payload)
    >>> payload.sliceLUTs, payload.processors
    """
    def __init__(self, sliceLUTs=0, processors=0):
        self.sliceLUTs = float(sliceLUTs)
        self.processors = float(processors)

    def _astuple(self):
        """Retrurns tuple of payload attributes ordered by significance (most significant last, least first)."""
        return self.sliceLUTs, self.processors

    def _asdict(self):
        return dict(sliceLUTs=self.sliceLUTs, processors=self.processors)

    def __add__(self, payload):
        """Multiplicate payloads."""
        sliceLUTs = self.sliceLUTs + payload.sliceLUTs
        processors = self.processors + payload.processors
        return Payload(sliceLUTs, processors)

    def __eq__(self, payload):
        return self._astuple() == payload._astuple()

    def __lt__(self, payload):
        """Compare payloads by list of attributes ordered by significance."""
        return self._astuple() < payload._astuple()

    def __repr__(self):
        sliceLUTsPercent = self.sliceLUTs * 100
        processorsPercent = self.processors * 100
        return "{self.__class__.__name__}(sliceLUTs={sliceLUTsPercent:.2f}%, DSPs={processorsPercent:.2f}%)".format(**locals())

class ResourceTray(object):
    """Scale tray for calculating condition and algorithm payloads. It loads
    payload and threshold specifications from a JSON file.

    >>> tray = Tray(es, 'algo_dist.json')
    >>> tray.measure(condition)
    """
    def __init__(self, filename):
        """Attribute *filename* is a filename of an JSON payload configuration file."""
        with open(filename, 'rb') as fp:
            resources = json.load(fp, object_hook=self._object_hook).resources
        self.resources = resources

    def _object_hook(self, d):
        """Convert a dict into a namedtuple, used to convert JSON input.
        http://stackoverflow.com/questions/35898270/trying-to-make-a-dict-behave-like-a-clean-class-method-structure
        """
        for k,v in d.iteritems():
            if isinstance(v, dict):
                d[k] = self._object_hook(v)
        return namedtuple('resource', d.keys())(**d)

    def measure(self, condition):
        """Calculates the payload of a condition by its type and objects."""
        if isinstance(condition, tmEventSetup.esCondition):
            condition = ConditionStub(condition, Payload()) # cast to stub with empty payload
        def compare(instance):
            if instance.type != condition.type: return False
            if set(instance.objects) != set(condition.objects): return False
            return True
        instance = filter(compare, self.resources.instances)[0]
        payload = Payload(instance.sliceLUTs, instance.processors)
        return payload

class ConditionStub(object):
    """Represents an condition."""
    def __init__(self, condition, payload):
        self.name = condition.getName()
        self.type = esConditionType[condition.getType()]
        objects = [esObjectType[object.getType()] for object in condition.getObjects()]
        self.objects = self.sortedObjects(objects)
        self.cuts = [esCutType[cut.getCutType()] for cut in condition.getCuts()]
        self.payload = Payload(payload.sliceLUTs, payload.processors)
        self.ptr = condition

    def sortedObjects(self, objects):
        """Returns list of condition objects sorted by VHDL notation."""
        return sorted(objects, key = lambda key: ObjectsOrder.index(key))

    def isMuonCondition(self):
        return self.type in MuonConditionTypes

    def isCaloCondition(self):
        return self.type in CaloConditionTypes

    def isEsumsCondition(self):
        return self.type in EsumsConditionTypes

    def isExternalCondition(self):
        return self.type in ExternalConditionTypes

    def isMinBiasCondition(self):
        return self.type in MinBiasConditionTypes

    def isCorrelationCondition(self):
        return self.type in CorrelationConditionTypes

    def __repr__(self):
        return "{self.__class__.__name__}(name={self.name}, payload={self.payload})".format(**locals())

class AlgorithmStub(object):
    """Represents an algorithm."""
    def __init__(self, algorithm, conditions):
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
        return "{self.__class__.__name__}(index={self.index}, name={self.name}, payload={self.payload})".format(**locals())

class ModuleStub(object):
    """Represents a uGT module implementation holding a subset of algorithms."""
    def __init__(self, id, tray):
        """Attribute *id* is the module index."""
        self.id = id
        self.algorithms = []
        resources = tray.resources
        self.floor = Payload(sliceLUTs=resources.floor.sliceLUTs, processors=resources.floor.processors)
        self.ceiling = Payload(sliceLUTs=resources.ceiling.sliceLUTs, processors=resources.ceiling.processors)

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
        payloadMap = {}
        for algorithm in self.algorithms:
            for condition in algorithm.conditions:
                payloadMap[condition.name] = condition.payload
        for name, payload_ in payloadMap.iteritems():
            payload += payload_
        return payload

    def append(self, algorithm):
        """Appends an algorithm, updates module id and index of assigned algorithm."""
        if self.payload + algorithm.payload > self.ceiling:
            raise ResourceOverflowError() # no more resources left, ceiling exceeded
        algorithm.module_id = self.id
        algorithm.module_index = len(self) # enumerate
        self.algorithms.append(algorithm)

    def __repr__(self):
        count = len(self)
        return "{self.__class__.__name__}(id={self.id}, algorithms={count}, payload={self.payload})".format(**locals())

class ModuleCollection(object):
    """Collection of modules permitting various operations."""
    def __init__(self, es, tray):
        """Attribute *modules* represents the number of instantiated modules."""
        self.eventSetup = es
        self.tray = tray
        self.modules = []
        self.ratio = .0
        # Calculate condition stubs
        self.conditionStubs = {}
        for name, condition in es.getConditionMapPtr().iteritems():
            payload = tray.measure(condition)
            self.conditionStubs[name] = ConditionStub(condition, payload)
        # Calculate algorithms stubs, sort them descending by payload
        self.algorithmStubs = []
        for name, algorithm in es.getAlgorithmMapPtr().iteritems():
            conditions = [self.conditionStubs[condition] for condition in get_condition_names(algorithm)]
            self.algorithmStubs.append(AlgorithmStub(algorithm, conditions))
        self.algorithmStubs.sort(key = lambda algorithm: algorithm.payload, reverse=True)

    def __len__(self):
        """Returns count of modules assigned to this collection."""
        return len(self.modules)

    def __iter__(self):
        """Iterate over modules."""
        return iter([module for module in self.modules])

    def capableModules(self):
        """Return modules below payload ceiling."""
        return filter(lambda module: (module.payload) < module.ceiling, self.modules)

    def lightestModule(self):
        """Retruns module with the least payload."""
        return sorted(self.modules, key = lambda module: module.payload)[0]

    @property
    def algorithms(self):
        """Returns list of all algorithms."""
        return [algorithm for algorithm in self.algorithmStubs]

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
        return [condition for _, condition in self.conditionStubs.iteritems()]

    def distribute(self, modules, ratio, regenerate=True):
        """Distribute algorithms to modules, applying shadow ratio.
        Regenerates firmware UUID.
        """
        if regenerate:
            self.eventSetup.setFirmwareUuid(str(uuid.uuid4())) # regenerate firmware UUID
        logging.info("starting algorithm distribution for %d algorithms on %d " \
                     "modules using shadow ratio of %.1f", len(self.algorithmStubs), modules, ratio)
        self.modules = [ModuleStub(id, self.tray) for id in range(modules)]
        self.ratio = ratio
        stack = list(self.algorithmStubs) # copy list
        try:
            while stack:
                algorithm = stack.pop(0) # POP
                module = self.lightestModule()
                logging.info(" . adding %s (%d) to module %s", algorithm.name, algorithm.index, module.id)
                module.append(algorithm)
                condition_names = [condition.name for condition in algorithm.conditions]
                for shadowed in self.getShadowed(stack, condition_names, ratio):
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
        modules = [ModuleStub(id, self.tray) for id in range(data['n_modules'])]
        stack = list(self.algorithmStubs)
        try:
            for algorithm in sorted(data['algorithms'], key=lambda a: a['module_index']):
                index = algorithm['index']
                name = algorithm['name']
                module_id = algorithm['module_id']
                module_index = algorithm['module_index']
                algorithmStub = filter(lambda algorithmStub: algorithmStub.index == index and algorithmStub.name == name, self.algorithmStubs)[0]
                stack.pop(stack.index(algorithmStub))
                # insert in correct order!
                modules[module_id].append(algorithmStub)
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
            'menu_uuid': self.eventSetup.menuUuid, # HACk
            'firmware_uuid': self.eventSetup.getFirmwareUuid(),
            'n_modules': len(self),
            'algorithms': algorithms,
        }
        json.dump(data, fp, indent=indent)

    def getShadowed(self, stack, conditions, ratio, depth = 1):
        """Returns list of shadowed conditions from a stack of algorithms.
        Attribute *ratio* (0.0 < ratio <= 1.0) regulates the minimum amount of a shadowed algorithm.
        """
        shadowed = []
        a = conditions
        for algorithm in stack:
            if algorithm in shadowed:
                continue
            b = [condition.name for condition in algorithm.conditions]
            # is shadowed at all?
            if (set(a) & set(b)):
                left = len(set(a) & set(b))
                right = len(set(a+b) - (set(a)&set(b)))
                total = left + right
                percent = total/100.
                if not ratio <= (left/percent/100.):
                    continue
                logging.info("%s %s shadowed ratio %.1f %%", " +-" + "-" * depth, algorithm.name, (left/percent))
                shadowed.append(algorithm)
                shadowed += self.getShadowed(set(stack)-set(shadowed), list(set(a+b)), ratio, depth+1)# add recursive....
                shadowed = list(set(shadowed))
        return shadowed

    def __repr__(self):
        count = len(self)
        return "{self.__class__.__name__}(modules={count})".format(**locals())

#
# Application
#

def float_percent(value):
    value = float(value)
    if .0 <= value <= 1.:
        return value
    raise ValueError("percentage value must be within 0.0 and 1.0")

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('filename', metavar='<file>', type=os.path.abspath, help="XML menu")
    parser.add_argument('--config', metavar='<file>', default=DefaultConfigFile, type=os.path.abspath, help="JSON resource configuration file, default {DefaultConfigFile}".format(**globals()))
    parser.add_argument('--modules', metavar='<n>', default=2, type=int, help="number of modules, default is 2")
    parser.add_argument('--ratio', metavar='<f>', default=0.25, type=float, help="algorithm shadow ratio (0.0 < ratio <= 1.0, default 0.25)")
    parser.add_argument('-o', metavar='<file>', type=os.path.abspath, help="write calculated distribution to JSON file")
    parser.add_argument('--list', action='store_true', help="list resource scales and exit")
    return parser.parse_args()

def list_resources(tray):
    logging.info(":: listing resources...")
    def section(name, instance):
        sliceLUTsPercent = instance.sliceLUTs * 100
        processorsPercent = instance.processors * 100
        return "  * {name}: sliceLUTs={sliceLUTsPercent:.2f}%, processors={processorsPercent:.2f}%".format(**locals())
    logging.info("thresholds:")
    logging.info(section("floor", tray.resources.floor))
    logging.info(section("ceiling", tray.resources.ceiling))
    logging.info("instances:")
    for instance in tray.resources.instances:
        object_list = ', '.join(instance.objects)
        name = "{instance.type}({object_list})".format(**locals())
        logging.info(section(name, instance))

def list_algorithms(collection):
    logging.info("|-------------------------------------------------------------------------|")
    logging.info("|                                                                         |")
    logging.info("| Algorithms sorted by payload (descending)                               |")
    logging.info("|                                                                         |")
    logging.info("|-------------------------------------------------------------------------|")
    logging.info("|-------|-----------|--------|--------------------------------------------|")
    logging.info("| Index | SliceLUTs | DSPs   | Name                                       |")
    logging.info("|-------|-----------|--------|--------------------------------------------|")
    for algorithm in collection.algorithmStubs:
        sliceLUTs = algorithm.payload.sliceLUTs * 100.
        processors = algorithm.payload.processors * 100.
        name = short_name(algorithm.name, 42)
        logging.info("| {algorithm.index:>5d} | {sliceLUTs:>8.2f}% | {processors:>5.2f}% | {name:<42} |".format(**locals()))
    logging.info("|-------------------------------------------------------------------------|")

def list_conditions(collection):
    logging.info("|-------------------------------------------------------------------------|")
    logging.info("|                                                                         |")
    logging.info("| Condition payloads by type                                              |")
    logging.info("|                                                                         |")
    logging.info("|-----------------------------||--------------------||--------------------|")
    logging.info("| Condition                   || Item               || Sub total          |")
    logging.info("| Type                | Count || SliceLUTs | DSPs   || SliceLUTs | DSPs   |")
    logging.info("|---------------------|-------||-----------|--------||-----------|--------|")
    totals = Payload()
    total_count = 0
    for typename, conditions in collection.byConditionType().iteritems():
        count = len(conditions)
        total_count += count
        sliceLUTs = conditions[0].payload.sliceLUTs * 100.
        processors = conditions[0].payload.processors * 100.
        all_sliceLUTs = sliceLUTs * count
        all_processors = processors * count
        totals += Payload(all_sliceLUTs, all_processors)
        typename = short_name(typename, 25)
        line = "| {typename:<19} | {count:>5d} || {sliceLUTs:>8.2f}% | {processors:>5.2f}% || {all_sliceLUTs:>8.2f}% | {all_processors:>5.2f}% |".format(**locals())
        logging.info(line)
    logging.info("|---------------------|-------||-----------|--------||-----------|--------|")
    logging.info("| Total               | {total_count:>5d} ||         - |      - || {totals.sliceLUTs:>8.2f}% | {totals.processors:>5.2f}% |".format(**locals()))
    logging.info("|---------------------|-------||-----------|--------||-----------|--------|")

def list_distribution(collection):
    message = "Detailed distribition on {n} modules, shadow ratio: {r:.1f}".format(n=len(collection), r=collection.ratio)
    logging.info("|-------------------------------------------------------------------------|")
    logging.info("|                                                                         |")
    logging.info("| {message:<71} |".format(**locals()))
    logging.info("|                                                                         |")
    logging.info("|------------|------------------------------------------------------------|")
    logging.info("| Module     | Algorithm                                                  |")
    logging.info("| ID | Index | Index | Name                                               |")
    logging.info("|----|-------|-------|----------------------------------------------------|")
    for module in collection:
        indices = sorted(str(algorithm.index) for algorithm in module)
        for algorithm in module:
            name = short_name(algorithm.name, 50)
            line = "| {algorithm.module_id:>2d} | {algorithm.module_index:>5d} " \
                   "| {algorithm.index:>5d} | {name:<50} |".format(**locals())
            logging.info(line)
    logging.info("|----|-------|-------|----------------------------------------------------|")
    logging.info("|-------------------------------------------------------------------------|")
    logging.info("|                                                                         |")
    logging.info("| Condition distribution, sorted by weight (descending)                   |")
    logging.info("|                                                                         |")
    logging.info("|-------------------------------------------------------------------------|")
    logging.info("| Name                                             | Modules              |")
    logging.info("|--------------------------------------------------|----------------------|")
    conditions = sorted(collection.conditions, key=lambda condition: condition.payload, reverse=True)
    for condition in conditions:
        modules = []
        for module in collection:
            if condition in module.conditions:
                modules.append(module.id)
        logging.info("| {name:<48} | {modules:<20} |".format(name=condition.name, modules=','.join([str(module) for module in modules])))
    logging.info("|--------------------------------------------------|----------------------|")

def list_summary(collection):
    message = "Summary for distribution on {n} modules, shadow ratio: {r:.1f}".format(n=len(collection), r=collection.ratio)
    logging.info("|-------------------------------------------------------------------------|")
    logging.info("|                                                                         |")
    logging.info("| {message:<71} |".format(**locals()))
    logging.info("|                                                                         |")
    logging.info("|-----------------|-------------------------------------------------------|")
    logging.info("| Module          | Payload                                               |")
    logging.info("| ID | Algorithms | SliceLUTs | DSPs                                      |")
    logging.info("|----|------------|-----------|-------------------------------------------|")
    for module in collection:
        algorithms = len(module)
        sliceLUTs = module.payload.sliceLUTs * 100.
        processors = module.payload.processors * 100.
        logging.info("| {module.id:>2} | {algorithms:>10} | {sliceLUTs:>8.2f}% " \
                     "| {processors:>5.2f}%                                    |".format(**locals()))
    logging.info("|----|------------|-----------|-------------------------------------------|")

def dump_distribution(collection, args):
    logging.info(":: writing menu distribution JSON dump: %s", args.o)
    with open(args.o, 'wb') as fp:
        collection.dump(fp)

def distribute(eventSetup, modules, config, ratio):
    """Distribution wrapper function, provided for convenience."""
    logging.info("distributing menu...")

    logging.info("loading resource information from JSON: %s", config)
    # Load resource file
    tray = ResourceTray(config)
    # Diagnostic output
    list_resources(tray)

    # Create empty module collection
    collection = ModuleCollection(eventSetup, tray)

    # Diagnostic output
    list_algorithms(collection)
    list_conditions(collection)

    logging.info("distributing algorithms, shadow ratio: %s", ratio)
    collection.distribute(modules, ratio)

    # Diagnostic output
    list_distribution(collection)
    list_summary(collection)

    # Perform some checks
    collection.validate()

    return collection

def main():
    args = parse_args()

    logging.getLogger().setLevel(logging.INFO)

    logging.info("reading event setup from XML menu: %s", args.filename)
    es = tmEventSetup.getTriggerMenu(args.filename)
    es.getMenuUuid = '' # HACK

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

    list_conditions(collection)

    logging.info("distributing algorithms, shadow ratio: %s", args.ratio)
    collection.distribute(args.modules, args.ratio)

    list_distribution(collection)

    list_summary(collection)

    if args.o:
        dump_distribution(collection, args)

    logging.info("done.")

    return 0

if __name__ == '__main__':
    sys.exit(main())
