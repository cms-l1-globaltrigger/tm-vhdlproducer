cond_{{ condition.vhdl_signal }}_i: entity work.cicada_ad_hi_condition
    generic map(
  {%- if not o1.operator %}
        ge_mode => {{ o1.operator | vhdl_bool }},
  {%- endif %}
        ad_requ => true,
        -- thr = {{...}} ("fix precision" value - decimal)
        ad_dec_thr => X"{{ o1.threshold | X04 }}",
        ad_int_thr => X"{{ o2.threshold | X04 }}"
        )
    port map(
        lhc_clk => lhc_clk,
        ad_dec_i => bx_data.cicada_ad_dec({{ o.bx_arr }}),
        ad_int_i => bx_data.cicada_ad_int({{ o.bx_arr }}),
        ad_comp_o => {{ condition.vhdl_signal }}
    );
