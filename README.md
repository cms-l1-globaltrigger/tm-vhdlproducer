VHDL Producer
=============

## Dependecies

CC7:

    $ sudo yum install python python-jinja2

Debian/Ubuntu:

    $ sudo apt-get install python python-jinja2

Required utm components are:

 * tmEventSetup
 * tmGrammar
 * tmTable
 * tmXsd
 * tmUtil


## Setup environment

    $ source ../setup.sh


## Synopsis

Generate VHDL output from XML trigger menu.

    $ tm-vhdlproducer [--modules <n>] [--ratio <f>] [--dryrun] <menu>


### Distribute to multiple modules

Example for distributing on two modules:

    $ tm-vhdlproducer L1Menu_sample.xml --modules 2

This will create a directory L1Menu_sample/ in the current directory.


### Specifiying output location

To specifiy a different output location use the --outdir flag. For example

    $ tm-vhdlproducer L1Menu_sample.xml --modules 2 --outdir /tmp

will write the output to /tmp/L1Menu_sample/.


## Optimizations

Adjust the shadow ratio to optimize the distribution of algorithms. A good
starting point is a ratio between 0.0 and 0.25, although it depends heavily on
the individual menu's content.

The shadow ratio controls what algorithms will be packed together in a module.
Using a ratio of 0.5 means that all algorithms that contain at least 50 % of
the same condition instances will be placed on the same module. Preactical tests
showed that this approach does not guarantee the most efficient distribution
and should be used carefully (consider it as experimental). It is advised to
start with a ratio of 0.0 and verify if higher ratios (up to 0.25) improve the
chip resource usage.

To try out different optimizations use the --dryrun flag to prevent writing
output to the filesystem.

    $ tm-vhdlproducer L1Menu_sample.xml --modules 2 --ratio 0 --dryrun


## Logging

All messages printed to the screen are written to a log file in the output
location (e.g. L1Menu_samle/tm-vhdlproducer.log).
