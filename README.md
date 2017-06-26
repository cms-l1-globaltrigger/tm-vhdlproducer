VHDL Producer
=============


## Basic usage

Generate VHDL output from XML trigger menu.

    $ tm-vhdlproducer [--modules <n>] [--ratio <f>] [--sorting asc|desc]
                      [--constraint <type:modules>] [--dryrun] <menu>


### Distribute to multiple modules

Example for distributing on two modules:

    $ tm-vhdlproducer L1Menu_sample.xml --modules 2

This will create a directory L1Menu_sample/ in the current directory.


### Specify sort order for algorithm distribution

Example for reversing algorithm distribution descending order (default ascending):

    $ tm-vhdlproducer L1Menu_sample.xml --modules 2 --sorting desc

This will distribute algorithms from high to low payload weight.


### Specifiying output location

To specifiy a different output location use the --outdir flag. For example

    $ tm-vhdlproducer L1Menu_sample.xml --modules 2 --outdir /tmp

will write the output to /tmp/L1Menu_sample/.


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


### Condition constraints

To limit certain condition types to a subset of modules (or just a single
module) use the --constraint argument. Limit a condition type to a single module

    $ tm-vhdlproducer L1Menu_sample.xml --modules 2 --constraint ext:0  # limit external conditions to module 0

or to a subset of modules

    $ tm-vhdlproducer L1Menu_sample.xml --modules 2 --constraint ext:2,4-6  # limit external conditions to modules 2, 4, 5 and 6


### Dryrun

To try out different optimizations use the --dryrun flag to prevent writing
output to the filesystem.

    $ tm-vhdlproducer L1Menu_sample.xml --modules 2 --ratio 0 --dryrun


## Generated output

    L1Menu_sample/
     +-- doc/
     |    +-- L1Menu_sample.html
     |    `-- L1Menu_sample.twiki
     +-- testvectors/
     +-- vhdl/
     |    +-- module_0/
     |    |    `-- src/
     |    |         `-- *.vhd
     |    `-- ...
     +-- xml/
     |    `-- L1Menu_sample.xml
     `-- tm-vhdlproducer.log


## Documentation

A TWiki page template and a HTML menu ducumentation is also written to the
doc/ directory in the output location.


## Logging

All messages printed to the screen are written to a log file in the output
location (e.g. L1Menu_sample/tm-vhdlproducer.log).
