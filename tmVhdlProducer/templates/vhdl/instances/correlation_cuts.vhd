{%- block correlation_cuts %}
-- correlation cuts
    {%- if condition.hasDeltaEta %}
        deta_cut => {{ condition.deltaEta.enabled }}, 
        deta_upper_limit_vector => X"{{ condition.deltaEta.upper|X08 }}", 
        deta_lower_limit_vector => X"{{ condition.deltaEta.lower|X08 }}",
    {%- endif %}        
    {%- if condition.hasDeltaPhi %}
        dphi_cut => {{ condition.deltaPhi.enabled }}, 
        dphi_upper_limit_vector => X"{{ condition.deltaPhi.upper|X08 }}", 
        dphi_lower_limit_vector => X"{{ condition.deltaPhi.lower|X08 }}",
    {%- endif %}        
    {%- if condition.hasDeltaR %}
        dr_cut => {{ condition.deltaR.enabled }}, 
        dr_upper_limit_vector => X"{{ condition.deltaR.upper|X16 }}", 
        dr_lower_limit_vector => X"{{ condition.deltaR.lower|X16 }}",
    {%- endif %}        
    {%- if (condition.hasMass) or (condition.hasTwoBodyPt) %}
        pt1_width => {{ o1.type|upper }}_PT_VECTOR_WIDTH, 
        pt2_width => {{ o2.type|upper }}_PT_VECTOR_WIDTH, 
    {%- endif %}        
    {%- if condition.hasMass %}
      {%- if condition.mass.type == condition.mass.InvariantMassDeltaRType %}
        mass_cut => {{ condition.mass.enabled }}, 
        mass_type => {{ condition.mass.InvariantMassDeltaRType }}, 
        mass_div_dr_vector_width => {{ o1.type|upper }}_{{ o2.type|upper }}_MASS_DIV_DR_VECTOR_WIDTH,
        mass_div_dr_threshold => X"{{ condition.mass.lower|X21 }}",
      {%- else %}        
        mass_cut => {{ condition.mass.enabled }},
        {%- if condition.mass.type == condition.mass.InvariantMassType %}
        mass_type => {{ condition.mass.InvariantMassType }},
        {%- elif condition.mass.type == condition.mass.TransverseMassType %}
        mass_type => {{ condition.mass.TransverseMassType }},
        {%- endif %}                
        mass_cosh_cos_precision => {{ o1.type|upper }}_{{ o2.type|upper }}_COSH_COS_PRECISION, 
        cosh_cos_width => {{ o1.type|upper }}_{{ o2.type|upper }}_COSH_COS_VECTOR_WIDTH,
        mass_upper_limit => X"{{ condition.mass.upper|X16 }}",
        mass_lower_limit => X"{{ condition.mass.lower|X16 }}",
      {%- endif %}        
    {%- endif %}        
    {%- if condition.hasTwoBodyPt %}
        twobody_pt_cut => {{ condition.twoBodyPt.enabled }}, 
        pt_sq_threshold_vector => X"{{ condition.twoBodyPt.threshold|X16 }}", 
          {%- if o2.is_calo_type %}
        sin_cos_width => CALO_SIN_COS_VECTOR_WIDTH, 
          {%- elif o2.is_muon_type %}
        sin_cos_width => MUON_SIN_COS_VECTOR_WIDTH, 
          {%- endif %}        
        pt_sq_sin_cos_precision => {{ o1.type|upper }}_{{ o2.type|upper }}_SIN_COS_PRECISION,
    {%- endif %}             
{%- endblock correlation_cuts %}

