tmVhdlProducer - Trigger Menu VHDL Producer
===========================================

Dependecies
-----------

* python-argparse
* python-jinja
* tmEventSetup
* tmTable
* tmXsd

Build locally
-------------

$ source ../setup.sh
$ make

Running the makefile ir required to build the resource python module containing
the HTML templates to be used by the template engine.

Synopsis
--------

$ tm-vhdl-producer <filename>

Building RPMs
-------------

$ make rpm
