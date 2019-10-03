VHDL Producer
=============

## Basic usage

Generate VHDL output from XML trigger menu.

```
tm-vhdlproducer --modules <n> --dist <n> [--ratio <f>]
                  [--sorting asc|desc] [--constraint <type:modules>]
                  [--dryrun] <menu>
```

### Distribute to multiple modules

Example for distributing on two modules:

```bash
tm-vhdlproducer L1Menu_sample.xml --modules 2 --dist 1
```

This will create a directory `L1Menu_sample-d1/` in the current directory.

### Specifying distribution number

To specify the distribution number use the `--dist` flag. For example

```bash
tm-vhdlproducer L1Menu_sample.xml --modules 2 --dist 2  # set distribution number to 2
```

will write the output to /tmp/L1Menu_sample-d2/.

### Specify sort order for algorithm distribution

Example for reversing algorithm distribution descending order (default ascending):

```bash
tm-vhdlproducer L1Menu_sample.xml --modules 2 --dist 1 --sorting desc
```

This will distribute algorithms from high to low payload weight.

### Specifying output location

To specify a different output location use the `--output` flag. For example

```bash
tm-vhdlproducer L1Menu_sample.xml --modules 2 --dist 1 --output /tmp
```

will write the output to /tmp/L1Menu_sample-d1/.

## Optimizations

### Shadow ratio

Adjust the shadow ratio to optimize the distribution of algorithms. A good
starting point is a ratio between 0.0 and 0.25, although it depends heavily on
the individual menu's content.

The shadow ratio controls what algorithms will be packed together in a module.
Using a ratio of 0.5 means that all algorithms that contain at least 50 % of
the same condition instances will be placed on the same module. Practical tests
showed that this approach does not guarantee the most efficient distribution
and should be used carefully (consider it as experimental). It is advised to
start with a ratio of 0.0 and verify if higher ratios (up to 0.25) improve the
chip resource usage.

```bash
tm-vhdlproducer L1Menu_sample.xml --modules 2 --dist 1 --ratio .25  # set ratio to 0.25
```

### Condition constraints

To limit certain condition types to a subset of modules (or just a single
module) use the `--constraint` argument. Limit a condition type to a single module

```bash
tm-vhdlproducer L1Menu_sample.xml --modules 2 --dist 1 --constraint ext:0  # limit external conditions to module 0
```

or to a subset of modules

```bash
tm-vhdlproducer L1Menu_sample.xml --modules 2 --dist 1 --constraint ext:2,4-6  # limit external conditions to modules 2, 4, 5 and 6
```

### Dryrun

To try out different optimizations use the `--dryrun` flag to prevent writing
output to the filesystem.

```bash
tm-vhdlproducer L1Menu_sample.xml --modules 2 --dist 1 --dryrun
```

## Generated output

```
L1Menu_sample-d1/
 +-- doc/
 |    +-- L1Menu_sample-d1.html
 |    `-- L1Menu_sample-d1.twiki
 +-- testvectors/
 +-- vhdl/
 |    +-- module_0/
 |    |    `-- src/
 |    |         `-- *.vhd
 |    `-- ...
 +-- xml/
 |    `-- L1Menu_sample-d1.xml
 `-- tm-vhdlproducer.log
```

## Dependencies

Install following utm wheels or build utm python bindings.

 * [`tm-eventsetup>=0.7.3`](https://github.com/cms-l1-globaltrigger/tm-eventsetup)
 * [`tm-grammar>=0.7.3`](https://github.com/cms-l1-globaltrigger/tm-grammar)
 * [`tm-table>=0.7.3`](https://github.com/cms-l1-globaltrigger/tm-table)

Install required utm tools.

 * [`tm-reporter>=2.7.0`](https://github.com/cms-l1-globaltrigger/tm-reporter)

## Install

Install using pip

```bash
pip install git+https://github.com/cms-l1-globaltrigger/tm-vhdlproducer.git@2.7.0
```

Install from local source

```bash
git clone https://gitlab.cern.ch/cms-l1-globaltrigger/tm-vhdlproducer.git
cd tm-vhdlproducer
python setup.py install
```

## Documentation

A TWiki page template and a HTML menu ducumentation is also written to the
`doc/` directory in the output location.

## Logging

All messages printed to the screen are written to a log file in the output
location (e.g. `L1Menu_sample/tm-vhdlproducer.log`).
