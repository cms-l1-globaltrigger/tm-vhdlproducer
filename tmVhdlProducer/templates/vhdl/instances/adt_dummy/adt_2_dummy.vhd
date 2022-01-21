cond_adt_2_i: entity work.adt_2_dummy
    port map(
        lhc_clk,
        bx_data,
        {{ condition.vhdl_signal }}
    );
