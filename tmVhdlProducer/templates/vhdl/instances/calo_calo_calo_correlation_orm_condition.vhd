{%- extends "instances/correlation_conditions_base.vhd" %}
{%- block instantiate_calo_calo_calo_correlation_orm_condition %}
  {%- set o1 = condition.objects[0] %}
  {%- set o2 = condition.objects[1] %}
  {%- if condition.nr_objects == 3 %}
    {%- set o3 = condition.objects[2] %}
  {%- endif %}        
  {%- block entity %}
{{ condition.vhdl_signal }}_i: entity work.calo_calo_calo_correlation_orm_condition
  {%- endblock entity %}
  {%- block generic_beg %}
-- correlation cuts
    {%- if condition.deltaEtaOrm.enabled == 'true' %}
        deta_orm_cut => {{ condition.deltaEtaOrm.enabled }}, 
    {%- endif %}        
    {%- if condition.deltaPhiOrm.enabled == 'true' %}
        dphi_orm_cut => {{ condition.deltaPhiOrm.enabled }}, 
    {%- endif %}        
    {%- if condition.deltaROrm.enabled == 'true' %}
        dr_orm_cut => {{ condition.deltaROrm.enabled }}, 
    {%- endif %}        
    {%- if condition.deltaEta.enabled == 'true' %}
        deta_cut => {{ condition.deltaEta.enabled }}, 
    {%- endif %}        
    {%- if condition.deltaPhi.enabled == 'true' %}
        dphi_cut => {{ condition.deltaPhi.enabled }}, 
    {%- endif %}        
    {%- if condition.deltaR.enabled == 'true' %}
        dr_cut => {{ condition.deltaR.enabled }}, 
    {%- endif %}        
    {%- if condition.mass.enabled == 'true' %}
        mass_cut => {{ condition.mass.enabled }}, 
        mass_type => INVARIANT_MASS_TYPE, 
    {%- endif %}        
    {%- if condition.twoBodyPt.enabled == 'true' %}
        twobody_pt_cut => {{ condition.twoBodyPt.enabled }}, 
    {%- endif %}        
  {%- endblock generic_beg %}
  {%- block correlation_cuts %}
    {%- set o1 = condition.objects[0] %}
    {%- set o2 = condition.objects[1] %}
-- correlation cuts
    {%- if condition.hasDeltaEtaOrm %}
        diff_eta_orm_upper_limit_vector => X"{{ condition.deltaEtaOrm.upper|X08 }}", 
        diff_eta_orm_lower_limit_vector => X"{{ condition.deltaEtaOrm.lower|X08 }}",
    {%- endif %}        
    {%- if condition.hasDeltaPhiOrm %}
        diff_phi_orm_upper_limit_vector => X"{{ condition.deltaPhiOrm.upper|X08 }}", 
        diff_phi_orm_lower_limit_vector => X"{{ condition.deltaPhiOrm.lower|X08 }}",
    {%- endif %}        
    {%- if condition.hasDeltaROrm %}
        dr_orm_upper_limit_vector => X"{{ condition.deltaROrm.upper|X16 }}", 
        dr_orm_lower_limit_vector => X"{{ condition.deltaROrm.lower|X16 }}",
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
    {%- if (condition.hasMass) or (condition.hasTwoBodyPt)  %}
        pt1_width => {{ o1.type|upper }}_PT_VECTOR_WIDTH, 
        pt2_width => {{ o2.type|upper }}_PT_VECTOR_WIDTH, 
    {%- endif %}        
    {%- if condition.hasMass %}
        mass_upper_limit_vector => X"{{ condition.mass.upper|X16 }}",
        mass_lower_limit_vector => X"{{ condition.mass.lower|X16 }}",
        mass_cosh_cos_precision => {{ o1.type|upper }}_{{ o2.type|upper }}_COSH_COS_PRECISION, 
        cosh_cos_width => {{ o1.type|upper }}_{{ o2.type|upper }}_COSH_COS_VECTOR_WIDTH,
    {%- endif %}        
    {%- if condition.hasTwoBodyPt %}
        pt_sq_threshold_vector => X"{{ condition.twoBodyPt.threshold|X16 }}", 
        sin_cos_width => CALO_SIN_COS_VECTOR_WIDTH, 
        pt_sq_sin_cos_precision => {{ o1.type|upper }}_{{ o2.type|upper }}_SIN_COS_PRECISION,
    {%- endif %}        
  {%- endblock correlation_cuts %}
  {%- block generic_end %}
-- selector one or two objects with orm
    {%- if condition.nr_objects == 3 %}
        obj_2plus1 => true
    {%- else %}        
        obj_2plus1 => false
    {%- endif %}        
  {%- endblock generic_end %}
  {%- block port %}
    {%- set o1 = condition.objects[0] %}
    {%- set o2 = condition.objects[1] %}
    {%- if condition.nr_objects == 3 %}
      {%- set o3 = condition.objects[2] %}
    {%- endif %}        
        lhc_clk, {{ o1.type|lower }}_bx_{{ o1.bx }}, {{ o2.type|lower }}_bx_{{ o2.bx }}, {{ o3.type|lower }}_bx_{{ o3.bx }},
    {%- if condition.nr_objects == 3 %}
        diff_eta_orm => diff_{{ o1.type|lower }}_{{ o3.type|lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_eta_vector,        
        diff_phi_orm => diff_{{ o1.type|lower }}_{{ o3.type|lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_phi_vector,
    {%- else %}        
        diff_eta_orm => diff_{{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_eta_vector,        
        diff_phi_orm => diff_{{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_phi_vector,
    {%- endif %}        
        diff_eta => diff_{{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_eta_vector,        
        diff_phi => diff_{{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_phi_vector,
    {%- if (condition.hasMass) or (condition.hasTwoBodyPt) %}
        pt1 => {{ o1.type|lower }}_pt_vector_bx_{{ o1.bx }}, 
        pt2 => {{ o2.type|lower }}_pt_vector_bx_{{ o2.bx }},
    {%- endif %}        
    {%- if condition.hasMass %}
        cosh_deta => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_deta_vector, 
        cos_dphi => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector,
    {%- endif %}        
    {%- if condition.hasTwoBodyPt %}
        cos_phi_1_integer => {{ o1.type|lower }}_cos_phi_bx_{{ o1.bx }}, 
        cos_phi_2_integer => {{ o2.type|lower }}_cos_phi_bx_{{ o2.bx }}, 
        sin_phi_1_integer => {{ o1.type|lower }}_sin_phi_bx_{{ o1.bx }}, 
        sin_phi_2_integer => {{ o2.type|lower }}_sin_phi_bx_{{ o2.bx }},
    {%- endif %}        
        condition_o => {{ condition.vhdl_signal }}
  {%- endblock port %}
{%- endblock instantiate_calo_calo_calo_correlation_orm_condition %}
{# eof #}
