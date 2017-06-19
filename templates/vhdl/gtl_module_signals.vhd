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

-- Signal definition of pt, eta and phi for correlation conditions.
-- Insert "signal_correlation_conditions_pt_eta_phi_cos_sin_phi.vhd.j2" as often as an ObjectType at a certain Bx is used in a correlation condition.
{%- include  "signals/signal_correlation_conditions_pt_eta_phi_cos_sin_phi.vhd.j2" %}
-- Signal definition of differences for correlation conditions.
-- Insert "signal_correlation_conditions_differences.vhd.j2" once for correlation conditions of different ObjectTypes and Bx combinations.
{%- include  "signals/signal_correlation_conditions_differences.vhd.j2" %}
-- Signal definition for muon charge correlations.
-- Insert "signal_muon_charge_correlations.vhd.j2" only once for a certain Bx combination,
-- if there is at least one muon condition or one muon-muon correlation condition.
{%- include  "signals/signal_muon_charge_correlations.vhd.j2" %}

-- Signal definition for conditions names
{%- for condition in module.conditions %}
    signal {{ condition.vhdl_signal }} : std_logic;
{%- endfor %}

-- Signal definition for algorithms names
{%- for algorithm in module.algorithms|sort_by_attribute('index') %}
    signal {{ algorithm.vhdl_signal }} : std_logic;
{%- endfor %}

-- ========================================================
