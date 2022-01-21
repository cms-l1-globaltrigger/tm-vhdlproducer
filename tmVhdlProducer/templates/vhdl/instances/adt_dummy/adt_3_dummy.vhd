cond_adt_3_i: entity work.adt_3_dummy
    port map(
        lhc_clk,
        bx_data,
        {{ condition.vhdl_signal }}
    );
