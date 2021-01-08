{% extends "instances/sub_templ/condition.vhd" %}

{% set o1 = condition.objects[0] %}
{% set o2 = condition.objects[1] %}
{% set o3 = condition.objects[2] %}
{% set o4 = condition.objects[3] %}

{% block generic_map %}
  {%- include  "instances/sub_templ/object_cuts_comb.vhd" %}
  {%- include  "instances/sub_templ/correlation_cuts_comb.vhd" %}
-- number of objects and type
  {%- if condition.objects[0].is_calo_type %}        
        type_obj1 => {{ condition.objects[0].type }}_TYPE,
  {%- endif %}
        nr_templates => {{ condition.nr_objects }}
{%- endblock %}
