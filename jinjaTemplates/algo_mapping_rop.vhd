-- ==== Inserted by TME - begin =============================================================================================================

--- NAVID ---
######### Module #: {{iMod}}
--- NAVID ---

algo_after_finor_mask_rop_int <= (
{%- for algoName in menu.reporter['index_sorted'] %}
{%- set algoDict = menu.reporter['algoDict'][algoName] %}
{%- set algoIndex = algoDict["index"] %}
{%- if algoIndex in menu.reporter['m2a'][iMod]%}
{%- set localAlgoIndex = menu.reporter['m2a'][iMod].index(algoIndex) %}
{{algoIndex}} => a_a_f({{localAlgoIndex}}),
{%-endif%}
{%-endfor%}
others => '0');


algo_after_finor_mask_rop_int <= (
{%- for algoName in menu.reporter['index_sorted'] %}
{%- set algoDict = menu.reporter['algoDict'][algoName] %}
{%- set algoIndex = algoDict["index"] %}
{%- if algoIndex in menu.reporter['m2a'][iMod]%}
{%- set localAlgoIndex = menu.reporter['m2a'][iMod].index(algoIndex) %}
{{algoIndex}} => a_a_f({{localAlgoIndex}}),
{%-endif%}
{%-endfor%}
others => '0');


algo_after_finor_mask_rop_int <= (
{%- for algoName in menu.reporter['index_sorted'] %}
{%- set algoDict = menu.reporter['algoDict'][algoName] %}
{%- set algoIndex = algoDict["index"] %}
{%- if algoIndex in menu.reporter['m2a'][iMod]%}
{%- set localAlgoIndex = menu.reporter['m2a'][iMod].index(algoIndex) %}
{{algoIndex}} => a_a_f({{localAlgoIndex}}),
{%-endif%}
{%-endfor%}
others => '0');

{#-{AlgoIndexRop:d} => a_a_f({AlgoIndexGtl:d}),#}
{#-      algo_before_prescaler_rop_int <= ({AssignmentAbp} others => '0');       #}
{#-      algo_after_prescaler_rop_int <= ({AssignmentAap} others => '0');       #}
-- ==== Inserted by TME - end ===============================================================================================================
