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
{%- elif o.is_signal_type -%}
{{ condition.vhdl_signal }} <= bx_data.{{ o.type | lower }}({{ o.bx_arr }});
{%- endif -%}
