{%- set o1 = condition.objects[0] -%}

cond_{{ condition.vhdl_signal }}_i: entity work.calo_comb_multi_condition
    generic map(
  {%- if not o1.operator -%}
    pt_ge_mode => {{ o1.operator | vhdl_bool }},
  {% endif %}
        obj_nr => {{ condition.nr_objects }}, 
        pt_width => {{ o1.type | upper }}_ET_BITS, 
        pt_threshold => X"{{ o1.threshold | X04 }}"
    )
    port map(lhc_clk, bx_data.{{ o1.type | lower }}({{ o1.bx_arr }}), {{ condition.vhdl_signal }});

