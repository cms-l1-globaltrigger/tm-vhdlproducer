{%- extends "instances/correlation_conditions_base.vhd" %}
{%- set o1 = condition.objects[0] %}
{%- set o2 = condition.objects[1] %}
{%- set nr_calo_obj = 1 %}
{%- block entity %}
{{ condition.vhdl_signal }}_i: entity work.calo_esums_correlation_condition
{%- endblock entity %}
{%- block generic_end %}
-- number of calo objects, esums type
        nr_calo_objects => NR_{{ o1.type|upper }}_OBJECTS,
        obj_type_esums => {{ o2.type|upper }}_TYPE
{%- endblock generic_end %}
{%- block port %}
        lhc_clk, 
        {{ o1.type|lower }}_bx_{{ o1.bx }}, 
        {{ o2.type|lower }}_bx_{{ o2.bx }},
    {%- if condition.hasDeltaPhi %}
        diff_phi => diff_{{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_phi_vector,
    {%- endif %}        
    {%- if (condition.hasMass) or (condition.hasTwoBodyPt) %}
        pt1 => {{ o1.type|lower }}_pt_vector_bx_{{ o1.bx }}, 
        pt2 => {{ o2.type|lower }}_pt_vector_bx_{{ o2.bx }},
    {%- endif %}        
    {%- if condition.hasMass %}
        cos_dphi => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector,
    {%- endif %}        
    {%- if condition.hasTwoBodyPt %}
        cos_phi_1_integer => {{ o1.type|lower }}_cos_phi_bx_{{ o1.bx }}, 
        cos_phi_2_integer => {{ o2.type|lower }}_cos_phi_bx_{{ o2.bx }}, 
        sin_phi_1_integer => {{ o1.type|lower }}_sin_phi_bx_{{ o1.bx }}, 
        sin_phi_2_integer => {{ o2.type|lower }}_sin_phi_bx_{{ o2.bx }},
    {%- endif %}        
        condition_o => {{ condition.vhdl_signal }}
{%- endblock port %}
{# eof #}
