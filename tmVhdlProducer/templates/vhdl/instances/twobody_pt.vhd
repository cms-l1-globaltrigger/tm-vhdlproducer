{%- block instantiate_twobody_pt %}
    calc_twobody_pt_{{ obj1|lower }}_{{ obj2|lower }}_bx_{{ bx1 }}_bx_{{ bx2 }}_i: entity work.twobody_pt
        generic map(
            N_{{ obj1|upper }}_OBJECTS, N_{{ obj2|upper }}_OBJECTS
            {{ obj1|upper }}_PT_VECTOR_WIDTH, {{ obj2|upper }}_PT_VECTOR_WIDTH
        )
        port map(
            conv.{{ obj1|lower }}(bx({{ bx1|bx_dec }})).pt_vector,
            conv.{{ obj2|lower }}(bx({{ bx2|bx_dec }})).pt_vector,
            conv.{{ obj1|lower }}(bx({{ bx1|bx_dec }})).cos_phi,
            conv.{{ obj2|lower }}(bx({{ bx2|bx_dec }})).cos_phi,
            conv.{{ obj1|lower }}(bx({{ bx1|bx_dec }})).sin_phi,
            conv.{{ obj2|lower }}(bx({{ bx2|bx_dec }})).sin_phi,
            tbpt_{{ obj1|lower }}_{{ obj2|lower }}(bx({{ bx1|bx_dec }}),bx({{ bx2|bx_dec }}))
       );
{%- endblock instantiate_twobody_pt %}
