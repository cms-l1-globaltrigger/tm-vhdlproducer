{% extends "instances/base/condition.vhd" %}

{%- set o1 = condition.objects[0] %}
{%- set o2 = condition.objects[1] %}
{%- set o3 = condition.objects[2] %}

{% block entity %}work.correlation_conditions_muon{% endblock %}

{%- block generic_map %}
-- obj cuts
    {%- set o = condition.objects[0] %}
    {%- include  "instances/base/object_cuts_correlation.vhd" %}
-- correlation cuts
        pt1_width => {{ o1.type | upper }}_PT_VECTOR_WIDTH,
        pt2_width => {{ o2.type | upper }}_PT_VECTOR_WIDTH,
        mass_cut => {{ condition.mass | vhdl_bool }},
        mass_type => {{ condition.mass.type }},
        mass_upper_limit_vector => X"{{ condition.mass.upper | X16 }}",
        mass_lower_limit_vector => X"{{ condition.mass.lower | X16 }}",
        mass_cosh_cos_precision => {{ o1.type | upper }}_{{ o2.type | upper }}_COSH_COS_PRECISION,
        cosh_cos_width => {{ o1.type | upper }}_{{ o2.type | upper }}_COSH_COS_VECTOR_WIDTH,
-- number of object 2
        nr_obj2 => NR_MU_OBJECTS,
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
