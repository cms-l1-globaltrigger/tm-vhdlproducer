{% extends "instances/base/correlation_condition.vhd" %}

{% block entity %}work.correlation_conditions{% endblock %}

{%- block generic_map -%}
{{ super() }}
-- correlation cuts orm
  {%- include "instances/base/correlation_cuts_orm.vhd" %}
-- number of objects and type
  {%- for i in range(0,condition.nr_objects) %}
    {%- set o = condition.objects[i] %}
        nr_obj{{i+1}} => NR_{{ o.type | upper }}_OBJECTS,
        type_obj{{i+1}} => {{ o.type | upper }}_TYPE,
  {%- endfor %}
-- selector one or two objects with orm
  {%- if condition.nr_objects == 3 %}
        obj_2plus1 => true,
  {%- elif condition.nr_objects == 2 %}
        nr_obj3 => MAX_CALO_OBJECTS, -- default number of calo3 input
        obj_2plus1 => false,
  {%- endif %}
-- selector same/different bunch crossings
        same_bx => {{ condition.objectsInSameBx | vhdl_bool }}
{%- endblock %}

{%- block port_map %}
  {%- set o1 = condition.objects[0] %}
  {%- set o2 = condition.objects[1] %}
        calo_obj1 => {{ o1.type | lower }}_bx_{{ o1.bx }},
        calo_obj2 => {{ o2.type | lower }}_bx_{{ o2.bx }},
  {%- if condition.nr_objects == 3 %}
    {%- set o3 = condition.objects[2] %}
        calo_obj3 => {{ o3.type | lower }}_bx_{{ o3.bx }},
  {%- endif %}
  {%- if condition.deltaEtaOrm %}
    {%- if condition.nr_objects == 3 %}
        deta_orm => {{ o1.type | lower }}_{{ o3.type | lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_deta,
    {%- elif condition.nr_objects == 2 %}
        deta_orm => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta,
    {%- endif %}
  {%- endif %}
  {%- if condition.deltaPhiOrm %}
    {%- if condition.nr_objects == 3 %}
        dphi_orm => {{ o1.type | lower }}_{{ o3.type | lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_dphi,
    {%- elif condition.nr_objects == 2 %}
        dphi_orm => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi,
    {%- endif %}
  {%- endif %}
  {%- if condition.deltaROrm %}
    {%- if condition.nr_objects == 3 %}
        dr_orm => {{ o1.type | lower }}_{{ o3.type | lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_dr,
    {%- elif condition.nr_objects == 2 %}
        dr_orm => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dr,
    {%- endif %}
  {%- endif %}
  {%- if condition.deltaEta %}
        deta => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta,
  {%- endif %}
  {%- if condition.deltaPhi %}
        dphi => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi,
  {%- endif %}
  {%- if condition.deltaR %}
        dr => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dr,
  {%- endif %}
  {%- if condition.mass and condition.mass.type == condition.mass.InvariantMassType %}
        mass_inv_pt => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_inv_pt,
  {%- endif %}
  {%- if condition.twoBodyPt %}
        tbpt => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_tbpt,
  {%- endif %}
{%- endblock %}
