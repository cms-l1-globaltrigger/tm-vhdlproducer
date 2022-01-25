{%- if condition.objects[0].externalChannelId == 58 %}
cond_adt_0_i: entity work.adt_0_dummy
{%- elif condition.objects[0].externalChannelId == 59 %}
cond_adt_1_i: entity work.adt_1_dummy
{%- elif condition.objects[0].externalChannelId == 60 %}
cond_adt_2_i: entity work.adt_2_dummy
{%- elif condition.objects[0].externalChannelId == 61 %}
cond_adt_3_i: entity work.adt_3_dummy
{%- elif condition.objects[0].externalChannelId == 62 %}
cond_adt_4_i: entity work.adt_4_dummy
{%- elif condition.objects[0].externalChannelId == 63 %}
cond_adt_5_i: entity work.adt_5_dummy
{%- endif %}
    port map(
        lhc_clk,
--         clk240: in std_logic;
        bx_data.mu,
        bx_data.eg,
        bx_data.jet,
        bx_data.tau,
        bx_data.ett,
        bx_data.htt,
        bx_data.etm,
        bx_data.htm,
        bx_data.ettem,
        bx_data.etmhf,
        {{ condition.vhdl_signal }}
    );
