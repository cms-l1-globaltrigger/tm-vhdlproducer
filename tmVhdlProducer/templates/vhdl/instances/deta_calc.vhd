{%- block instantiate_deta_calc %}
    calc_deta_{{ obj1|lower }}_{{ obj2|lower }}_bx_{{ bx1 }}_bx_{{ bx2 }}_i: entity work.deta_calc
        generic map(
            N_{{ obj1|upper }}_OBJECTS, N_{{ obj2|upper }}_OBJECTS, ({{ obj1|lower }}_t,{{ obj2|lower }}_t), (bx({{ bx1|bx_dec }}),bx({{ bx2|bx_dec }}))
        )
        port map(
  {%- if obj1|lower != 'mu' and obj2|lower == 'mu' %}    
            conv.{{ obj1|lower }}(bx({{ bx1|bx_dec }})).eta_conv_mu,
  {%- else %}
            conv.{{ obj1|lower }}(bx({{ bx1|bx_dec }})).eta,
  {%- endif %}
            conv.{{ obj2|lower }}(bx({{ bx2|bx_dec }})).eta,
            deta_calc_{{ obj1|lower }}_{{ obj2|lower }}(bx({{ bx1|bx_dec }}),bx({{ bx2|bx_dec }}))
        );
{%- endblock instantiate_deta_calc %}
