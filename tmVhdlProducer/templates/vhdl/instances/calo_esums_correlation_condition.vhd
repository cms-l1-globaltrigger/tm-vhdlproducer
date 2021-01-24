{% extends "instances/sub_templ/correlation_condition.vhd" %}

{% block entity %}work.correlation_conditions{% endblock %}

{%- block correlation_cuts %}
-- correlation cuts
    {%- if condition.deltaPhi %}
        dphi_cut => {{ condition.deltaPhi | vhdl_bool }},
        dphi_upper_limit_vector => X"{{ condition.deltaPhi.upper|X08 }}", 
        dphi_lower_limit_vector => X"{{ condition.deltaPhi.lower|X08 }}",
    {%- endif %}        
    {%- if (condition.mass) or (condition.twoBodyPt) %}
        pt1_width => {{ o1.type|upper }}_PT_VECTOR_WIDTH, 
        pt2_width => {{ o2.type|upper }}_PT_VECTOR_WIDTH, 
    {%- endif %}        
    {%- if condition.mass %}
        mass_cut => {{ condition.mass | vhdl_bool }}, 
        mass_upper_limit_vector => X"{{ condition.mass.upper|X16 }}",
        mass_lower_limit_vector => X"{{ condition.mass.lower|X16 }}",
        mass_cosh_cos_precision => {{ o1.type|upper }}_{{ o2.type|upper }}_COSH_COS_PRECISION, 
        cosh_cos_width => {{ o1.type|upper }}_{{ o2.type|upper }}_COSH_COS_VECTOR_WIDTH,
    {%- endif %}        
    {%- if condition.twoBodyPt %}
        twobody_pt_cut => {{ condition.twoBodyPt | vhdl_bool }}, 
        pt_sq_threshold_vector => X"{{ condition.twoBodyPt.threshold|X16 }}", 
        sin_cos_width => CALO_SIN_COS_VECTOR_WIDTH, 
        pt_sq_sin_cos_precision => {{ o1.type|upper }}_{{ o2.type|upper }}_SIN_COS_PRECISION,
    {%- endif %}
{%- endblock %}

{%- block generic_map_end %}
-- number of calo objects, types
        nr_obj1 => NR_{{ o1.type|upper }}_OBJECTS,
        type_obj1 => {{ o1.type|upper }}_TYPE,
        same_bx => {{ condition.objectsInSameBx | vhdl_bool }}
{%- endblock %}

{%- block port_map %}
        obj1 => {{ o1.type|lower }}_bx_{{ o1.bx }}, 
        esums => {{ o2.type|lower }}_bx_{{ o2.bx }},
    {%- if condition.deltaPhi %}
        dphi => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_vector,
    {%- endif %}        
    {%- if (condition.mass) or (condition.twoBodyPt) %}
        pt1 => {{ o1.type|lower }}_bx_{{ o1.bx }}_pt_vector, 
        pt2 => {{ o2.type|lower }}_bx_{{ o2.bx }}_pt_vector,
    {%- endif %}        
    {%- if condition.mass %}
        cos_dphi => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector,
    {%- endif %}        
    {%- if condition.twoBodyPt %}
        cos_phi_1_integer => {{ o1.type|lower }}_bx_{{ o1.bx }}_cos_phi, 
        cos_phi_2_integer => {{ o2.type|lower }}_bx_{{ o2.bx }}_cos_phi, 
        sin_phi_1_integer => {{ o1.type|lower }}_bx_{{ o1.bx }}_sin_phi, 
        sin_phi_2_integer => {{ o2.type|lower }}_bx_{{ o2.bx }}_sin_phi,
    {%- endif %}        
{%- endblock %}
