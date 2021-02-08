{% extends "instances/base/condition.vhd" %}

{%- set o1 = condition.objects[0] %}
{%- set o2 = condition.objects[1] %}
{%- if condition.nr_objects == 3 %}
  {%- set o3 = condition.objects[2] %}
{%- endif %}

{%- block generic_map %}
  {%- if o2.is_esums_type %}
-- obj cuts
    {%- set o = condition.objects[0] %}
    {%- include  "instances/base/object_cuts_correlation.vhd" %}
-- esums obj cuts
    {%- include  "instances/base/object_cuts_corr_esums.vhd" %}
  {%- else %}
-- obj cuts
    {%- set o = condition.objects[0] %}
    {%- include  "instances/base/object_cuts_correlation.vhd" %}
  {%- endif %}
  {%- block correlation_cuts %}
    {%- include  "instances/base/correlation_cuts_correlation.vhd" %}
  {%- endblock %}
  {%- block correlation_orm %}
  {%- endblock %}
  {%- block generic_map_end %}
  {%- endblock %}
{%- endblock %}
