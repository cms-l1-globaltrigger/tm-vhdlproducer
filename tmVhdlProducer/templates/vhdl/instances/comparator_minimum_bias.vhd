{%- block instantiate_comparator_minimum_bias %}
    comp_{{ obj|lower }}_bx{{ bx }}_0x{{ count|lower }}_i: entity work.comparators_obj_cuts
        generic map(
            N_{{ obj|upper }}_OBJECTS, {{ obj|upper }}_WIDTH,
  {% if o1.operator == true %}  
            GE, 
  {% else %}  
            EQ, 
  {% endif %}  
            X"{{ count }}", X"0000", X"0000", "ign"
        )
        port map(
            lhc_clk, data.{{ obj|lower }}(bx({{ bx|bx_dec }})).count, comp_count_{{ obj|lower }}_bx_{{ bx }}_0x{{ count|lower }}
        );
{%- endblock instantiate_comparator_minimum_bias %}
