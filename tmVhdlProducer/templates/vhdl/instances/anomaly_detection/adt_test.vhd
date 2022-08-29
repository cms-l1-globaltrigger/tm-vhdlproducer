-- Anomaly detection instantiation
cond_{{ condition.objects[0].name | lower}}_i: entity work.adt_wrapper
    port map(
        lhc_clk,
        bx_data.mu(2),
        bx_data.jet(2),
        bx_data.eg(2),
        bx_data.tau(2),
        bx_data.ett(2),
        bx_data.htt(2),
        bx_data.etm(2),
        bx_data.htm(2),
        bx_data.etmhf(2),
        {{ condition.vhdl_signal }}
    );
