{% extends "instances/base/correlation_condition.vhd" %}

{% block entity %}work.correlation_conditions_calo{% endblock %}

{%- block correlation_orm %}
-- correlation cuts orm
  {%- include "instances/base/correlation_cuts_orm.vhd" %}
{%- endblock %}

{%- block generic_map_end %}
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
        same_bx => {{ condition.objectsInSameBx | vhdl_bool }}
{%- endblock %}

{%- block port_map %}
  {%- set o1 = condition.objects[0] %}
  {%- set o2 = condition.objects[1] %}
        obj1 => {{ o1.type | lower }}_bx_{{ o1.bx }},
        obj2 => {{ o2.type | lower }}_bx_{{ o2.bx }},
  {%- if condition.nr_objects == 3 %}
    {%- set o3 = condition.objects[2] %}
        obj3 => {{ o3.type | lower }}_bx_{{ o3.bx }},
  {%- endif %}
  {%- if condition.nr_objects == 3 %}
        deta_orm => {{ o1.type | lower }}_{{ o3.type | lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_deta_vector,
        dphi_orm => {{ o1.type | lower }}_{{ o3.type | lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_dphi_vector,
  {%- elif condition.nr_objects == 2 %}
        deta_orm => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_vector,
        dphi_orm => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_vector,
  {%- endif %}
  {%- if (condition.deltaEta) or (condition.deltaR) %}
        deta => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_vector,
  {%- endif %}
  {%- if (condition.deltaPhi) or (condition.deltaR) %}
        dphi => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_vector,
  {%- endif %}
  {%- if (condition.mass) or (condition.twoBodyPt) %}
        pt1 => {{ o1.type | lower }}_bx_{{ o1.bx }}_pt_vector,
        pt2 => {{ o2.type | lower }}_bx_{{ o2.bx }}_pt_vector,
  {%- endif %}
  {%- if condition.mass %}
        cosh_deta => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_deta_vector,
        cos_dphi => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector,
  {%- endif %}
  {%- if condition.twoBodyPt %}
        cos_phi_1_integer => {{ o1.type | lower }}_bx_{{ o1.bx }}_cos_phi,
        cos_phi_2_integer => {{ o2.type | lower }}_bx_{{ o2.bx }}_cos_phi,
        sin_phi_1_integer => {{ o1.type | lower }}_bx_{{ o1.bx }}_sin_phi,
        sin_phi_2_integer => {{ o2.type | lower }}_bx_{{ o2.bx }}_sin_phi,
  {%- endif %}
{%- endblock %}
