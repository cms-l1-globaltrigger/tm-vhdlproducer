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

-- VHDL producer
-- version: {{ menu.info.sw_version }}
-- hash value: {{ menu.info.sw_hash }}

-- tmEventSetup
-- version: {{ menu.info.version }}

-- Signal definition of pt, eta and phi for correlation conditions.
{%- include  "signals/signal_correlation_conditions_parameter.vhd" %}
-- Signal definition for cuts of correlation conditions.
{%- include  "signals/signal_correlation_cuts.vhd" %}
-- Signal definition for muon charge correlations.
{%- include  "signals/signal_muon_charge_correlations.vhd" %}

-- Signal definition for conditions names
{%- for condition in module.conditions %}
    signal {{ condition.vhdl_signal }} : std_logic;
{%- endfor %}

-- Signal definition for algorithms names
{%- for algorithm in module.algorithms | sort_by_attribute('index') %}
    signal {{ algorithm.vhdl_signal }} : std_logic;
{%- endfor %}

-- ========================================================
