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

-- External condition assignment
{%- for condition in module.externalConditions %}
    {{ condition.vhdl_signal }} <= ext_cond_bx_{{ condition.objects[0].bx }}({{ condition.objects[0].externalChannelId }}); -- {{ condition.vhdl_signal }}
{%- endfor %}

-- Instantiations of muon charge correlations - only once for a certain Bx combination, if there is at least one DoubleMuon, TripleMuon, QuadMuon condition
-- or muon-muon correlation condition.
{%- include  "subTemplates/muon_charge_correlations.vhd.j2" %}

-- Instantiations of pt, eta and phi for correlation conditions (used for DETA, DPHI and DR) - once for every ObjectType in certain Bx used in correlation conditions
{%- include  "subTemplates/correlation_conditions_pt_eta_phi.vhd.j2" %}

-- Instantiations of eta and phi conversion to muon scale for calo-muon and muon-esums correlation conditions (used for DETA, DPHI and DR) - once for every calo ObjectType in certain Bx used in correlation conditions
{%- include  "subTemplates/correlation_conditions_eta_phi_conversion.vhd.j2" %}

-- Instantiations of differences for correlation conditions (used for DETA, DPHI and DR) - once for correlation conditions with two ObjectTypes in certain Bxs
{%- include  "subTemplates/correlation_conditions_differences.vhd.j2" %}

-- Instantiations of cosh-deta and cos-dphi LUTs for correlation conditions (used for invariant mass) - once for correlation conditions with two ObjectTypes in certain Bxs
{%- include  "subTemplates/correlation_conditions_inv_mass.vhd.j2" %}

-- Instantiations of conditions
{%- for condition in module.caloConditions %}
{%- include  "subTemplates/calo_condition_v3.vhd.j2" %}
{%- endfor %}

{%- for condition in module.muonConditions %}
{%- include  "subTemplates/muon_condition_v3.vhd.j2" %}
{%- endfor %}

{%- for condition in module.esumsConditions %}
{%- include  "subTemplates/esums_condition.vhd.j2" %}
{%- endfor %}

{%- for condition in module.caloCaloCorrConditions %}
{%- include  "subTemplates/calo_calo_correlation_condition.vhd.j2" %}
{%- endfor %}

{%- for condition in module.caloMuonCorrConditions %}
{%- include  "subTemplates/calo_muon_correlation_condition.vhd.j2" %}
{%- endfor %}

{%- for condition in module.muonMuonCorrConditions %}
{%- include  "subTemplates/muon_muon_correlation_condition.vhd.j2" %}
{%- endfor %}

{%- for condition in module.caloEsumCorrConditions %}
{%- include  "subTemplates/calo_esums_correlation_condition.vhd.j2" %}
{%- endfor %}

{%- for condition in module.muonEsumCorrConditions %}
{%- include  "subTemplates/muon_esums_correlation_condition.vhd.j2" %}
{%- endfor %}

{%- for condition in module.minBiasConditions %}
{%- include  "subTemplates/min_bias_hf_condition.vhd.j2" %}
{%- endfor %}

{%- for condition in module.towerCountConditions %}
{%- include  "subTemplates/towercount_condition.vhd.j2" %}
{%- endfor %}

-- Instantiations of algorithms
{% for algorithm in module.algorithms|sort_by_attribute('index') %}
-- {{ algorithm.index }} {{ algorithm.name }} : {{ algorithm.expression }}
{{ algorithm.vhdl_signal }} <= {{ algorithm.vhdl_expression }};
algo({{ algorithm.module_index | d}}) <= {{ algorithm.vhdl_signal }};
{% endfor %}

-- ========================================================