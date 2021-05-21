{%- extends "instances/base/comb_condition.vhd" %}

{%- block entity %}work.comb_conditions{% endblock entity %}

{%- block generic_map %}
{{ super() }}
-- number of objects and type
        nr_obj1 => NR_{{ o1.type }}_OBJECTS,
        type_obj1 => {{ o1.type }}_TYPE,
        nr_templates => {{ condition.nr_objects }}
{%- endblock %}

{%- block port_map %}
        obj1_muon => mu({{ o1.bx_arr }}),
    {%- if (condition.nr_objects == 2) and condition.twoBodyPt and condition.chargeCorrelation %}
        ls_charcorr_double => ls_charcorr_double_bx_{{ o1.bx }}_bx_{{ o1.bx }},
        os_charcorr_double => os_charcorr_double_bx_{{ o1.bx }}_bx_{{ o1.bx }},
        tbpt => {{ o1.type | lower }}_{{ o1.type | lower }}_bx_{{ o1.bx }}_bx_{{ o1.bx }}_tbpt,
    {%- elif (condition.nr_objects == 2) and condition.twoBodyPt and not condition.chargeCorrelation %}
        tbpt => {{ o1.type | lower }}_{{ o1.type | lower }}_bx_{{ o1.bx }}_bx_{{ o1.bx }}_tbpt,
    {%- elif (condition.nr_objects == 2) and not condition.twoBodyPt and condition.chargeCorrelation %}
        ls_charcorr_double => ls_charcorr_double_bx_{{ o1.bx }}_bx_{{ o1.bx }},
        os_charcorr_double => os_charcorr_double_bx_{{ o1.bx }}_bx_{{ o1.bx }},
    {%- elif (condition.nr_objects == 3) and condition.chargeCorrelation %}
        ls_charcorr_triple => ls_charcorr_triple_bx_{{ o1.bx }}_bx_{{ o1.bx }},
        os_charcorr_triple => os_charcorr_triple_bx_{{ o1.bx }}_bx_{{ o1.bx }},
    {%- elif (condition.nr_objects == 4) and condition.chargeCorrelation %}
        ls_charcorr_quad => ls_charcorr_quad_bx_{{ o1.bx }}_bx_{{ o1.bx }},
        os_charcorr_quad => os_charcorr_quad_bx_{{ o1.bx }}_bx_{{ o1.bx }},
    {%- endif %}
{%- endblock %}
