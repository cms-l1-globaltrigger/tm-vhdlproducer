{%- block correlation_conditions_base %}
  {%- block entity %}
  {%- endblock entity %}
    generic map(
  {%- block generic_beg %}
  {%- endblock generic_beg %}
  {%- if (condition.objects[1].is_calo_type) or ((condition.objects[0].is_muon_type) and (condition.objects[1].is_muon_type)) %}
    {%- set nr_objects = condition.nr_objects %}
  {%- else %}        
    {%- set nr_objects = 1 %}
  {%- endif %}        
  {%- for i in range(0,nr_objects) %}
    {%- set o = condition.objects[i] %}
-- object {{i+1}} cuts
    {%- include "instances/object_cuts_corr_objects.vhd" %}
  {%- endfor %}
  {%- if condition.objects[1].is_esums_type %}
    {%- set o2 = condition.objects[1] %}
    {%- include "instances/object_cuts_corr_esums.vhd" %}
  {%- endif %}        
  {%- if (condition.objects[0].is_calo_type) and (condition.objects[1].is_muon_type) %}
    {%- set o = condition.objects[1] %}
    {%- set i = 2 %}
    {%- include "instances/object_cuts_corr_objects.vhd" %}
  {%- endif %}
  {%- block correlation_cuts %}
    {%- set o1 = condition.objects[0] %}  
    {%- set o2 = condition.objects[1] %}  
    {%- include "instances/correlation_cuts.vhd" %}
  {%- endblock correlation_cuts %}
  {%- block generic_end %}
  {%- endblock generic_end %}
    )
    port map(
  {%- block port %}
  {%- endblock port %}
    );
{%- endblock correlation_conditions_base %}
{# eof #}
