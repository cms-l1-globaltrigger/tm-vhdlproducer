{% extends "instances/sub_templ/correlation_condition.vhd" %}

{% block entity %}work.calo_calo_correlation_condition_orm{% endblock %}

{%- block correlation_orm %}
-- correlation cuts orm
  {%- include "instances/sub_templ/correlation_cuts_orm.vhd" %}
{%- endblock %}

{%- block generic_map_end %}
-- number of objects and type
  {%- for i in range(0,condition.nr_objects) %}
    {%- set o = condition.objects[i] %}
        nr_obj{{i+1}} => NR_{{ o.type|upper }}_OBJECTS,
        type_obj{{i+1}} => {{ o.type|upper }}_TYPE,
  {%- endfor %}
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
        calo1 => {{ o1.type|lower }}_bx_{{ o1.bx }},
        calo2 => {{ o2.type|lower }}_bx_{{ o2.bx }},
        calo3 => {{ o3.type|lower }}_bx_{{ o3.bx }},
  {%- elif condition.nr_objects == 2 %}        
        calo1 => {{ o1.type|lower }}_bx_{{ o1.bx }},
        calo3 => {{ o2.type|lower }}_bx_{{ o2.bx }},
  {%- endif %}        
  {%- if condition.nr_objects == 3 %}
    {%- if (condition.hasDeltaEtaOrm) or (condition.hasDeltaROrm) %}
        deta_orm => {{ o1.type|lower }}_{{ o3.type|lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_deta_vector,        
    {%- endif %}        
    {%- if (condition.hasDeltaPhiOrm) or (condition.hasDeltaROrm) %}
        dphi_orm => {{ o1.type|lower }}_{{ o3.type|lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_dphi_vector,
    {%- endif %}        
  {%- elif condition.nr_objects == 2 %}        
    {%- if (condition.hasDeltaEtaOrm) or (condition.hasDeltaROrm) %}
        deta_orm => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_vector,        
    {%- endif %}        
    {%- if (condition.hasDeltaPhiOrm) or (condition.hasDeltaROrm) %}
        dphi_orm => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_vector,
    {%- endif %}        
  {%- endif %}        
  {%- if (condition.hasDeltaEta) or (condition.hasDeltaR) %}
        deta => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_vector,        
  {%- endif %}        
  {%- if (condition.hasDeltaPhi) or (condition.hasDeltaR) %}
        dphi => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_vector,
  {%- endif %}        
  {%- if (condition.hasMass) or (condition.hasTwoBodyPt) %}
        pt1 => {{ o1.type|lower }}_bx_{{ o1.bx }}_pt_vector, 
        pt2 => {{ o2.type|lower }}_bx_{{ o2.bx }}_pt_vector,
  {%- endif %}        
  {%- if condition.hasMass %}
        cosh_deta => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_deta_vector, 
        cos_dphi => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector,
  {%- endif %}        
  {%- if condition.hasTwoBodyPt %}
        cos_phi_1_integer => {{ o1.type|lower }}_bx_{{ o1.bx }}_cos_phi, 
        cos_phi_2_integer => {{ o2.type|lower }}_bx_{{ o2.bx }}_cos_phi, 
        sin_phi_1_integer => {{ o1.type|lower }}_bx_{{ o1.bx }}_sin_phi, 
        sin_phi_2_integer => {{ o2.type|lower }}_bx_{{ o2.bx }}_sin_phi,
  {%- endif %}        
{%- endblock %}
