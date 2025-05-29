{% extends "instances/base/correlation_condition.vhd" %}

{% from "macros.vhd" import signal_base %}

{% block entity %}work.correlation_conditions{% endblock %}

{%- block generic_map -%}
{{ super() }}
-- correlation cuts orm
  {%- include "instances/base/correlation_cuts_orm.vhd" %}
-- number of objects and type
  {%- for i in range(0,condition.nr_objects) %}
    {%- set o = condition.objects[i] %}
        nr_obj{{ i + 1 }} => NR_{{ o.type | upper }}_OBJECTS,
        type_obj{{ i + 1 }} => {{ o.type | upper }}_TYPE,
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
        calo_obj1 => bx_data.{{ o1.type | lower }}({{ o1.bx_arr }}),
        calo_obj2 => bx_data.{{ o2.type | lower }}({{ o2.bx_arr }}),
  {%- if condition.nr_objects == 3 %}
        calo_obj3 => bx_data.{{ o3.type | lower }}({{ o3.bx_arr }}),
  {%- endif %}
  {%- if condition.deltaEtaOrm %}
        deta_orm => {{ signal_base(condition.sorted_objects) }}_deta,
  {%- endif %}
  {%- if condition.deltaPhiOrm %}
        dphi_orm => {{ signal_base(condition.sorted_objects) }}_dphi,
  {%- endif %}
  {%- if condition.deltaROrm %}
        dr_orm => {{ signal_base(condition.sorted_objects) }}_dr,
  {%- endif %}
  {%- if condition.deltaEta %}
        deta => {{ signal_base(condition.sorted_objects) }}_deta,
  {%- endif %}
  {%- if condition.deltaPhi %}
        dphi => {{ signal_base(condition.sorted_objects) }}_dphi,
  {%- endif %}
  {%- if condition.deltaR %}
        dr => {{ signal_base(condition.sorted_objects) }}_dr,
  {%- endif %}
  {%- if condition.mass and condition.mass.type == condition.mass.InvariantMassType %}
        mass_inv_pt => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_inv_pt,
  {%- endif %}
  {%- if condition.twoBodyPt %}
        tbpt => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_tbpt,
  {%- endif %}
{%- endblock %}
