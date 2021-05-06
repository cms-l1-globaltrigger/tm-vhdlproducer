import argparse
import glob
import logging
import re
import subprocess
import sys, os

import tmEventSetup
import tmReporter

from .vhdlproducer import VhdlProducer
from .algodist import ProjectDir
from .algodist import distribute, constraint_t
from .algodist import MinModules, MaxModules
from .algodist import kExternals
from . import __version__

EXIT_SUCCESS = 0
EXIT_FAILURE = 1
LOGFILE = 'tm-vhdlproducer.log'
EXEC_REPORTER = 'tm-reporter'

SortingAsc = 'asc'
SortingDesc = 'desc'

DefaultRatio = 0.0
DefaultSorting = SortingAsc
DefaultOutputDir = os.getcwd()
from .algodist import DefaultConfigFile

ConstraintTypes = {
    'ext': kExternals,
}
"""Mapping constraint types to esCondition types, provided for convenience."""

# -----------------------------------------------------------------------------
#  Helpers
# -----------------------------------------------------------------------------

def modules_t(value):
    """Validate number of modules input."""
    value = int(value)
    if 1 <= value <= MaxModules:
        return value
    raise ValueError(value)

def dist_t(value):
    """Validate firmware distribution number."""
    value = int(value)
    if 1 <= value:
        return value
    raise ValueError(value)

def ratio_t(value):
    """Validates shadow ratio input."""
    value = float(value)
    if .0 <= value <= 1.:
        return value
    raise ValueError(value)

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
        required=True,
        type=modules_t,
        help=f"number of modules ({MinModules}-{MaxModules})"
    )
    parser.add_argument('--dist',
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
    parser.add_argument('--output',
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

def main():
    """Main routine."""
    args = parse_args()

    # Setup console logging
    level = logging.DEBUG if args.verbose else logging.INFO
    logging.basicConfig(format='%(levelname)s: %(message)s', level=level)

    logging.info("running VHDL producer...")

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
    if args.constraint:
        for k, v in args.constraint:
            constraints[ConstraintTypes[k]] = v
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
