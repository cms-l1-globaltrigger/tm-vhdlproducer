#
# Repository path   : $HeadURL: $
# Last committed    : $Revision: $
# Last changed by   : $Author: $
# Last changed date : $Date: $
#

# Package
PKG_NAME = tmVhdlProducer

# Directories
PKG_DIR = $(PKG_NAME)
BUILD_DIR = build
RPM_DIST_DIR = dist

# Executables
PYTHON = python
SETUP = $(PYTHON) setup.py
REMOVE = rm -rfv

.PHONY: all build rpm clean distclean

all: build

build:
	$(SETUP) build

rpm: build
	$(SETUP) bdist_rpm

clean:
	$(REMOVE) $(PKG_DIR)
	$(REMOVE) $(BUILD_DIR)

distclean: clean
	$(REMOVE) $(RPM_DIST_DIR)
	$(REMOVE) MANIFEST
