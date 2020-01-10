{%- block instantiate_cos_dphi_lut %}
    calc_cos_dphi_{{ obj1|lower }}_{{ obj2|lower }}_bx_{{ bx1 }}_bx_{{ bx2 }}_i: entity work.cos_dphi_lut
        generic map(
            N_{{ obj1|upper }}_OBJECTS, N_{{ obj2|upper }}_OBJECTS, ({{ obj1|lower }}_t,{{ obj2|lower }}_t), (bx({{ bx1|bx_dec }}),bx({{ bx2|bx_dec }}))
        )
        port map(
            dphi_calc_{{ obj1|lower }}_{{ obj2|lower }}(bx({{ bx1|bx_dec }}),bx({{ bx2|bx_dec }})),
            cos_dphi_{{ obj1|lower }}_{{ obj2|lower }}(bx({{ bx1|bx_dec }}),bx({{ bx2|bx_dec }}))
        );
{%- endblock instantiate_cos_dphi_lut %}
