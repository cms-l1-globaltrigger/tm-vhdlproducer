{%- set model_list = ["v1", "v3"] -%}
{%- for idx in range(model_list| length) %}
{%-   set temp = model_list[idx] -%}
{%-   set ns = namespace(matched = 0) -%}
{%-   for condition in module.signalConditions %}
{%-     set o = condition.objects[0] %}
{%-     if o.type == "AXO" and o.model.value == temp and not ns.matched == 1 %}
    signal axol1tl_{{ o.model.value }}_score : std_logic_vector(AXO_SCORE_WIDTH-1 downto 0);
{%-       set ns.matched = 1 -%}
{%-     endif -%}
{%-   endfor -%}
{% endfor %}
{%- set topo_model_list = ["base_v1", "hh_ele_v1", "hh_had_v1", "hh_mu_v1"] -%}
{%- for idx in range(topo_model_list| length) %}
{%-   set temp = topo_model_list[idx] -%}
{%-   set ns = namespace(matched = 0) -%}
{%-   for condition in module.signalConditions %}
{%-     set o = condition.objects[0] %}
{%-     if o.type == "TOPO" and o.model.value == temp and not ns.matched == 1 %}
    signal topo_{{ o.model.value }}_score : std_logic_vector(TOPO_SCORE_WIDTH-1 downto 0);
{%-       set ns.matched = 1 -%}
{%-     endif -%}
{%-   endfor -%}
{% endfor %}
