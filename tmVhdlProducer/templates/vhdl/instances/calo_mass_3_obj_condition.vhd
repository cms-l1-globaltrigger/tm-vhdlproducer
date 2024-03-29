{% extends "instances/base/condition.vhd" %}

{%- set o1 = condition.objects[0] %}
{%- set o2 = condition.objects[1] %}
{%- set o3 = condition.objects[2] %}

{% block entity %}work.correlation_conditions{% endblock %}

{%- block generic_map %}
    {%- set o = condition.objects[0] %}
    {%- include  "instances/base/object_cuts_correlation.vhd" %}
-- correlation cuts
        mass_upper_limit_vector => X"{{ condition.mass.upper|X16 }}",
        mass_lower_limit_vector => X"{{ condition.mass.lower|X16 }}",
        mass_vector_width => {{ o1.type | upper }}_PT_VECTOR_WIDTH+{{ o2.type | upper }}_PT_VECTOR_WIDTH+CALO_CALO_COSH_COS_VECTOR_WIDTH,
        mass_3_obj => true,
-- number of objects and type
  {%- for i in range(0,condition.nr_objects) %}
    {%- set o = condition.objects[i] %}
        nr_obj{{i+1}} => NR_{{ o.type | upper }}_OBJECTS,
        type_obj{{i+1}} => {{ o.type | upper }}_TYPE,
  {%- endfor %}
-- selector same/different bunch crossings
        same_bx => {{ condition.objectsInSameBx | vhdl_bool}}
{%- endblock %}

{%- block port_map %}
        calo_obj1 => bx_data.{{ o1.type | lower }}({{ o1.bx_arr }}),
        calo_obj2 => bx_data.{{ o2.type | lower }}({{ o2.bx_arr }}),
        calo_obj3 => bx_data.{{ o3.type | lower }}({{ o3.bx_arr }}),
        mass_inv_pt => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_inv_pt,
{%- endblock %}
