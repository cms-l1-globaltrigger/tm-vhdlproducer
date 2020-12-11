{%- block calo_correlation_conditions_base %}
  {%- block entity %}
  {%- endblock entity %}
    generic map(
  {%- block generic_beg %}
  {%- endblock generic_beg %}
  {%- if condition.objects[1].is_calo_type %}
    {%- set nr_calo_obj = condition.nr_objects %}
  {%- else %}        
    {%- set nr_calo_obj = 1 %}
  {%- endif %}        
  {%- for i in range(0,nr_calo_obj) %}
    {%- set o = condition.objects[i] %}
    {%- if nr_calo_obj > 1 %}
-- object {{i+1}} cuts
      {%- if i < 2 %}
        nr_calo{{i+1}}_objects => NR_{{ o.type|upper }}_OBJECTS,       
      {%- endif %}        
      {%- include "instances/object_cuts_calos.vhd" %}
    {%- else %}        
      {%- include "instances/object_cuts_calo_single.vhd" %}
    {%- endif %}        
  {%- endfor %}
  {%- if condition.objects[1].is_esums_type %}
    {%- set o2 = condition.objects[1] %}
    {%- include "instances/object_cuts_esums.vhd" %}
  {%- endif %}        
  {%- if condition.objects[1].is_muon_type %}
    {%- set o2 = condition.objects[1] %}
    {%- include "instances/object_cuts_muon_single.vhd" %}
  {%- endif %}
  {%- block correlation_cuts %}
    {%- include "instances/correlation_cuts.vhd" %}
  {%- endblock correlation_cuts %}
  {%- block generic_end %}
  {%- endblock generic_end %}
    )
    port map(
  {%- block port %}
  {%- endblock port %}
    );
{%- endblock calo_correlation_conditions_base %}
{# eof #}
