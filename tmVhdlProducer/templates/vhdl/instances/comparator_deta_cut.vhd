{%- block instantiate_comparator_deta_cut %}
    comp_deta_{{ obj1|lower }}_{{ obj2|lower }}_bx_{{ bx1 }}_bx_{{ bx2 }}_0x{{ limit_l|lower }}_0x{{ limit_u|lower }}_i: entity work.comparators_corr_cuts
        generic map(
            N_{{ obj1|upper }}_OBJECTS, N_{{ obj2|upper }}_OBJECTS, ({{ obj1|lower }}_t,{{ obj2|lower }}_t), (bx({{ bx1|bx_dec }}),bx({{ bx2|bx_dec }})),
            {{ obj1|upper }}_{{ obj2|upper }}_DELTAETA_VECTOR_WIDTH, deltaEta, 
            X"{{ limit_l|upper }}", X"{{ limit_u|upper }}"        
        )
        port map(
            lhc_clk, 
            deta_{{ obj1|lower }}_{{ obj2|lower }}(bx({{ bx1|bx_dec }}),bx({{ bx2|bx_dec }})), comp_deta_{{ obj1|lower }}_{{ obj2|lower }}_bx_{{ bx1 }}_bx_{{ bx2 }}_0x{{ limit_l|lower }}_0x{{ limit_u|lower }}
        );
{%- endblock instantiate_comparator_deta_cut %}
