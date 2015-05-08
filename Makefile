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
TPL_SRC_DIR = templates
BUILD_DIR = build
RPM_DIST_DIR = dist

# Templates to be compiled into resource file.
TEMPLATES = \
	$(TPL_SRC_DIR)/algo_mapping_rop.vhd \
	$(TPL_SRC_DIR)/assignment_a_a_f.vhd \
	$(TPL_SRC_DIR)/assignment_a_a_p.vhd \
	$(TPL_SRC_DIR)/assignment_a_b_p.vhd \
	$(TPL_SRC_DIR)/assignment_finor_mask.vhd \
	$(TPL_SRC_DIR)/assignment_finor_veto_masks.vhd \
	$(TPL_SRC_DIR)/assignment_prescale_factor.vhd \
	$(TPL_SRC_DIR)/assignment_veto_mask.vhd \
	$(TPL_SRC_DIR)/gtl_module.vhd \
	$(TPL_SRC_DIR)/gtl_pkg.vhd \
	$(TPL_SRC_DIR)/instance_algorithm.vhd \
	$(TPL_SRC_DIR)/instance_calo_calo_correlation_condition.vhd \
	$(TPL_SRC_DIR)/instance_calo_condition_v2.vhd \
	$(TPL_SRC_DIR)/instance_calo_condition.vhd \
	$(TPL_SRC_DIR)/instance_calo_esums_correlation_condition.vhd \
	$(TPL_SRC_DIR)/instance_calo_muon_correlation_condition.vhd \
	$(TPL_SRC_DIR)/instance_delta_r_condition.vhd \
	$(TPL_SRC_DIR)/instance_difference_eta_corr.vhd \
	$(TPL_SRC_DIR)/instance_difference_eta_wsc.vhd \
	$(TPL_SRC_DIR)/instance_difference_phi_corr.vhd \
	$(TPL_SRC_DIR)/instance_difference_phi_wsc.vhd \
	$(TPL_SRC_DIR)/instance_esums_condition.vhd \
	$(TPL_SRC_DIR)/instance_eta_phi_conversion_muon.vhd \
	$(TPL_SRC_DIR)/instance_eta_phi_conversion.vhd \
	$(TPL_SRC_DIR)/instance_invariant_mass.vhd \
	$(TPL_SRC_DIR)/instance_muon_charge_correlations.vhd \
	$(TPL_SRC_DIR)/instance_muon_charges.vhd \
	$(TPL_SRC_DIR)/instance_muon_condition.vhd \
	$(TPL_SRC_DIR)/instance_muon_esums_correlation_condition.vhd \
	$(TPL_SRC_DIR)/signal_algorithm.vhd \
	$(TPL_SRC_DIR)/signal_condition.vhd \
	$(TPL_SRC_DIR)/signal_differences_corr.vhd \
	$(TPL_SRC_DIR)/signal_differences_wsc.vhd \
	$(TPL_SRC_DIR)/signal_eta_phi.vhd \
	$(TPL_SRC_DIR)/signal_muon_charge_correlations.vhd \
	$(TPL_SRC_DIR)/signal_muon_charges.vhd \
	$(TPL_SRC_DIR)/tb_invariant_mass.vhd

# Resource file
TEMPLATE_RC = $(PKG_DIR)/template_rc.py

# Executables
PYTHON = python
SETUP = $(PYTHON) setup.py
REMOVE = rm -rfv
TPL_RCC = utils/tplrcc

.PHONY: all build rpm clean distclean

all: build

build: $(TEMPLATE_RC)

$(TEMPLATE_RC): $(TEMPLATES)
	$(TPL_RCC) $(TEMPLATES) $@

rpm: build
	$(SETUP) bdist_rpm

clean:
	$(REMOVE) $(PKG_DIR)
	$(REMOVE) $(BUILD_DIR)

distclean: clean
	$(REMOVE) $(RPM_DIST_DIR)
	$(REMOVE) MANIFEST
