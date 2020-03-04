{%- block instantiate_comparator_inv_mass_3_obj_cut %}
    comp_inv_mass_3_obj_{{ obj1|lower }}_bx_{{ bx1 }}_0x{{ limit_l|lower }}_0x{{ limit_u|lower }}_i: entity work.comparators_mass_3_obj
        generic map(
            N_{{ obj1|upper }}_OBJECTS,
            {{ obj1|upper }}_{{ obj1|upper }}_MASS_VECTOR_WIDTH, mass, 
            X"{{ limit_l|upper }}", X"{{ limit_u|upper }}"        
        )
        port map(
            lhc_clk, invmass_{{ obj1|lower }}_{{ obj1|lower }}(bx({{ bx1|bx_dec }}),bx({{ bx1|bx_dec }})), comp_invmass3obj_{{ obj1|lower }}_bx_{{ bx1 }}_0x{{ limit_l|lower }}_0x{{ limit_u|upper }}
        );
{%- endblock instantiate_comparator_inv_mass_3_obj_cut %}
