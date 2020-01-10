{%- block instantiate_comparator_pt_cut %}
    comp_pt_{{ obj|lower }}_bx_{{ bx }}_0x{{ thr|lower }}_i: entity work.comparators_obj_cuts
        generic map(
            N_{{ obj|upper }}_OBJECTS, {{ obj|upper }}_PT_WIDTH,
  {%- if ge == 'true' %}  
            GE, 
  {%- else %}  
            EQ, 
  {%- endif %}  
            X"{{ thr|upper }}", X"0000", X"0000", "ign"
        )
        port map(
            lhc_clk, data.{{ obj|lower }}(bx({{ bx|bx_dec }})).pt, comp_pt_{{ obj|lower }}_bx_{{ bx }}_0x{{ thr|lower }}
        );
{%- endblock instantiate_comparator_pt_cut %}
