{% extends "instances/base/correlation_condition.vhd" %}

{% block entity %}work.correlation_conditions{% endblock %}

{%- block generic_map %}
  {%- if not o1.slice %}
-- slices for muon
        slice_low_obj1 => {{ o1.slice.lower }},
        slice_high_obj1 => {{ o1.slice.upper }},
  {%- endif -%}
{{ super() }}
-- number of objects and type
  {%- for i in range(0,condition.nr_objects) %}
    {%- set o = condition.objects[i] %}
        nr_obj{{i+1}} => NR_{{ o.type | upper }}_OBJECTS,
        type_obj{{i+1}} => {{ o.type | upper }}_TYPE,
  {%- endfor %}
-- selector same/different bunch crossings
        same_bx => {{ condition.objectsInSameBx | vhdl_bool }}
{%- endblock %}

{%- block port_map %}
        muon_obj1 => {{ o1.type | lower }}({{ o1.bx_arr }}),
        esums => {{ o2.type | lower }}({{ o2.bx_arr }}),
    {%- if condition.deltaPhi %}
        dphi => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi,
    {%- endif %}
    {%- if condition.mass and condition.mass.type == condition.mass.TransverseMassType %}
        mass_trans => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_trans,
    {%- endif %}
    {%- if condition.twoBodyPt %}
        tbpt => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_tbpt,
    {%- endif %}
{%- endblock %}
