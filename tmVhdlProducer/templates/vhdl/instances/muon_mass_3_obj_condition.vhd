{% extends "instances/base/correlation_condition.vhd" %}

{% block entity %}work.correlation_conditions_muon{% endblock %}

{%- block correlation_cuts %}
        -- correlation cuts
        mass_upper_limit_vector => X"{{ condition.mass.upper | X16 }}",
        mass_lower_limit_vector => X"{{ condition.mass.lower | X16 }}",
        pt1_width => {{ o1.type | upper }}_PT_VECTOR_WIDTH,
        pt2_width => {{ o2.type | upper }}_PT_VECTOR_WIDTH,
        mass_cosh_cos_precision => {{ o1.type | upper }}_{{ o2.type | upper }}_COSH_COS_PRECISION,
        cosh_cos_width => {{ o1.type | upper }}_{{ o2.type | upper }}_COSH_COS_VECTOR_WIDTH,
{%- endblock %}

{%- block generic_map_end %}
-- number of object 2
        nr_obj2 => NR_{{ o2.type | upper }}_OBJECTS,
        mass_3_obj => true,
-- selector same/different bunch crossings
        same_bx => {{ condition.objectsInSameBx | vhdl_bool}}
{%- endblock %}

{%- block port_map %}
        obj1 => {{ o1.type | lower }}_bx_{{ o1.bx }}, 
        obj2 => {{ o2.type | lower }}_bx_{{ o2.bx }}, 
        obj3 => {{ o3.type | lower }}_bx_{{ o3.bx }}, 
    {%- if condition.chargeCorrelation %}
        ls_charcorr_triple => ls_charcorr_triple_bx_{{ o1.bx }}_bx_{{ o1.bx }}, 
        os_charcorr_triple => os_charcorr_triple_bx_{{ o1.bx }}_bx_{{ o1.bx }},
    {%- endif %}
        pt1 => {{ o1.type | lower }}_bx_{{ o1.bx }}_pt_vector,
        pt2 => {{ o2.type | lower }}_bx_{{ o2.bx }}_pt_vector,
        cosh_deta => {{ o1.type | lower }}_{{ o1.type | lower }}_bx_{{ o1.bx }}_bx_{{ o1.bx }}_cosh_deta_vector, 
        cos_dphi => {{ o1.type | lower }}_{{ o1.type | lower }}_bx_{{ o1.bx }}_bx_{{ o1.bx }}_cos_dphi_vector,
{%- endblock %}
