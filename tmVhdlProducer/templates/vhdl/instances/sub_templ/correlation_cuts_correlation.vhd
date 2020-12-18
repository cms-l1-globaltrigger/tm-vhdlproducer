{%- if condition.nr_objects == 2 %}        
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
        mass_type => {{ condition.mass.InvariantMassDeltaRType }},
    {%- elif condition.mass.type == condition.mass.InvariantMassType %}
        mass_type => {{ condition.mass.InvariantMassType }}, 
    {%- endif %}        
  {%- endif %}        
  {%- if condition.hasTwoBodyPt %}
        twobody_pt_cut => {{ condition.twoBodyPt.enabled }}, 
  {%- endif %}                              
{%- endif %}                              
{%- if (o1.is_calo_type and o2.is_calo_type) %}
  {%- if (condition.hasMass) or (condition.hasTwoBodyPt) %}
        pt1_width => {{ o1.type|upper }}_PT_VECTOR_WIDTH, 
        pt2_width => {{ o2.type|upper }}_PT_VECTOR_WIDTH, 
  {%- endif %}        
  {%- if (condition.hasMass) and (condition.mass.type == condition.mass.InvariantMassDeltaRType) %}
        mass_div_dr_vector_width => {{ o1.type|upper }}_{{ o2.type|upper }}_MASS_DIV_DR_VECTOR_WIDTH,
        mass_div_dr_threshold => X"{{ condition.mass.lower|X21 }}",
  {%- endif %}        
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
{%- if (o1.is_calo_type and o2.is_calo_type) %}
  {%- if condition.hasMass and (condition.mass.type == condition.mass.InvariantMassType)%}
        mass_cosh_cos_precision => {{ o1.type|upper }}_{{ o2.type|upper }}_COSH_COS_PRECISION, 
        cosh_cos_width => {{ o1.type|upper }}_{{ o2.type|upper }}_COSH_COS_VECTOR_WIDTH,
    {%- if condition.nr_objects == 3 %}
        mass_upper_limit_vector => X"{{ condition.mass.upper|X16 }}",
        mass_lower_limit_vector => X"{{ condition.mass.lower|X16 }}",
    {%- elif condition.nr_objects == 2 %}        
        mass_upper_limit => X"{{ condition.mass.upper|X16 }}",
        mass_lower_limit => X"{{ condition.mass.lower|X16 }}",
    {%- endif %}        
  {%- endif %}        
  {%- if condition.hasTwoBodyPt %}
        pt_sq_threshold_vector => X"{{ condition.twoBodyPt.threshold|X16 }}", 
        sin_cos_width => CALO_SIN_COS_VECTOR_WIDTH, 
        pt_sq_sin_cos_precision => {{ o1.type|upper }}_{{ o2.type|upper }}_SIN_COS_PRECISION,
  {%- endif %}              
{%- elif (o1.is_calo_type and o2.is_muon_type) %}
  {%- if (condition.hasMass) and (condition.mass.type == condition.mass.InvariantMassDeltaRType) %}
        mass_div_dr_vector_width => {{ o1.type|upper }}_{{ o2.type|upper }}_MASS_DIV_DR_VECTOR_WIDTH,
        mass_div_dr_threshold => X"{{ condition.mass.lower|X21 }}",
  {%- endif %}        
  {%- if condition.hasMass and (condition.mass.type == condition.mass.InvariantMassType)%}
        mass_upper_limit => X"{{ condition.mass.upper|X16 }}",
        mass_lower_limit => X"{{ condition.mass.lower|X16 }}",
  {%- endif %}        
  {%- if (condition.hasMass and (condition.mass.type == condition.mass.InvariantMassType)) or condition.hasTwoBodyPt %}
        pt1_width => {{ o1.type|upper }}_PT_VECTOR_WIDTH, 
        pt2_width => {{ o2.type|upper }}_PT_VECTOR_WIDTH, 
  {%- endif %}        
  {%- if condition.hasMass and (condition.mass.type == condition.mass.InvariantMassType)%}
        mass_cosh_cos_precision => {{ o1.type|upper }}_{{ o2.type|upper }}_COSH_COS_PRECISION, 
        cosh_cos_width => {{ o1.type|upper }}_{{ o2.type|upper }}_COSH_COS_VECTOR_WIDTH,
  {%- endif %}        
  {%- if condition.hasTwoBodyPt %}
        pt_sq_threshold_vector => X"{{ condition.twoBodyPt.threshold|X16 }}", 
        sin_cos_width => CALO_SIN_COS_VECTOR_WIDTH, 
        pt_sq_sin_cos_precision => {{ o1.type|upper }}_{{ o2.type|upper }}_SIN_COS_PRECISION,
  {%- endif %}              
{%- elif (o1.is_muon_type and o2.is_muon_type) %}
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
  {%- endif %}              
{%- endif %}        

