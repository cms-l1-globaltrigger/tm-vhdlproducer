-- ========================================================
-- from VHDL producer:

-- Module ID: {{ module.id }}

-- Name of L1 Trigger Menu:
-- {{ menu.info.name }}

-- Unique ID of L1 Trigger Menu:
-- {{ menu.info.uuid_menu }}

-- Unique ID of firmware implementation:
-- {{ menu.info.uuid_firmware }}

-- Scale set:
-- {{ menu.info.scale_set }}

-- VHDL producer version
-- v{{ menu.info.sw_version }}

-- tmEventSetup version
-- v{{ menu.info.version }}

-- External condition assignment

{%- for condition in module.externalConditions %}
{{ condition.vhdl_signal }} <= ext_cond_bx_{{ condition.objects[0].bx }}({{ condition.objects[0].externalChannelId }}); -- {{ condition.vhdl_signal }}
{%- endfor %}

-- Instantiations of muon charge correlations - only once for a certain bx combination, if there is at least one DoubleMuon, TripleMuon, QuadMuon condition
-- or muon-muon correlation condition.
{% include "instances/muon_charge_correlations.vhd" %}
-- Instantiations of eta and phi conversion to muon scale for calo-muon and muon-esums correlation conditions (used for DETA, DPHI, DR and mass)
{% include "instances/correlation_conditions_eta_phi_conversion.vhd" %}
-- Instantiations of pt, eta, phi, cosine phi and sine phi for correlation conditions (used for DETA, DPHI, DR, mass, overlap_remover and two-body pt)
{% include "instances/obj_parameter.vhd" %}
-- Instantiations of deta and dphi calculations for correlation conditions (used for DETA, DPHI)
{% include "instances/deta_dphi_calculations.vhd" %}
-- Instantiations of deta, dphi, cosh deta and cos dphi LUTs for correlation conditions (used for DR and mass)
--
{% include "instances/correlation_cuts_calculations.vhd" %}

-- Instantiations of conditions
--
{%- for condition in module.caloConditions %}
{% include "instances/calo_condition.vhd" %}
{% endfor %}
{%- for condition in module.caloConditionsOvRm %}
{% include "instances/calo_conditions_orm.vhd" %}
{% endfor %}
{%- for condition in module.muonConditions %}
{% include "instances/muon_condition.vhd" %}
{% endfor %}
{%- for condition in module.esumsConditions %}
{% include "instances/esums_condition.vhd" %}
{% endfor %}
{%- for condition in module.caloCaloCorrConditions %}
{% include "instances/calo_calo_correlation_condition.vhd" %}
{% endfor %}
{%- for condition in module.caloCaloCorrOvRmConditions %}
{% include "instances/calo_calo_correlation_condition_orm.vhd" %}
{% endfor %}
{%- for condition in module.caloMuonCorrConditions %}
{% include "instances/calo_muon_correlation_condition.vhd" %}
{% endfor %}
{%- for condition in module.muonMuonCorrConditions %}
{% include "instances/muon_muon_correlation_condition.vhd" %}
{% endfor %}
{%- for condition in module.caloEsumCorrConditions %}
{% include "instances/calo_esums_correlation_condition.vhd" %}
{% endfor %}
{%- for condition in module.muonEsumCorrConditions %}
{% include "instances/muon_esums_correlation_condition.vhd" %}
{% endfor %}
{%- for condition in module.caloCorr3Conditions %}
{% include "instances/calo_mass_3_obj_condition.vhd" %}
{% endfor %}
{%- for condition in module.muonCorr3Conditions %}
{% include "instances/muon_mass_3_obj_condition.vhd" %}
{% endfor %}
{%- for condition in module.minBiasConditions %}
{% include "instances/min_bias_hf_condition.vhd" %}
{% endfor %}
{%- for condition in module.towerCountConditions %}
{% include "instances/towercount_condition.vhd" %}
{% endfor %}
{%- for condition in module.signalConditions %}
{% include "instances/signal_condition.vhd" %}
{% endfor %}

-- Instantiations of algorithms

{% for algorithm in module.algorithms | sort_by_attribute('index') %}
-- {{ algorithm.index }} {{ algorithm.name }} : {{ algorithm.expression }}
{{ algorithm.vhdl_signal }} <= {{ algorithm.vhdl_expression }};
algo({{ algorithm.module_index | d }}) <= {{ algorithm.vhdl_signal }};
{% endfor %}

-- ========================================================
