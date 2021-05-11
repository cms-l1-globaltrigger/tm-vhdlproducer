{% extends "instances/base/condition.vhd" %}

{%- set o1 = condition.objects[0] %}
{%- set o2 = condition.objects[1] %}
{%- if condition.nr_objects == 3 %}
  {%- set o3 = condition.objects[2] %}
{%- endif %}

{%- block generic_map %}
  {%- if o2.is_esums_type %}
    {%- set o = condition.objects[0] %}
    {%- include  "instances/base/object_cuts_correlation.vhd" %}
    {%- include  "instances/base/object_cuts_corr_esums.vhd" %}
  {%- else %}
    {%- set o = condition.objects[0] %}
    {%- include  "instances/base/object_cuts_correlation.vhd" %}
  {%- endif %}
    {%- include  "instances/base/correlation_cuts_correlation.vhd" %}
{%- endblock %}
