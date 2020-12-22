{% extends "instances/sub_templ/correlation_condition.vhd" %}

{% block entity %}work.calo_mass_3_obj_condition{% endblock %}

{%- block correlation_cuts %}
-- correlation cuts
        mass_upper_limit_vector => X"{{ condition.mass.upper|X16 }}", 
        mass_lower_limit_vector => X"{{ condition.mass.lower|X16 }}",
        pt_width => {{ o1.type|upper }}_PT_VECTOR_WIDTH, 
        cosh_cos_precision => {{ o1.type|upper }}_{{ o1.type|upper }}_COSH_COS_PRECISION, 
        cosh_cos_width => {{ o1.type|upper }}_{{ o1.type|upper }}_COSH_COS_VECTOR_WIDTH,
{%- endblock %}

{%- block generic_map_end %}
        nr_obj => NR_{{ o1.type|upper }}_OBJECTS,
        obj_type => {{ o1.type|upper }}_TYPE
{%- endblock %}

{%- block port_map %}
        {{ o1.type|lower }}_bx_{{ o1.bx }}, 
        {{ o1.type|lower }}_bx_{{ o1.bx }}_pt_vector,
        {{ o1.type|lower }}_{{ o1.type|lower }}_bx_{{ o1.bx }}_bx_{{ o1.bx }}_cosh_deta_vector, 
        {{ o1.type|lower }}_{{ o1.type|lower }}_bx_{{ o1.bx }}_bx_{{ o1.bx }}_cos_dphi_vector,
{%- endblock %}
