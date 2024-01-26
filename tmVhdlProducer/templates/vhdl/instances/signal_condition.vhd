{%- set o = condition.objects[0] -%}
{%- if o.type == "AXOL1TL" -%}
cond_{{ condition.vhdl_signal }}: entity work.axol1tl_{{ o.anomalyModel.value }}_wrapper
    generic map(false, {{ o.anomalyScore.value }})
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
        {{ condition.vhdl_signal }}
    );
{%- elif o.type == "TOPO" -%}
cond_{{ condition.vhdl_signal }}: entity work.topo_{{ o.topologicalModel.value }}_wrapper
    generic map({{ o.topologicalScore.value }})
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
        {{ condition.vhdl_signal }}
    );
{%- elif o.type == "CICADA" -%}
cond_{{ condition.vhdl_signal }}: entity work.cicada_condition
    generic map(
  {%- if not o.operator %}
        ge_mode => {{ o.operator | vhdl_bool }},
  {%- endif %}
        cscore => X"{{ o.cicadaScore.value | X04 }}"
    )
    port map(
        lhc_clk => lhc_clk,
        cicada_i => bx_data.cicada({{ o.bx_arr }}),
        c_comp_o => {{ condition.vhdl_signal }}
    );
{%- elif o.is_signal_type -%}
{{ condition.vhdl_signal }} <= bx_data.{{ o.type | lower }}({{ o.bx_arr }});
{%- endif -%}

