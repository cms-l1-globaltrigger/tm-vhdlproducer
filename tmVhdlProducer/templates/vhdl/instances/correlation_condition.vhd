{% extends "instances/condition.vhd" %}

{% set o1 = condition.objects[0] %}
{% set o2 = condition.objects[1] %}
{%- if condition.nr_objects == 3 %}
  {% set o3 = condition.objects[2] %}
{%- endif %}        

{%- block generic_map %}
  {%- block generic_map_beg %}
  {%- endblock %}
  {%- if condition.nr_objects == 2 %}
    {%- if (o1.is_muon_type and o2.is_muon_type) or (o1.is_calo_type and o2.is_calo_type) %}
-- obj cuts
      {%- set o = condition.objects[0] %}
      {%- include  "instances/object_cuts_correlation.vhd" %}
    {%- elif o1.is_calo_type and o2.is_muon_type %} 
-- calo obj cuts
      {%- set o = condition.objects[0] %}
      {%- include  "instances/object_cuts_correlation_single.vhd" %}
-- muon obj cuts
      {%- set o = condition.objects[1] %}
      {%- include  "instances/object_cuts_correlation_single.vhd" %}
    {%- elif (o1.is_calo_type or o1.is_muon_type) and o2.is_esums_type %} 
-- obj cuts
      {%- set o = condition.objects[0] %}
      {%- include  "instances/object_cuts_correlation_single.vhd" %}
-- esums obj cuts
      {%- include  "instances/object_cuts_corr_esums.vhd" %}    
    {%- endif %}        
  {%- elif condition.nr_objects == 3 %}
-- obj cuts
    {%- set o = condition.objects[0] %}
    {%- include  "instances/object_cuts_correlation.vhd" %}  
  {%- endif %}        
  {%- if o1.is_muon_type and o2.is_muon_type %}
    {%- if condition.chargeCorrelation %}
-- charge correlation cut
        requested_charge_correlation => "{{ condition.chargeCorrelation }}",
    {% endif %}        
  {%- endif %}        
  {%- block correlation_orm %}
  {%- endblock %}
  {%- block correlation_cuts %}
-- correlation cuts
    {%- include  "instances/correlation_cuts_correlation.vhd" %}
  {%- endblock %}
  {%- block generic_map_end %}
  {%- endblock %}
{%- endblock %}
