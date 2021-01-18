{%- extends "instances/sub_templ/comb_condition.vhd" %}

{%- block entity %}work.muon_conditions{% endblock entity %}

{%- block port_map %}
        mu_bx_{{ o1.bx }},
    {%- if (condition.nr_objects == 2) and condition.twoBodyPt and condition.chargeCorrelation %}
        ls_charcorr_double => ls_charcorr_double_bx_{{ o1.bx }}_bx_{{ o1.bx }},
        os_charcorr_double => os_charcorr_double_bx_{{ o1.bx }}_bx_{{ o1.bx }},
        pt => {{ o1.type|lower }}_bx_{{ o1.bx }}_pt_vector,
        cos_phi_integer => {{ o1.type|lower }}_bx_{{ o1.bx }}_cos_phi,
        sin_phi_integer => {{ o1.type|lower }}_bx_{{ o1.bx }}_sin_phi,
    {%- elif (condition.nr_objects == 2) and condition.twoBodyPt and condition.chargeCorrelation %}
        pt => {{ o1.type|lower }}_bx_{{ o1.bx }}_pt_vector,
        cos_phi_integer => {{ o1.type|lower }}_bx_{{ o1.bx }}_cos_phi,
        sin_phi_integer => {{ o1.type|lower }}_bx_{{ o1.bx }}_sin_phi,
    {%- elif (condition.nr_objects == 2) and not condition.twoBodyPt and condition.chargeCorrelation %}
        ls_charcorr_double => ls_charcorr_double_bx_{{ o1.bx }}_bx_{{ o1.bx }},
        os_charcorr_double => os_charcorr_double_bx_{{ o1.bx }}_bx_{{ o1.bx }},
    {%- elif (condition.nr_objects == 3) and condition.chargeCorrelation %}
        ls_charcorr_triple => ls_charcorr_triple_bx_{{ o1.bx }}_bx_{{ o1.bx }},
        os_charcorr_triple => os_charcorr_triple_bx_{{ o1.bx }}_bx_{{ o1.bx }},
    {%- elif (condition.nr_objects == 4) and condition.chargeCorrelation %}
        ls_charcorr_quad => ls_charcorr_quad_bx_{{ o1.bx }}_bx_{{ o1.bx }},
        os_charcorr_quad => os_charcorr_quad_bx_{{ o1.bx }}_bx_{{ o1.bx }},
    {%- endif %}
{%- endblock %}
