{%- block correlation_cuts_comb %}
  {%- if o1.is_muon_type %}
    {%- if condition.chargeCorrelation %}
-- charge correlation cut
        requested_charge_correlation => "{{ condition.chargeCorrelation.value }}",     
    {%- endif %}        
  {%- endif %} 
  {%- if condition.twoBodyPt %}
-- correlation cuts
        twobody_pt_cut => true, 
        pt_width => {{ o1.type|upper }}_PT_VECTOR_WIDTH, 
        pt_sq_threshold_vector => X"{{ condition.twoBodyPt.threshold|X16 }}",
    {%- if o1.is_muon_type %}
        sin_cos_width => MUON_SIN_COS_VECTOR_WIDTH, 
    {%- elif o1.is_calo_type %}        
        sin_cos_width => CALO_SIN_COS_VECTOR_WIDTH, 
    {%- endif %} 
        pt_sq_sin_cos_precision => {{ o1.type|upper }}_{{ o1.type|upper }}_SIN_COS_PRECISION,        
  {%- endif %}
{%- endblock correlation_cuts_comb %}
