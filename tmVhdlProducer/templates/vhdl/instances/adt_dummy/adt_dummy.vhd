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
        bx_data.muon(2),
        bx_data.eg(2),
        bx_data.jet(2),
        bx_data.tau(2),
        bx_data.ett(2),
        bx_data.htt(2),
        bx_data.etm(2),
        bx_data.htm(2),
        bx_data.ettem(2),
        bx_data.etmhf(2),
        {{ condition.vhdl_signal }}
    );
