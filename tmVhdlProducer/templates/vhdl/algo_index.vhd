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

-- VHDL producer repo 
{%- if menu.info.branch_name == "" %}
-- tag version: {{ menu.info.sw_version }}
{%- else %}
-- branch version: {{ menu.info.sw_version }}
-- branch name: {{ menu.info.branch_name }}
-- branch hash value: {{ menu.info.branch_hash }}
{%- endif %}

-- tmEventSetup
-- version: {{ menu.info.version }}

-- HB 2016-09-16: constants for algo_mapping_rop.
type global_index_array is array (0 to NR_ALGOS-1) of integer;
constant global_index: global_index_array := (
{#-- list mapping of global to local algorithm indices #}
{%- for algorithm in module | sort_by_attribute('module_index') %}
        {{ "%3d" | format(algorithm.index) }}, -- module_index: {{ loop.index0 }}, name: {{ algorithm.name }}
{%- endfor %}
    others => 0
);

-- ========================================================
