{% extends "instances/sub_templ/comb_condition.vhd" %}

{% block entity %}work.calo_conditions{% endblock %}

{% block port_map %}
        {{ condition.objects[0].type|lower }}_bx_{{ condition.objects[0].bx }},
    {%- if condition.hasTwoBodyPt %}
         pt => {{ condition.objects[0].type|lower }}_pt_vector_bx_{{ condition.objects[0].bx }},
         cos_phi_integer => {{ condition.objects[0].type|lower }}_cos_phi_bx_{{ condition.objects[0].bx }},
         sin_phi_integer => {{ condition.objects[0].type|lower }}_sin_phi_bx_{{ condition.objects[0].bx }},
    {%- endif %}
{%- endblock %}
