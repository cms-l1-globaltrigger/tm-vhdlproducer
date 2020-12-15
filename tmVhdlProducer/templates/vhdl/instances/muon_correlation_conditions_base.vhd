{%- block muon_correlation_conditions_base %}
  {%- block entity %}
  {%- endblock entity %}
    generic map(
  {%- block generic_beg %}
  {%- endblock generic_beg %}
  {%- set nr_muon_obj = condition.nr_objects %}
  {%- for i in range(0,nr_muon_obj) %}
    {%- set o = condition.objects[i] %}
    {%- if nr_muon_obj > 1 %}
-- object {{i+1}} cuts
      {%- include  "instances/object_cuts_corr_muons.vhd" %}
    {%- else %}        
      {%- include  "instances/object_cuts_corr_muon.vhd" %}
    {%- endif %}        
  {%- endfor %}
  {%- if condition.objects[1].is_esums_type %}
    {%- set o2 = condition.objects[1] %}
    {%- include  "instances/object_cuts_corr_esums.vhd" %}
  {%- endif %}        
  {%- block correlation_cuts %}
    {%- if condition.chargeCorrelation is not none %}
-- charge correlation cuts
        requested_charge_correlation => "{{ condition.chargeCorrelation }}",     
    {%- endif %}        
    {%- include "instances/muon_correlation_cuts.vhd" %}
  {%- endblock correlation_cuts %}
  {%- block generic_end %}
  {%- endblock generic_end %}
    )
    port map(
  {%- block port %}
  {%- endblock port %}
    );
{%- endblock muon_correlation_conditions_base %}
{# eof #}
