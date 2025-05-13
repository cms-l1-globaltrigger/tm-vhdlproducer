{%- set axo_model_list = ["v1", "v3", "v4", "v5"] -%}
{%- for idx in range(axo_model_list| length) %}
{%-   set temp = axo_model_list[idx] -%}
{%-   set ns = namespace(matched = 0) -%}
{%-   for condition in module.signalConditions %}
{%-     set o = condition.objects[0] %}
{%-     if o.type == "AXO" and o.model.value == temp and not ns.matched == 1 %}
calc_axo_{{ o.model.value }}_i: entity work.ml_calculation_instances
    generic map(AXO_SEL, AXO_MODEL_{{temp | upper}}, AXO_SCORE_WIDTH)
    port map(
        lhc_clk,
        bx_data.mu({{ o.bx_arr }}),
        bx_data.eg({{ o.bx_arr }}),
        bx_data.jet({{ o.bx_arr }}),
        bx_data.tau({{ o.bx_arr }}),
        bx_data.ett({{ o.bx_arr }}),
        bx_data.htt({{ o.bx_arr }}),
        bx_data.etm({{ o.bx_arr }}),
        bx_data.htm({{ o.bx_arr }}),
        bx_data.etmhf({{ o.bx_arr }}),
        bx_data.htmhf({{ o.bx_arr }}),
        axol1tl_{{ o.model.value }}_score
    );
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
calc_topo_{{ o.model.value }}_i: entity work.ml_calculation_instances
    generic map(TOPO_SEL, TOPO_MODEL_{{temp | upper}}, TOPO_SCORE_WIDTH)
    port map(
        lhc_clk,
        bx_data.mu({{ o.bx_arr }}),
        bx_data.eg({{ o.bx_arr }}),
        bx_data.jet({{ o.bx_arr }}),
        bx_data.tau({{ o.bx_arr }}),
        bx_data.ett({{ o.bx_arr }}),
        bx_data.htt({{ o.bx_arr }}),
        bx_data.etm({{ o.bx_arr }}),
        bx_data.htm({{ o.bx_arr }}),
        bx_data.etmhf({{ o.bx_arr }}),
        bx_data.htmhf({{ o.bx_arr }}),
        topo_{{ o.model.value }}_score
    );
{%-       set ns.matched = 1 -%}
{%-     endif -%}
{%-   endfor -%}
{% endfor %}

