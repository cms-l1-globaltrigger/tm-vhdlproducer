{% extends "instances/base/comb_condition.vhd" %}

{% set o5 = condition.objects[4] %}
{% set base_objects = condition.objects[:4] %}
{% set nr_requirements = condition.nr_objects - 1 %}
{% set orm_obj = condition.objects[nr_requirements] %}

{% block entity %}work.comb_conditions{% endblock %}

{% block generic_map %}
-- setting slice high value(s) instead of default value(s) ("NR_MU_OBJECTS-1" => 7)
  {%- for i in range(0,condition.nr_objects-1) %}
    {%- if not condition.objects[i].slice %}
        slice_{{i+1}}_high_obj1 => {{ condition.objects[i].slice.upper }},
    {%- endif %}
  {%- endfor %}
  {%- if not orm_obj.slice %}
        slice_high_obj2 => {{ orm_obj.slice.upper }},
  {%- endif %}
-- object cuts
  {%- if not o1.operator %}
        pt_ge_mode_obj1 => {{ o1.operator|vhdl_bool }},
  {%- endif %}
  {%- include "instances/base/object_cuts_calo_orm.vhd" %}
  {%- include "instances/base/correlation_cuts_comb.vhd" %}
-- correlation cuts orm
  {%- include "instances/base/correlation_cuts_orm.vhd" %}
-- number of objects and type
  {%- set o_orm = condition.objects[nr_requirements] %}
        nr_obj1 => NR_{{ o1.type | upper }}_OBJECTS,
        type_obj1 => {{ o1.type | upper }}_TYPE,
        nr_obj2 => NR_{{ o_orm.type | upper }}_OBJECTS,
        type_obj2 => {{ o_orm.type | upper }}_TYPE,
        nr_templates => {{ nr_requirements }}
{%- endblock %}

{% block port_map %}
        obj1_calo => bx_data.{{ o1.type | lower }}({{ o1.bx_arr }}),
  {%- if nr_requirements == 4 %}
        obj2 => bx_data.{{ o5.type | lower }}({{ o5.bx_arr }}),
    {%- if condition.deltaEtaOrm %}
        deta_orm => {{ o1.type | lower }}_{{ o5.type | lower }}_bx_{{ o1.bx }}_bx_{{ o5.bx }}_deta,
    {%- endif %}
    {%- if condition.deltaPhiOrm %}
        dphi_orm => {{ o1.type | lower }}_{{ o5.type | lower }}_bx_{{ o1.bx }}_bx_{{ o5.bx }}_dphi,
    {%- endif %}
    {%- if condition.deltaROrm %}
        dr_orm => {{ o1.type | lower }}_{{ o5.type | lower }}_bx_{{ o1.bx }}_bx_{{ o5.bx }}_dr,
    {%- endif %}
  {%- elif nr_requirements == 3 %}
        obj2 => bx_data.{{ o4.type | lower }}({{ o4.bx_arr }}),
    {%- if condition.deltaEtaOrm %}
        deta_orm => {{ o1.type | lower }}_{{ o4.type | lower }}_bx_{{ o1.bx }}_bx_{{ o4.bx }}_deta,
    {%- endif %}
    {%- if condition.deltaPhiOrm %}
        dphi_orm => {{ o1.type | lower }}_{{ o4.type | lower }}_bx_{{ o1.bx }}_bx_{{ o4.bx }}_dphi,
    {%- endif %}
    {%- if condition.deltaROrm %}
        dr_orm => {{ o1.type | lower }}_{{ o4.type | lower }}_bx_{{ o1.bx }}_bx_{{ o4.bx }}_dr,
    {%- endif %}
  {%- elif nr_requirements == 2 %}
        obj2 => bx_data.{{ o3.type | lower }}({{ o3.bx_arr }}),
    {%- if condition.deltaEtaOrm %}
        deta_orm => {{ o1.type | lower }}_{{ o3.type | lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_deta,
    {%- endif %}
    {%- if condition.deltaPhiOrm %}
        dphi_orm => {{ o1.type | lower }}_{{ o3.type | lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_dphi,
    {%- endif %}
    {%- if condition.deltaROrm %}
        dr_orm => {{ o1.type | lower }}_{{ o3.type | lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_dr,
    {%- endif %}
  {%- elif nr_requirements == 1 %}
        obj2 => bx_data.{{ o2.type | lower }}({{ o2.bx_arr }}),
    {%- if condition.deltaEtaOrm %}
        deta_orm => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta,
    {%- endif %}
    {%- if condition.deltaPhiOrm %}
        dphi_orm => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi,
    {%- endif %}
    {%- if condition.deltaROrm %}
        dr_orm => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dr,
    {%- endif %}
  {%- endif %}
  {%- if condition.twoBodyPt %}
        tbpt => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_tbpt,
  {%- endif %}
{%- endblock %}
