{%- block instantiate_condition_tbpt_cut %}
    comp_tbpt_{{ obj1|lower }}_{{ obj2|lower }}_bx{{ bx1 }}_bx{{ bx2 }}_0x{{ limit_l|lower }}_i: entity work.conditions_corr_cuts
        generic map(
            N_{{ obj1|upper }}_OBJECTS, N_{{ obj2|upper }}_OBJECTS, ({{ obj1|lower }}_t,{{ obj2|lower }}_t), (bx({{ bx1|bx_dec }}),bx({{ bx2|bx_dec }})),
            {{ obj1|upper }}_{{ obj2|upper }}_TBPT_VECTOR_WIDTH, twoBodyPt, 
            X"{{ limit_l|upper }}"        
        )
        port map(
            lhc_clk, 
            tbpt_{{ obj1|lower }}_{{ obj2|lower }}(bx({{ bx1|bx_dec }}),bx({{ bx2|bx_dec }})), comp_tbpt_{{ obj1|lower }}_{{ obj2|lower }}_bx_{{ bx1 }}_bx_{{ bx2 }}_0x{{ limit_l|lower }}
        );
{% endblock instantiate_condition_tbpt_cut %}
