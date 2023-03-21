{%- set obj_name = condition.objects[0].name.split('_')[0] -%}
{%- set ascore = condition.objects[0].name.split('_')[2] -%}
cond_{{ condition.vhdl_signal }}_i: entity work.adt_wrapper
{%- if obj_name == "EXT" %}
    generic map(false, {{ ascore }})
{%- else %}
    generic map(false, {{ condition.objects[0].anomalyScore.value }})
{%- endif %}
    port map(
        lhc_clk,
        bx_data.mu(2),
        bx_data.eg(2),
        bx_data.jet(2),
        bx_data.tau(2),
        bx_data.ett(2),
        bx_data.htt(2),
        bx_data.etm(2),
        bx_data.htm(2),
        bx_data.etmhf(2),
        {{ condition.vhdl_signal }}
    );
