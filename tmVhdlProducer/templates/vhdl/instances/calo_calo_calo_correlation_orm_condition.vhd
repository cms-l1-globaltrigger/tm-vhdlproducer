{% extends "instances/correlation_condition.vhd" %}

{% block entity %}work.calo_calo_calo_correlation_orm_condition{% endblock %}

{%- block generic_map_beg %}
    {%- if condition.hasDeltaEtaOrm %}
        deta_orm_cut => {{ condition.deltaEtaOrm.enabled }}, 
    {%- endif %}        
    {%- if condition.hasDeltaPhiOrm %}
        dphi_orm_cut => {{ condition.deltaPhiOrm.enabled }}, 
    {%- endif %}        
    {%- if condition.hasDeltaROrm %}
        dr_orm_cut => {{ condition.deltaROrm.enabled }}, 
    {%- endif %}        
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
        mass_type => {{ condition.mass.InvariantMassType }}, 
    {%- endif %}        
    {%- if condition.hasTwoBodyPt %}
        twobody_pt_cut => {{ condition.twoBodyPt.enabled }}, 
    {%- endif %}        
{% endblock %}

{%- block correlation_orm %}
-- correlation cuts orm
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
{% endblock %}

{%- block generic_map_end %}
-- selector one or two objects with orm
    {%- if condition.nr_objects == 3 %}
        obj_2plus1 => true
    {%- else %}        
        obj_2plus1 => false
    {%- endif %}        
{%- endblock %}

{%- block port_map %}
  {%- set o1 = condition.objects[0] %}
  {%- set o2 = condition.objects[1] %}
  {%- if condition.nr_objects == 3 %}
    {%- set o3 = condition.objects[2] %}
  {%- endif %}        
        {{ o1.type|lower }}_bx_{{ o1.bx }},
        {{ o2.type|lower }}_bx_{{ o2.bx }},
        {{ o3.type|lower }}_bx_{{ o3.bx }},
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
{%- endblock %}
