cond_adt_5_i: entity work.adt_5_dummy
    port map(
        lhc_clk,
        bx_data,
        {{ condition.vhdl_signal }}
    );
