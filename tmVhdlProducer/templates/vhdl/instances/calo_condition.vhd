{% extends "instances/base/comb_condition.vhd" %}

{% block entity %}work.comb_conditions{% endblock %}

{%- block generic_map %}
{{ super() }}
-- number of objects and type
        nr_obj1 => NR_{{ o1.type }}_OBJECTS,
        type_obj1 => {{ o1.type }}_TYPE,
        nr_templates => {{ condition.nr_objects }}
{%- endblock %}

{% block port_map %}
        obj1_calo => bx_data.{{ o1.type | lower }}({{ o1.bx_arr }}),
    {%- if condition.twoBodyPt %}
        tbpt => {{ o1.type | lower }}_{{ o1.type | lower }}_bx_{{ o1.bx }}_bx_{{ o1.bx }}_tbpt,
    {%- endif %}
{%- endblock %}
