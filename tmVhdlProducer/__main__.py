import argparse
import glob
import hashlib
import logging
import os
import re
import subprocess
import sys
from typing import Dict, List

import tmEventSetup
import tmReporter

from . import __version__
from .algodist import ProjectDir
from .algodist import distribute, constraint_t
from .algodist import MinModules, MaxModules
from .algodist import kExternals, kZDCPlus, kZDCMinus
from .algodist import DefaultConfigFile
from .vhdlproducer import VhdlProducer

EXIT_SUCCESS: int = 0
EXIT_FAILURE: int = 1
LOGFILE: str = 'tm-vhdlproducer.log'
EXEC_REPORTER: str = 'tm-reporter'

SortingAsc: str = 'asc'
SortingDesc: str = 'desc'

DefaultModuleZdc: int = 0
DefaultNrModules: int = 6
DefaultRatio: float = 0.0
DefaultSorting: str = SortingDesc
DefaultOutputDir: str = os.getcwd()

ConstraintTypes: Dict[str, List[str]] = {
    'ext': [kExternals],
    'zdc': [kZDCPlus, kZDCMinus],
}
"""Mapping constraint types to esCondition types, provided for convenience."""

# -----------------------------------------------------------------------------
#  Helpers
# -----------------------------------------------------------------------------

def modules_t(value: str) -> int:
    """Validate number of modules input."""
    modules = int(value)
    if 1 <= modules <= MaxModules:
        return modules
    raise ValueError(modules)

def dist_t(value: str) -> int:
    """Validate firmware distribution number."""
    dist = int(value)
    if 1 <= dist:
        return dist
    raise ValueError(dist)

def ratio_t(value: str) -> float:
    """Validates shadow ratio input."""
    ratio = float(value)
    if .0 <= ratio <= 1.:
        return ratio
    raise ValueError(ratio)

def calc_sw_hash(path: str) -> str:
    """Calculate a SHA-256 hash value of the content of all source files at given path."""
    filenames = []
    # Collect all python modules and VHDL templates
    for pattern in ["**/*.py", "templates/vhdl/**/*.vhd"]:
        for filename in glob.glob(os.path.join(path, pattern), recursive=True):
            filenames.append(filename)

    hash_sha256 = hashlib.sha256()
    # Sort filenames for deterministic hash
    for filename in sorted(filenames):
        with open(filename, "rb") as f:
            while True:
                # Reading is buffered, so we can read smaller chunks.
                chunk = f.read(hash_sha256.block_size)
                if not chunk:
                    break
                hash_sha256.update(chunk)
    return hash_sha256.hexdigest()

# -----------------------------------------------------------------------------
#  Command line parser
# -----------------------------------------------------------------------------

def parse_args():
    """Parse command line options."""
    parser = argparse.ArgumentParser(
        prog='tm-vhdlproducer',
        description="Trigger Menu VHDL Producer for uGT upgrade",
        epilog="Report bugs to <bernhard.arnold@cern.ch>"
    )
    parser.add_argument('menu',
        type=os.path.abspath,
        help="XML menu file to be loaded"
    )
    parser.add_argument('--modules',
        metavar='<n>',
        type=modules_t,
        default=DefaultNrModules,
        help=f"number of modules ({MinModules}-{MaxModules}, default is {DefaultNrModules}))"
    )
    parser.add_argument('-d', '--dist',
        metavar='<n>',
        required=True,
        type=dist_t,
        help="firmware distribution number (starting with 1)"
    )
    parser.add_argument('--ratio',
        metavar='<f>',
        default=DefaultRatio,
        type=ratio_t,
        help=f"algorithm shadow ratio (0.0 < ratio <= 1.0, default is {DefaultRatio})"
    )
    parser.add_argument('--sorting',
        metavar='asc|desc',
        default=DefaultSorting,
        choices=(SortingAsc, SortingDesc),
        help=f"sort order for condition weights ({SortingAsc} or {SortingDesc}, default is {DefaultSorting})"
    )
    parser.add_argument('--config',
        metavar='<file>',
        default=DefaultConfigFile,
        type=os.path.abspath,
        help=f"JSON resource configuration file (default is {DefaultConfigFile})"
    )
    parser.add_argument('--constraint',
        metavar='<condition:modules>',
        action='append',
        type=constraint_t,
        help=f"limit condition type to a specific module, valid types are: {', '.join(ConstraintTypes)}"
    )
    parser.add_argument('-o', '--output',
        metavar='<dir>',
        default=DefaultOutputDir,
        type=os.path.abspath,
        help=f"directory to write VHDL producer output (default is {DefaultOutputDir})"
    )
    parser.add_argument('--dryrun',
        action='store_true',
        help="do not write any output to the file system"
    )
    parser.add_argument("--verbose",
        dest="verbose",
        action="store_true",
    )
    parser.add_argument('--version',
        action='version',
        version=f"L1 Trigger Menu VHDL producer version {__version__}"
    )
    return parser.parse_args()

# -----------------------------------------------------------------------------
#  Main routine
# -----------------------------------------------------------------------------

def main() -> int:
    """Main routine."""
    args = parse_args()

    # Setup console logging
    level = logging.DEBUG if args.verbose else logging.INFO
    logging.basicConfig(format='%(levelname)s: %(message)s', level=level)

    logging.info("running VHDL producer...")

    sw_hash = calc_sw_hash(os.path.dirname(__file__))
    logging.info("version: %s", __version__)
    logging.info("hash: %s", sw_hash)

    logging.info("loading XML menu: %s", args.menu)
    eventSetup = tmEventSetup.getTriggerMenu(args.menu)
    output_dir = os.path.join(args.output, f"{eventSetup.getName()}-d{args.dist}")

    # Prevent overwirting source menu
    dest = os.path.realpath(os.path.join(output_dir, 'xml'))
    orig = os.path.dirname(os.path.realpath(args.menu))
    if dest == orig:
        logging.error("%s is in %s directory which will be overwritten during the process", args.menu, dest)
        logging.error("     specified menu not in %s directory", dest)
        return EXIT_FAILURE

    if not args.dryrun:
        if os.path.isdir(output_dir):
            logging.error("directory `%s' already exists", output_dir)
            return EXIT_FAILURE
        else:
            os.makedirs(output_dir)

    if not args.dryrun:
        # Forward logs to file
        handler = logging.FileHandler(os.path.join(output_dir, LOGFILE), mode='a')
        handler.setFormatter(logging.Formatter(fmt='%(asctime)s %(levelname)s : %(message)s', datefmt='%Y-%m-%d %H:%M:%S'))
        handler.setLevel(level)
        logging.getLogger().addHandler(handler)

    # Distribute algorithms, set sort order (asc or desc)
    reverse_sorting = (args.sorting == 'desc')
    # Collect condition constraints
    constraints = {}
    # Note: args.constraint is None if not used.
    if args.constraint:
        for alias, module in args.constraint:
            if alias not in ConstraintTypes:
                raise ValueError(f"no such constraint: {alias!r}")
            for key in ConstraintTypes[alias]:
                constraints[key] = module

    # Default constraint for ZDC
    constraints.setdefault(kZDCMinus, [DefaultModuleZdc])
    constraints.setdefault(kZDCPlus, [DefaultModuleZdc])

    # Run distibution
    collection = distribute(
        eventSetup=eventSetup,
        modules=args.modules,
        config=args.config,
        ratio=args.ratio,
        reverse_sorting=reverse_sorting,
        constraints=constraints
    )

    if args.dryrun:
        logging.info("skipped writing output (dryrun mode)")
    else:

        logging.info("writing VHDL modules...")
        template_dir = os.path.join(ProjectDir, 'templates', 'vhdl')
        producer = VhdlProducer(template_dir)
        producer.config.update({"sw_hash": sw_hash})
        producer.write(collection, output_dir)
        logging.info("writing updated XML file %s", args.menu)

        filename = producer.writeXmlMenu(args.menu, os.path.join(output_dir, 'xml'), args.dist) # TODO

        # Write menu documentation.
        logging.info("generating menu documentation...")
        doc_dir = os.path.join(output_dir, 'doc')

        logging.info("writing HTML documentation %s", filename)
        subprocess.check_call([EXEC_REPORTER, '-m', 'html', '-o', doc_dir, filename])

        logging.info("writing TWIKI page template %s", filename)
        subprocess.check_call([EXEC_REPORTER, '-m', 'twiki', '-o', doc_dir, filename])

        logging.info("patching filenames...")
        for filename in glob.glob(os.path.join(doc_dir, '*')):
            newname = re.sub(r'(.+)\.([a-z]+)$', rf'\1-d{args.dist}.\2', filename)
            logging.info("%s --> %s", filename, newname)
            os.rename(filename, newname)

    logging.info("done.")

    return EXIT_SUCCESS

if __name__ == '__main__':
    sys.exit(main())
