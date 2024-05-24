{%- set o1 = condition.objects[0] -%}

cond_{{ condition.vhdl_signal }}_i: entity work.calo_comb_multi_condition
  {%- if not o1.operator %}
    generic map({{ condition.nr_objects }}, {{ o1.type | upper }}_ET_BITS, X"{{ o1.threshold | X04 }}", {{ o1.operator | vhdl_bool }})
  {%- else %}
    generic map({{ condition.nr_objects }}, {{ o1.type | upper }}_ET_BITS, X"{{ o1.threshold | X04 }}")
  {%- endif %}
    port map(lhc_clk, bx_data.{{ o1.type | lower }}({{ o1.bx_arr }}), {{ condition.vhdl_signal }});
