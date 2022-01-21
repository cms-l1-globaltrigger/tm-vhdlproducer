cond_adt_4_i: entity work.adt_4_dummy
    port map(
        lhc_clk,
        bx_data,
        {{ condition.vhdl_signal }}
    );
