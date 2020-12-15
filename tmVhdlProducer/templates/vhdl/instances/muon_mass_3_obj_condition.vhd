{%- extends "instances/correlation_conditions_base.vhd" %}
{%- set o1 = condition.objects[0] %}
{%- set o2 = condition.objects[1] %}
{%- set o3 = condition.objects[2] %}
{%- set nr_calo_obj = condition.nr_objects %}
{%- block entity %}
{{ condition.vhdl_signal }}_i: entity work.calo_mass_3_obj_condition
{%- endblock entity %}
{%- block correlation_cuts %}
-- correlation cuts
    {%- if condition.chargeCorrelation is not none %}
        requested_charge_correlation => "{{ condition.chargeCorrelation }}",
    {%- endif %}        
        mass_upper_limit_vector => X"{{ condition.mass.upper|X16 }}", 
        mass_lower_limit_vector => X"{{ condition.mass.lower|X16 }}",
        pt_width => {{ o1.type|upper }}_PT_VECTOR_WIDTH, 
        cosh_cos_precision => {{ o1.type|upper }}_{{ o1.type|upper }}_COSH_COS_PRECISION, 
        cosh_cos_width => {{ o1.type|upper }}_{{ o1.type|upper }}_COSH_COS_VECTOR_WIDTH
{%- endblock correlation_cuts %}
{%- block port %}
        lhc_clk, 
        {{ o1.type|lower }}_bx_{{ o1.bx }},
        {{ o1.type|lower }}_pt_vector_bx_{{ o1.bx }},
        {{ o1.type|lower }}_{{ o1.type|lower }}_bx_{{ o1.bx }}_bx_{{ o1.bx }}_cosh_deta_vector, 
        {{ o1.type|lower }}_{{ o1.type|lower }}_bx_{{ o1.bx }}_bx_{{ o1.bx }}_cos_dphi_vector,
    {%- if condition.chargeCorrelation is not none %}
        ls_charcorr_triple => ls_charcorr_triple_bx_{{ o1.bx }}_bx_{{ o1.bx }}, 
        os_charcorr_triple => os_charcorr_triple_bx_{{ o1.bx }}_bx_{{ o1.bx }},
    {%- endif %}        
        condition_o => {{ condition.vhdl_signal }}
{%- endblock port %}
{# eof #}
