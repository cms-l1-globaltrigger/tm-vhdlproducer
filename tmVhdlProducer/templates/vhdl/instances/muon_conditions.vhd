{%- extends "instances/comb_conditions_base.vhd" %}
{%- block instantiate_muon_conditions %}
{%- block entity %}
{{ condition.vhdl_signal }}_i: entity work.muon_conditions
{%- endblock entity %}
{%- block port %}
        lhc_clk, 
        mu_bx_{{ condition.objects[0].bx }},
    {%- if (condition.nr_objects == 2) and (condition.hasTwoBodyPt is not none) and (condition.chargeCorrelation is not none) %}
        ls_charcorr_double => ls_charcorr_double_bx_{{ condition.objects[0].bx }}_bx_{{ condition.objects[0].bx }}, 
        os_charcorr_double => os_charcorr_double_bx_{{ condition.objects[0].bx }}_bx_{{ condition.objects[0].bx }},
        pt => {{ condition.objects[0].type|lower }}_pt_vector_bx_{{ condition.objects[0].bx }}, 
        cos_phi_integer => {{ condition.objects[0].type|lower }}_cos_phi_bx_{{ condition.objects[0].bx }}, 
        sin_phi_integer => {{ condition.objects[0].type|lower }}_sin_phi_bx_{{ condition.objects[0].bx }},
    {%- elif (condition.nr_objects == 2) and (condition.hasTwoBodyPt is not none) and (condition.chargeCorrelation is none) %}
        pt => {{ condition.objects[0].type|lower }}_pt_vector_bx_{{ condition.objects[0].bx }}, 
        cos_phi_integer => {{ condition.objects[0].type|lower }}_cos_phi_bx_{{ condition.objects[0].bx }}, 
        sin_phi_integer => {{ condition.objects[0].type|lower }}_sin_phi_bx_{{ condition.objects[0].bx }},
    {%- elif (condition.nr_objects == 2) and (condition.hasTwoBodyPt is none) and (condition.chargeCorrelation is not none) %}
        ls_charcorr_double => ls_charcorr_double_bx_{{ condition.objects[0].bx }}_bx_{{ condition.objects[0].bx }}, 
        os_charcorr_double => os_charcorr_double_bx_{{ condition.objects[0].bx }}_bx_{{ condition.objects[0].bx }},
    {%- elif (condition.nr_objects == 3) and (condition.chargeCorrelation is not none) %}
        ls_charcorr_triple => ls_charcorr_triple_bx_{{ condition.objects[0].bx }}_bx_{{ condition.objects[0].bx }}, 
        os_charcorr_triple => os_charcorr_triple_bx_{{ condition.objects[0].bx }}_bx_{{ condition.objects[0].bx }},
    {%- elif (condition.nr_objects == 4) and (condition.chargeCorrelation is not none) %}
        ls_charcorr_quad => ls_charcorr_quad_bx_{{ condition.objects[0].bx }}_bx_{{ condition.objects[0].bx }}, 
        os_charcorr_quad => os_charcorr_quad_bx_{{ condition.objects[0].bx }}_bx_{{ condition.objects[0].bx }},
    {%- endif %}
        condition_o => {{ condition.vhdl_signal }}
{%- endblock port %}
{%- endblock instantiate_muon_conditions %}
{# eof #}
