{% extends "instances/sub_templ/correlation_condition.vhd" %}

{% block entity %}work.correlation_conditions_calo{% endblock %}

{%- block correlation_cuts %}
-- correlation cuts
        pt1_width => {{ o1.type|upper }}_PT_VECTOR_WIDTH, 
        mass_upper_limit_vector => X"{{ condition.mass.upper|X16 }}", 
        mass_lower_limit_vector => X"{{ condition.mass.lower|X16 }}",
        cosh_cos_precision => {{ o1.type|upper }}_{{ o1.type|upper }}_COSH_COS_PRECISION, 
        cosh_cos_width => {{ o1.type|upper }}_{{ o1.type|upper }}_COSH_COS_VECTOR_WIDTH,
{%- endblock %}

{%- block generic_map_end %}
        nr_obj1 => NR_{{ o1.type|upper }}_OBJECTS,
        type_obj1 => {{ o1.type|upper }}_TYPE,
        mass_3_obj => true,
        same_bx => {{ condition.objectsInSameBx | vhdl_bool}}
{%- endblock %}

{%- block port_map %}
        obj1 => {{ o1.type|lower }}_bx_{{ o1.bx }}, 
        pt1 => {{ o1.type|lower }}_bx_{{ o1.bx }}_pt_vector,
        cosh_deta => {{ o1.type|lower }}_{{ o1.type|lower }}_bx_{{ o1.bx }}_bx_{{ o1.bx }}_cosh_deta_vector, 
        cos_dphi => {{ o1.type|lower }}_{{ o1.type|lower }}_bx_{{ o1.bx }}_bx_{{ o1.bx }}_cos_dphi_vector,
{%- endblock %}
