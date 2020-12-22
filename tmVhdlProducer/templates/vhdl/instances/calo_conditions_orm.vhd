{% extends "instances/sub_templ/comb_condition.vhd" %}

{% set o5 = condition.objects[4] %}
{% set nr_requirements = condition.nr_objects-1 %}

{% block entity %}work.calo_conditions_orm{% endblock %}

{% block generic_map %}
  {%- for i in range(1,nr_requirements) %}
    {%- set o = condition.objects[i] %}
    {%- if nr_requirements > i and o.hasSlice %}
        slice_{{i+1}}_low_obj1 => {{ o.sliceLow }}, 
        slice_{{i+1}}_high_obj1 => {{ o.sliceHigh }}, 
    {%- endif %}        
  {%- endfor %}        
  {%- if not o1.operator %}
        pt_ge_mode_obj1 => {{ o1.operator|vhdl_bool }}, 
  {%- endif %}          
  {%- include "instances/sub_templ/object_cuts_calo_orm.vhd" %}
  {%- include "instances/sub_templ/correlation_cuts_comb.vhd" %}
-- correlation cuts orm
  {%- include "instances/sub_templ/correlation_cuts_orm.vhd" %}
-- number of objects and type
  {%- set o_orm = condition.objects[nr_requirements] %}
        nr_obj1 => NR_{{ o1.type|upper }}_OBJECTS,
        type_obj1 => {{ o1.type|upper }}_TYPE,
        nr_obj2 => NR_{{ o_orm.type|upper }}_OBJECTS,
        type_obj2 => {{ o_orm.type|upper }}_TYPE,
        nr_templates => {{ nr_requirements }}
{%- endblock %}

{% block port_map %}
        {{ o1.type|lower }}_bx_{{ o1.bx }}, 
  {%- if nr_requirements == 4 %}
        {{ o5.type|lower }}_bx_{{ o5.bx }},
        {{ o1.type|lower }}_{{ o5.type|lower }}_bx_{{ o1.bx }}_bx_{{ o5.bx }}_deta_vector, 
        {{ o1.type|lower }}_{{ o5.type|lower }}_bx_{{ o1.bx }}_bx_{{ o5.bx }}_dphi_vector,
  {%- elif nr_requirements == 3 %}
        {{ o4.type|lower }}_bx_{{ o4.bx }},
        {{ o1.type|lower }}_{{ o4.type|lower }}_bx_{{ o1.bx }}_bx_{{ o4.bx }}_deta_vector, 
        {{ o1.type|lower }}_{{ o4.type|lower }}_bx_{{ o1.bx }}_bx_{{ o4.bx }}_dphi_vector,
  {%- elif nr_requirements == 2 %}
        {{ o3.type|lower }}_bx_{{ o3.bx }},
        {{ o1.type|lower }}_{{ o3.type|lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_deta_vector, 
        {{ o1.type|lower }}_{{ o3.type|lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_dphi_vector,
  {%- elif nr_requirements == 1 %}
        {{ o2.type|lower }}_bx_{{ o2.bx }},
        {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_vector, 
        {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_vector,
  {%- endif %}    
  {%- if condition.hasTwoBodyPt %}
        pt => {{ o1.type|lower }}_bx_{{ o1.bx }}_pt_vector, 
        cos_phi_integer => {{ o1.type|lower }}_bx_{{ o1.bx }}_cos_phi, 
        sin_phi_integer => {{ o1.type|lower }}_bx_{{ o1.bx }}_sin_phi,
  {%- endif %}
{%- endblock %}
