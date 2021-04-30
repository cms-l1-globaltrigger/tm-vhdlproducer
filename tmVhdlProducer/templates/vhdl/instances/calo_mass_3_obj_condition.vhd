{% extends "instances/base/condition.vhd" %}

{%- set o1 = condition.objects[0] %}
{%- set o2 = condition.objects[1] %}
{%- set o3 = condition.objects[2] %}

{% block entity %}work.correlation_conditions_calo{% endblock %}

{%- block generic_map %}
-- obj cuts
    {%- set o = condition.objects[0] %}
    {%- include  "instances/base/object_cuts_correlation.vhd" %}
-- correlation cuts
        mass_upper_limit_vector => X"{{ condition.mass.upper|X16 }}",
        mass_lower_limit_vector => X"{{ condition.mass.lower|X16 }}",
        mass_vector_width => {{ o1.type | upper }}_PT_VECTOR_WIDTH+{{ o2.type | upper }}_PT_VECTOR_WIDTH+{{ o1.type | upper }}_{{ o1.type | upper }}_COSH_COS_VECTOR_WIDTH,
-- number of calo objects, types
        nr_obj1 => NR_{{ o1.type | upper }}_OBJECTS,
        type_obj1 => {{ o1.type | upper }}_TYPE,
        nr_obj2 => NR_{{ o2.type | upper }}_OBJECTS,
        type_obj2 => {{ o2.type | upper }}_TYPE,
        nr_obj3 => NR_{{ o3.type | upper }}_OBJECTS,
        type_obj3 => {{ o3.type | upper }}_TYPE,
        mass_3_obj => true,
        same_bx => {{ condition.objectsInSameBx | vhdl_bool}}
{%- endblock %}

{%- block port_map %}
        obj1 => {{ o1.type | lower }}_bx_{{ o1.bx }},
        obj2 => {{ o2.type | lower }}_bx_{{ o2.bx }},
        obj3 => {{ o3.type | lower }}_bx_{{ o3.bx }},
        mass_inv_pt => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_inv_pt,
{%- endblock %}
