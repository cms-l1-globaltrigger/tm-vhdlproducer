{%- set ns_axo = namespace(models=[]) -%}
{%- for condition in module.signalConditions -%}
  {%- set o = condition.objects[0] -%}
  {%- if o.type == "AXO" and o.model.value not in ns_axo.models %}
calc_axo_{{ o.model.value }}_i: entity work.ml_calculation_instances
    generic map(AXO_SEL, AXO_MODEL_{{ o.model.value | upper }}, AXO_SCORE_WIDTH)
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
    {%- set _ = ns_axo.models.append(o.model.value) -%}
  {%- endif -%}
{% endfor %}
{%- set ns_topo = namespace(models=[]) -%}
{%- for condition in module.signalConditions -%}
  {%- set o = condition.objects[0] -%}
  {%- if o.type == "TOPO" and o.model.value not in ns_topo.models %}
calc_topo_{{ o.model.value }}_i: entity work.ml_calculation_instances
    generic map(TOPO_SEL, TOPO_MODEL_{{ o.model.value | upper }}, TOPO_SCORE_WIDTH)
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
    {%- set _ = ns_topo.models.append(o.model.value) -%}
  {%- endif -%}
{% endfor %}
