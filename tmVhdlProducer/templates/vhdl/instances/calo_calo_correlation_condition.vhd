{% extends "instances/base/correlation_condition.vhd" %}

{% from "macros.vhd" import signal_base %}

{% block entity %}work.correlation_conditions{% endblock %}

{%- block generic_map -%}
{{ super() }}
-- number of objects and type
  {%- for i in range(0,condition.nr_objects) %}
    {%- set o = condition.objects[i] %}
        nr_obj{{ i + 1 }} => NR_{{ o.type | upper }}_OBJECTS,
        type_obj{{ i + 1 }} => {{ o.type | upper }}_TYPE,
  {%- endfor %}
-- selector same/different bunch crossings
        same_bx => {{ condition.objectsInSameBx | vhdl_bool }}
{%- endblock %}

{%- block port_map %}
        calo_obj1 => bx_data.{{ o1.type | lower }}({{ o1.bx_arr }}),
        calo_obj2 => bx_data.{{ o2.type | lower }}({{ o2.bx_arr }}),
  {%- if condition.mass and condition.mass.type == condition.mass.InvariantMassDeltaRType %}
        mass_div_dr => {{ signal_base(condition.sorted_objects) }}_mass_over_dr,
  {%- else %}
    {%- if (condition.deltaEta) or (condition.deltaR) %}
        deta => {{ signal_base(condition.sorted_objects) }}_deta,
    {%- endif %}
    {%- if (condition.deltaPhi) or (condition.deltaR) %}
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
  {%- endif %}
{%- endblock %}
