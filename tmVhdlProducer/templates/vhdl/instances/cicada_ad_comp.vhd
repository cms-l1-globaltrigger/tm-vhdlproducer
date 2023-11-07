cond_{{ condition.vhdl_signal }}_i: entity work.cicada_ad_hi_comp
    generic map(
        ad_requ => true,
        ad_dec_thr => X"{{ TBD | X02 }}",
        ad_int_thr => X"{{ TBD | X02 }}"
        )
    port map(
        lhc_clk => lhc_clk,
        ad_dec_i => bx_data.cicada_ad_dec({{ o.bx_arr }}),
        ad_int_i => bx_data.cicada_ad_int({{ o.bx_arr }}),
        ad_comp_o => {{ condition.vhdl_signal }}
    );
