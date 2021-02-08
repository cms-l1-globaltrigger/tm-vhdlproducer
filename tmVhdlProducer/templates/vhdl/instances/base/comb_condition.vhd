{% extends "instances/base/condition.vhd" %}

{% set o1 = condition.objects[0] %}
{% set o2 = condition.objects[1] %}
{% set o3 = condition.objects[2] %}
{% set o4 = condition.objects[3] %}

{% block generic_map %}
  {%- include  "instances/base/object_cuts_comb.vhd" %}
  {%- include  "instances/base/correlation_cuts_comb.vhd" %}
  {%- block generic_map_end %}
  {%- endblock %}
{%- endblock %}


