{% extends "instances/base/correlation_condition.vhd" %}

{% block entity %}work.correlation_conditions_muon{% endblock %}

{%- block generic_map -%}
{{ super() }}
-- number of object 2
        nr_obj2 => NR_{{ o2.type | upper }}_OBJECTS,
-- selector same/different bunch crossings
        same_bx => {{ condition.objectsInSameBx | vhdl_bool }}
{%- endblock %}

{%- block port_map %}
        obj1 => {{ o1.type | lower }}_bx_{{ o1.bx }},
        esums => {{ o2.type | lower }}_bx_{{ o2.bx }},
    {%- if condition.deltaPhi %}
        dphi => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_vector,
    {%- endif %}
    {%- if condition.mass or condition.twoBodyPt %}
        pt1 => {{ o1.type | lower }}_bx_{{ o1.bx }}_pt_vector,
        pt2 => {{ o2.type | lower }}_bx_{{ o2.bx }}_pt_vector,
    {%- endif %}
    {%- if condition.mass %}
        cos_dphi => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector,
    {%- endif %}
    {%- if condition.twoBodyPt %}
        cos_phi_1_integer => {{ o1.type | lower }}_bx_{{ o1.bx }}_cos_phi,
        cos_phi_2_integer => {{ o2.type | lower }}_bx_{{ o2.bx }}_cos_phi,
        sin_phi_1_integer => {{ o1.type | lower }}_bx_{{ o1.bx }}_sin_phi,
        sin_phi_2_integer => {{ o2.type | lower }}_bx_{{ o2.bx }}_sin_phi,
    {%- endif %}
    {%- if condition.mass and condition.mass.type == condition.mass.TransverseMassType %}
        mass_trans => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_trans,
    {%- endif %}
{%- endblock %}
