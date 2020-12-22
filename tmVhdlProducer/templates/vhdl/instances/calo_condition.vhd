{% extends "instances/sub_templ/comb_condition.vhd" %}

{% block entity %}work.calo_conditions{% endblock %}

{% block port_map %}
        {{ condition.objects[0].type|lower }}_bx_{{ condition.objects[0].bx }},
    {%- if condition.hasTwoBodyPt %}
         pt => {{ condition.objects[0].type|lower }}_bx_{{ condition.objects[0].bx }}_pt_vector,
         cos_phi_integer => {{ condition.objects[0].type|lower }}_bx_{{ condition.objects[0].bx }}_cos_phi,
         sin_phi_integer => {{ condition.objects[0].type|lower }}_bx_{{ condition.objects[0].bx }}_sin_phi,
    {%- endif %}
{%- endblock %}
