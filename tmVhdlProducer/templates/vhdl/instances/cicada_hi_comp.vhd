cond_{{ condition.vhdl_signal }}_i: entity work.cicada_ad_hi_comp
    generic map(
        hi_bits_requ => true,
        hi_bits_val => X"{{ TBD | X02 }}"
        )
    port map(
        lhc_clk => lhc_clk,
        hi_bits_i => bx_data.cicada_hi({{ o.bx_arr }}),
        hi_comp_o => {{ condition.vhdl_signal }}
    );
