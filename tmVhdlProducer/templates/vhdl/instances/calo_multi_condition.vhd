{%- set o1 = condition.objects[0] -%}

cond_{{ condition.vhdl_signal }}_i: entity work.calo_comp_pt_obj_nr_condition
    generic map(
  {%- if not o1.operator -%}
    {{ o1.operator | vhdl_bool }},
  {%- endif -%}
    {{ condition.nr_objects }}, {{ o1.type | upper }}_ET_BITS, X"{{ o1.threshold | X04 }}")
    port map(lhc_clk, bx_data.{{ o1.type | lower }}({{ o1.bx_arr }}), {{ condition.vhdl_signal }});

