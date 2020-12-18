{%- extends "instances/comb_condition.vhd" %}

{%- block entity %}work.muon_conditions{% endblock entity %}

{%- block port_map %}
        mu_bx_{{ o1.bx }},
    {%- if (condition.nr_objects == 2) and condition.hasTwoBodyPt and condition.chargeCorrelation %}
        ls_charcorr_double => ls_charcorr_double_bx_{{ o1.bx }}_bx_{{ o1.bx }},
        os_charcorr_double => os_charcorr_double_bx_{{ o1.bx }}_bx_{{ o1.bx }},
        pt => {{ o1.type|lower }}_pt_vector_bx_{{ o1.bx }},
        cos_phi_integer => {{ o1.type|lower }}_cos_phi_bx_{{ o1.bx }},
        sin_phi_integer => {{ o1.type|lower }}_sin_phi_bx_{{ o1.bx }},
    {%- elif (condition.nr_objects == 2) and condition.hasTwoBodyPt and condition.chargeCorrelation %}
        pt => {{ o1.type|lower }}_pt_vector_bx_{{ o1.bx }},
        cos_phi_integer => {{ o1.type|lower }}_cos_phi_bx_{{ o1.bx }},
        sin_phi_integer => {{ o1.type|lower }}_sin_phi_bx_{{ o1.bx }},
    {%- elif (condition.nr_objects == 2) and not condition.hasTwoBodyPt and condition.chargeCorrelation %}
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
