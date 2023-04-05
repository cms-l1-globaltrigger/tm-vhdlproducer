{%- set o = condition.objects[0] -%}
-- {{o.name}}
{%- set value = o.name.split('_')[2] -%}
{%- set ascore = value.split('+')[0] %}
{%- set ascore = ascore.split('-')[0] %}
cond_{{ condition.vhdl_signal }}_i: entity work.adt_wrapper
    generic map(false, {{ ascore }})
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
