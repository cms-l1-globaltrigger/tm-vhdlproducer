{%- extends "instances/muon_correlation_conditions_base.vhd" %}
{%- set o1 = condition.objects[0] %}
{%- set o2 = condition.objects[1] %}
{%- set nr_muon_obj = condition.nr_objects %}
{%- block instantiate_muon_muon_correlation_condition %}
{%- block entity %}
{{ condition.vhdl_signal }}_i: entity work.muon_muon_correlation_condition
{%- endblock entity %}
{%- block generic_end %}
-- selector same/different bunch crossings
        same_bx => {{ condition.objectsInSameBx }}
{%- endblock generic_end %}
{%- block port %}
        lhc_clk, {{ o1.type|lower }}_bx_{{ o1.bx }}, {{ o2.type|lower }}_bx_{{ o2.bx }},
    {%- if condition.chargeCorrelation is not none %}
        ls_charcorr_double_bx_{{ o1.bx }}_bx_{{ o2.bx }}, 
        os_charcorr_double_bx_{{ o1.bx }}_bx_{{ o2.bx }},
    {%- endif %}        
    {%- if condition.mass.type == condition.mass.InvariantMassDeltaRType %}
        mass_div_dr => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_div_dr,
    {%- else %}
        {%- if (condition.hasDeltaEta is not none) or (condition.hasDeltaR is not none) %}
        diff_eta => diff_{{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_eta_vector,        
        {%- endif %}        
        {%- if (condition.hasDeltaPhi is not none) or (condition.hasDeltaR is not none) %}
        diff_phi => diff_{{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_phi_vector,
        {%- endif %}        
        {%- if (condition.hasMass is not none) or (condition.hasTwoBodyPt is not none) %}
        pt1 => {{ o1.type|lower }}_pt_vector_bx_{{ o1.bx }}, 
        pt2 => {{ o2.type|lower }}_pt_vector_bx_{{ o2.bx }},
        {%- endif %}        
        {%- if condition.hasMass is not none %}
        cosh_deta => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_deta_vector, 
        cos_dphi => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector,
        {%- endif %}        
        {%- if condition.hasTwoBodyPt is not none %}
        cos_phi_1_integer => {{ o1.type|lower }}_cos_phi_bx_{{ o1.bx }}, 
        cos_phi_2_integer => {{ o2.type|lower }}_cos_phi_bx_{{ o2.bx }}, 
        sin_phi_1_integer => {{ o1.type|lower }}_sin_phi_bx_{{ o1.bx }}, 
        sin_phi_2_integer => {{ o2.type|lower }}_sin_phi_bx_{{ o2.bx }},
        {%- endif %}        
    {%- endif %}
        condition_o => {{ condition.vhdl_signal }}
{%- endblock port %}
{%- endblock instantiate_muon_muon_correlation_condition %}
{# eof #}
