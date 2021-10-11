{%- block correlation_cuts_comb %}
  {%- if o1.is_muon_type %}
    {%- if condition.chargeCorrelation %}
-- charge correlation cut
        requested_charge_correlation => "{{ condition.chargeCorrelation.value }}",
    {%- endif %}
  {%- endif %}
  {%- if condition.twoBodyPt %}
-- correlation cuts
        tbpt_cut => {{ condition.twoBodyPt | vhdl_bool }},
    {%- if o1.is_calo_type and (o2.is_calo_type or o2.is_esum_type) %}
        tbpt_vector_width => 2+{{ o1.type | upper }}_PT_VECTOR_WIDTH+{{ o2.type | upper }}_PT_VECTOR_WIDTH+(2*CALO_SIN_COS_VECTOR_WIDTH),
    {%- elif o1.is_muon_type or o2.is_muon_type %}
        tbpt_vector_width => 2+{{ o1.type | upper }}_PT_VECTOR_WIDTH+{{ o2.type | upper }}_PT_VECTOR_WIDTH+(2*MUON_SIN_COS_VECTOR_WIDTH),
    {%- endif %}
        tbpt_threshold_vector => X"{{ condition.twoBodyPt.threshold | X16 }}",
  {%- endif %}
{%- endblock correlation_cuts_comb %}
