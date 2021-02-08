{% extends "instances/base/comb_condition.vhd" %}

{% block entity %}work.comb_conditions{% endblock %}

{%- block generic_map_end %}
-- number of objects and type
        nr_obj1 => NR_{{ o1.type }}_OBJECTS,
        type_obj1 => {{ o1.type }}_TYPE,
        nr_templates => {{ condition.nr_objects }}
{%- endblock %}

{% block port_map %}
        obj1_calo => {{ o1.type | lower }}_bx_{{ o1.bx }},
    {%- if condition.twoBodyPt %}
         pt => {{ o1.type | lower }}_bx_{{ o1.bx }}_pt_vector,
         cos_phi_integer => {{ o1.type | lower }}_bx_{{ o1.bx }}_cos_phi,
         sin_phi_integer => {{ o1.type | lower }}_bx_{{ o1.bx }}_sin_phi,
    {%- endif %}
{%- endblock %}
