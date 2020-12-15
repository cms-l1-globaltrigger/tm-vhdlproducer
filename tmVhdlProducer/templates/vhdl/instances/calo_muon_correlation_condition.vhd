{%- extends "instances/correlation_conditions_base.vhd" %}
{%- set o1 = condition.objects[0] %}
{%- set o2 = condition.objects[1] %}
{%- set nr_calo_obj = 1 %}
{%- block entity %}
{{ condition.vhdl_signal }}_i: entity work.calo_muon_correlation_condition
{%- endblock entity %}
{%- block correlation_cuts %}
-- correlation cuts
    {%- if (condition.hasMass) and (condition.mass.type == condition.mass.InvariantMassDeltaRType) %}
        mass_cut => {{ condition.mass.enabled }}, 
        mass_type => INVARIANT_MASS_DIV_DR_TYPE,
    {%- else %}
        {%- if condition.hasDeltaEta %}
        deta_cut => {{ condition.deltaEta.enabled }}, 
        {%- endif %}        
        {%- if condition.hasDeltaPhi %}
        dphi_cut => {{ condition.deltaPhi.enabled }}, 
        {%- endif %}        
        {%- if condition.hasDeltaR %}
        dr_cut => {{ condition.deltaR.enabled }}, 
        {%- endif %}        
        {%- if condition.hasMass %}
        mass_cut => {{ condition.mass.enabled }}, 
        mass_type => INVARIANT_MASS_TYPE, 
        {%- endif %}        
        {%- if condition.hasTwoBodyPt %}
        twobody_pt_cut => {{ condition.twoBodyPt.enabled }}, 
        {%- endif %}        
    {%- endif %}        
    {%- if (condition.hasMass) or (condition.hasTwoBodyPt) %}
        pt1_width => {{ o1.type|upper }}_PT_VECTOR_WIDTH, 
        pt2_width => {{ o2.type|upper }}_PT_VECTOR_WIDTH, 
    {%- endif %}        
    {%- if (condition.hasMass) and (condition.mass.type == condition.mass.InvariantMassDeltaRType) %}
        mass_cosh_cos_precision => {{ o1.type|upper }}_{{ o2.type|upper }}_COSH_COS_PRECISION, 
        cosh_cos_width => {{ o1.type|upper }}_{{ o2.type|upper }}_COSH_COS_VECTOR_WIDTH,
        mass_div_dr_vector_width => {{ o1.type|upper }}_{{ o2.type|upper }}_MASS_DIV_DR_VECTOR_WIDTH,
        mass_div_dr_threshold => X"{{ condition.mass.lower|X21 }}",
    {%- else %}
        {%- if condition.hasDeltaEta %}
        diff_eta_upper_limit_vector => X"{{ condition.deltaEta.upper|X08 }}", 
        diff_eta_lower_limit_vector => X"{{ condition.deltaEta.lower|X08 }}",
        {%- endif %}        
        {%- if condition.hasDeltaPhi %}
        diff_phi_upper_limit_vector => X"{{ condition.deltaPhi.upper|X08 }}", 
        diff_phi_lower_limit_vector => X"{{ condition.deltaPhi.lower|X08 }}",
        {%- endif %}        
        {%- if condition.hasDeltaR %}
        dr_upper_limit_vector => X"{{ condition.deltaR.upper|X16 }}", 
        dr_lower_limit_vector => X"{{ condition.deltaR.lower|X16 }}",
        {%- endif %}        
        {%- if condition.hasMass %}
        mass_cosh_cos_precision => {{ o1.type|upper }}_{{ o2.type|upper }}_COSH_COS_PRECISION, 
        cosh_cos_width => {{ o1.type|upper }}_{{ o2.type|upper }}_COSH_COS_VECTOR_WIDTH,
        mass_upper_limit => X"{{ condition.mass.upper|X16 }}",
        mass_lower_limit => X"{{ condition.mass.lower|X16 }}",
        {%- endif %}        
        {%- if condition.hasTwoBodyPt %}
        pt_sq_threshold_vector => X"{{ condition.twoBodyPt.threshold|X16 }}", 
        sin_cos_width => CALO_SIN_COS_VECTOR_WIDTH, 
        pt_sq_sin_cos_precision => {{ o1.type|upper }}_{{ o2.type|upper }}_SIN_COS_PRECISION,
        {%- endif %}        
    {%- endif %}        
{%- endblock correlation_cuts %}
{%- block generic_end %}
-- number of calo objects
        nr_calo_objects => NR_{{ o1.type|upper }}_OBJECTS
{%- endblock generic_end %}
{%- block port %}
        lhc_clk, 
        {{ o1.type|lower }}_bx_{{ o1.bx }}, 
        {{ o2.type|lower }}_bx_{{ o2.bx }},
    {%- if condition.mass.type == condition.mass.InvariantMassDeltaRType %}
        mass_div_dr => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_div_dr,
    {%- else %}
        {%- if (condition.hasDeltaEta) or (condition.hasDeltaR) %}
        diff_eta => diff_{{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_eta_vector,        
        {%- endif %}        
        {%- if (condition.hasDeltaPhi) or (condition.hasDeltaR) %}
        diff_phi => diff_{{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_phi_vector,
        {%- endif %}        
        {%- if (condition.hasMass) or (condition.hasTwoBodyPt) %}
        pt1 => {{ o1.type|lower }}_pt_vector_bx_{{ o1.bx }}, 
        pt2 => {{ o2.type|lower }}_pt_vector_bx_{{ o2.bx }},
        {%- endif %}        
        {%- if condition.hasMass %}
        cosh_deta => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_deta_vector, 
        cos_dphi => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector,
        {%- endif %}        
        {%- if condition.hasTwoBodyPt %}
        cos_phi_1_integer => {{ o1.type|lower }}_cos_phi_bx_{{ o1.bx }}, 
        cos_phi_2_integer => {{ o2.type|lower }}_cos_phi_bx_{{ o2.bx }}, 
        sin_phi_1_integer => {{ o1.type|lower }}_sin_phi_bx_{{ o1.bx }}, 
        sin_phi_2_integer => {{ o2.type|lower }}_sin_phi_bx_{{ o2.bx }},
        {%- endif %}        
    {%- endif %}
        condition_o => {{ condition.vhdl_signal }}
{%- endblock port %}
{# eof #}
