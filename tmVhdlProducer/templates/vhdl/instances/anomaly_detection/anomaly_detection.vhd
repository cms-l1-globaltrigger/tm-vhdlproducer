-- Anomaly detection instantiation
{% set o = condition.objects[0] %}
cond_{{ condition.vhdl_signal }}_i: entity work.adt_wrapper
    generic map(false, {{ o.anomalyScore.value }})
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
