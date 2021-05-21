{% extends "instances/base/correlation_condition.vhd" %}

{% block entity %}work.correlation_conditions{% endblock %}

{%- block generic_map -%}
{{ super() }}
-- number of calo objects, types
        nr_obj1 => NR_{{ o1.type | upper }}_OBJECTS,
        type_obj1 => {{ o1.type | upper }}_TYPE,
        nr_obj2 => NR_{{ o2.type | upper }}_OBJECTS
{%- endblock %}

{%- block port_map %}
        calo_obj1 => {{ o1.type | lower }}({{ o1.bx_arr }}),
        esums => {{ o2.type | lower }}({{ o2.bx_arr }}),
    {%- if condition.deltaPhi %}
        dphi => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi,
    {%- endif %}
    {%- if condition.mass and condition.mass.type == condition.mass.TransverseMassType %}
        mass_trans => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_trans,
    {%- endif %}
    {%- if condition.twoBodyPt %}
        tbpt => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_tbpt,
    {%- endif %}
{%- endblock %}
