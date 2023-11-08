cond_{{ condition.vhdl_signal }}_i: entity work.cicada_ad_hi_condition
    generic map(
  {%- if not o.operator %}
        ge_mode => {{ o.operator | vhdl_bool }},
  {%- endif %}
        hi_bits_requ => true,
        hi_bits_val => X"{{ o.threshold | X04 }}"
        )
    port map(
        lhc_clk => lhc_clk,
        hi_bits_i => bx_data.cicada_hi({{ o.bx_arr }}),
        hi_comp_o => {{ condition.vhdl_signal }}
    );
