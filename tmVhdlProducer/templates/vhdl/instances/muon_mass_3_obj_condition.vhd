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
        mass_upper_limit_vector => X"{{ condition.mass.upper | X16 }}",
        mass_lower_limit_vector => X"{{ condition.mass.lower | X16 }}",
        mass_vector_width => MU_PT_VECTOR_WIDTH+MU_PT_VECTOR_WIDTH+MU_MU_COSH_COS_VECTOR_WIDTH,
-- number of object 2
        nr_obj2 => NR_MU_OBJECTS,
        mass_3_obj => true,
-- selector same/different bunch crossings
        same_bx => {{ condition.objectsInSameBx | vhdl_bool}}
{%- endblock %}

{%- block port_map %}
        obj1 => mu_bx_{{ o1.bx }},
        obj2 => mu_bx_{{ o2.bx }},
        obj3 => mu_bx_{{ o3.bx }},
    {%- if condition.chargeCorrelation %}
        ls_charcorr_triple => ls_charcorr_triple_bx_{{ o1.bx }}_bx_{{ o1.bx }},
        os_charcorr_triple => os_charcorr_triple_bx_{{ o1.bx }}_bx_{{ o1.bx }},
    {%- endif %}
        mass_inv_pt => mu_mu_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_inv_pt,
{%- endblock %}
