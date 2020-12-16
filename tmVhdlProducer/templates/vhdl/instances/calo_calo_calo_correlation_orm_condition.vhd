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
    {%- for i in range(0,condition.nr_objects) %}
      {%- set o = condition.objects[i] %}
        nr_obj{{i+1}} => NR_{{ o.type|upper }}_OBJECTS,       
        type_obj{{i+1}} => {{ o.type|upper }}_TYPE,       
    {%- endfor %}
  {%- endblock generic_beg %}
  {%- block correlation_cuts_orm %}
    {%- include "instances/correlation_cuts_orm.vhd" %}
  {%- endblock correlation_cuts_orm %}
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
