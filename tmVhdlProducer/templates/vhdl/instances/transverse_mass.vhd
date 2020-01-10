{%- block instantiate_transverse_mass %}
    calc_trans_mass_{{ obj1|lower }}_{{ obj2|lower }}_bx_{{ bx1 }}_bx_{{ bx2 }}_i: entity work.transverse_mass
        generic map(
            N_{{ obj1|upper }}_OBJECTS, N_{{ obj2|upper }}_OBJECTS, ({{ obj1|lower }}_t,{{ obj2|lower }}_t), (bx({{ bx1|bx_dec }}),bx({{ bx2|bx_dec }})),
            {{ obj1|upper }}_PT_VECTOR_WIDTH, {{ obj2|upper }}_PT_VECTOR_WIDTH,
            {{ obj1|upper }}_{{ obj2|upper }}_COSH_COS_VECTOR_WIDTH,
            {{ obj1|upper }}_{{ obj2|upper }}_COSH_COS_PRECISION
        )
        port map(
            conv.{{ obj1|lower }}(bx({{ bx1|bx_dec }})).pt_vector,
            conv.{{ obj2|lower }}(bx({{ bx2|bx_dec }})).pt_vector,
            cos_dphi_{{ obj1|lower }}_{{ obj2|lower }}(bx({{ bx1|bx_dec }}),bx({{ bx2|bx_dec }})),
            transmass_{{ obj1|lower }}_{{ obj2|lower }}(bx({{ bx1|bx_dec }}),bx({{ bx2|bx_dec }}))
       );
{%- endblock instantiate_transverse_mass %}
