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
{%- include  "instances/muon_charge_correlations.vhd.j2" %}
-- Instantiations of eta and phi conversion to muon scale for calo-muon and muon-esums correlation conditions (used for DETA, DPHI, DR and mass) - once for every calo ObjectType in certain Bx used in correlation conditions
{%- include  "instances/correlation_conditions_eta_phi_conversion.vhd.j2" %}
-- Instantiations of pt, eta, phi, cos-phi and sin-phi for correlation conditions (used for DETA, DPHI, DR, mass, overlap_remover and b_tagging) - once for every ObjectType in certain Bx used in correlation conditions
{%- include  "instances/correlation_conditions_pt_eta_phi_cos_sin_phi.vhd.j2" %}
-- Instantiations of differences for correlation conditions (used for DETA, DPHI, DR, mass and b_tagging) - once for correlation conditions with two ObjectTypes in certain Bxs
{%- include  "instances/correlation_conditions_differences.vhd.j2" %}
-- Instantiations of cosh-deta and cos-dphi LUTs for correlation conditions (used for mass and overlap_remover) - once for correlation conditions with two ObjectTypes in certain Bxs
{%- include  "instances/correlation_conditions_mass_cuts.vhd.j2" %}
-- Instantiations of conditions
{%- for condition in module.caloConditions %}
{%- include  "instances/calo_condition_v5.vhd.j2" %}
{%- endfor %}

{%- for condition in module.caloConditionsOvRm %}
{%- include  "instances/calo_conditions_orm.vhd.j2" %}
{%- endfor %}

{%- for condition in module.muonConditions %}
{%- include  "instances/muon_condition_v5.vhd.j2" %}
{%- endfor %}

{%- for condition in module.esumsConditions %}
{%- include  "instances/esums_condition.vhd.j2" %}
{%- endfor %}

{%- for condition in module.caloCaloCorrConditions %}
{%- include  "instances/calo_calo_correlation_condition_v2.vhd.j2" %}
{%- endfor %}

{%- for condition in module.caloCaloCorrOvRmConditions %}
{%- include  "instances/calo_calo_calo_correlation_orm_condition.vhd.j2" %}
{%- endfor %}

{%- for condition in module.caloMuonCorrConditions %}
{%- include  "instances/calo_muon_correlation_condition_v2.vhd.j2" %}
{%- endfor %}

{%- for condition in module.muonMuonCorrConditions %}
{%- include  "instances/muon_muon_correlation_condition_v2.vhd.j2" %}
{%- endfor %}

{%- for condition in module.caloEsumCorrConditions %}
{%- include  "instances/calo_esums_correlation_condition_v2.vhd.j2" %}
{%- endfor %}

{%- for condition in module.muonEsumCorrConditions %}
{%- include  "instances/muon_esums_correlation_condition_v2.vhd.j2" %}
{%- endfor %}

{%- for condition in module.minBiasConditions %}
{%- include  "instances/min_bias_hf_condition.vhd.j2" %}
{%- endfor %}

{%- for condition in module.towerCountConditions %}
{%- include  "instances/towercount_condition.vhd.j2" %}
{%- endfor %}

-- Instantiations of algorithms
{% for algorithm in module.algorithms|sort_by_attribute('index') %}
-- {{ algorithm.index }} {{ algorithm.name }} : {{ algorithm.expression }}
{{ algorithm.vhdl_signal }} <= {{ algorithm.vhdl_expression }};
algo({{ algorithm.module_index | d}}) <= {{ algorithm.vhdl_signal }};
{% endfor %}

-- ========================================================
