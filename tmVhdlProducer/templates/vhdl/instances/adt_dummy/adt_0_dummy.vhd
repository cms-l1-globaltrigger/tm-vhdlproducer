cond_adt_0_i: entity work.adt_0_dummy
    port map(
        lhc_clk,
        bx_data,
        {{ condition.vhdl_signal }}
    );
