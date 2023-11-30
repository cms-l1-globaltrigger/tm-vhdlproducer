{%- set o = condition.objects[0] -%}
{%- if o.type == "ADT" -%}
cond_{{ condition.vhdl_signal }}_i: entity work.adt_wrapper
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
{%- elif o.type == "CICADA" -%}
cond_{{ condition.vhdl_signal }}_i: entity work.cicada_ad_hi_condition
    generic map(
  {%- if not o.operator %}
        ge_mode => {{ o.operator | vhdl_bool }},
  {%- endif %}
        ad_requ => true,
        ad_dec_thr => X"{{ o.cicadaScore.value_dec | X04 }}",
        ad_int_thr => X"{{ o.cicadaScore.value_int | X04 }}"
    )
    port map(
        lhc_clk => lhc_clk,
        ad_dec_i => bx_data.cicada_ad_dec({{ o.bx_arr }}),
        ad_int_i => bx_data.cicada_ad_int({{ o.bx_arr }}),
        ad_comp_o => {{ condition.vhdl_signal }}
    );
{%- elif o.is_signal_type -%}
{{ condition.vhdl_signal }} <= bx_data.{{ o.type | lower }}({{ o.bx_arr }});
{%- endif -%}

