{%- block muon_correlation_cuts %}
-- correlation cuts
  {%- set o1 = condition.objects[0] %}
  {%- set o2 = condition.objects[1] %}
  {%- if condition.hasDeltaEta %}
        deta_cut => {{ condition.deltaEta.enabled }}, 
  {%- endif %}        
  {%- if condition.hasDeltaPhi %}
        dphi_cut => {{ condition.deltaPhi.enabled }}, 
  {%- endif %}        
  {%- if condition.hasDeltaR %}
        dr_cut => {{ condition.deltaR.enabled }}, 
  {%- endif %}        
  {%- if condition.hasMass %}
        mass_cut => {{ condition.mass.enabled }}, 
    {%- if condition.mass.type == condition.mass.InvariantMassDeltaRType %}
        mass_type => INVARIANT_MASS_DIV_DR_TYPE,
    {%- elif condition.mass.type == condition.mass.InvariantMassType %}
        mass_type => INVARIANT_MASS_TYPE, 
    {%- elif condition.mass.type == condition.mass.TransverseMassType %}
        mass_type => TRANSVERSE_MASS_TYPE, 
    {%- endif %}        
  {%- endif %}        
  {%- if condition.hasTwoBodyPt %}
        twobody_pt_cut => {{ condition.twoBodyPt.enabled }}, 
  {%- endif %}                              
  {%- if condition.hasDeltaEta %}
        diff_eta_upper_limit_vector => X"{{ condition.deltaEta.upper|X08 }}", 
        diff_eta_lower_limit_vector => X"{{ condition.deltaEta.lower|X08 }}",
  {%- endif %}        
  {%- if condition.hasDeltaPhi %}
        diff_phi_upper_limit_vector => X"{{ condition.deltaPhi.upper|X08 }}", 
        diff_phi_lower_limit_vector => X"{{ condition.deltaPhi.lower|X08 }}",
  {%- endif %}        
  {%- if condition.hasDeltaR %}
        dr_upper_limit_vector => X"{{ condition.deltaR.upper|X16 }}", 
        dr_lower_limit_vector => X"{{ condition.deltaR.lower|X16 }}",
  {%- endif %}        
  {%- if condition.hasMass %}
    {%- if condition.mass.type == condition.mass.InvariantMassDeltaRType %}
        mass_div_dr_threshold => X"{{ condition.mass.lower|X21 }}",
    {%- else %}
        mass_upper_limit => X"{{ condition.mass.upper|X16 }}",
        mass_lower_limit => X"{{ condition.mass.lower|X16 }}",
    {%- endif %}        
  {%- endif %}        
  {%- if condition.hasTwoBodyPt %}
        pt_sq_threshold_vector => X"{{ condition.twoBodyPt.threshold|X16 }}", 
    {%- if o2.is_calo_type %}
        sin_cos_width => CALO_SIN_COS_VECTOR_WIDTH, 
    {%- elif o2.is_muon_type %}
        sin_cos_width => MUON_SIN_COS_VECTOR_WIDTH, 
    {%- endif %}        
        pt_sq_sin_cos_precision => {{ o1.type|upper }}_{{ o2.type|upper }}_SIN_COS_PRECISION,
  {%- endif %}              
{%- endblock muon_correlation_cuts %}

