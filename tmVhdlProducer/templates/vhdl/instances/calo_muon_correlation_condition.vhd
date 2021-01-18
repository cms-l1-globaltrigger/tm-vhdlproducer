{% extends "instances/correlation_condition.vhd" %}

{% block entity %}work.calo_muon_correlation_condition{% endblock %}

{%- block generic_map_end %}
        -- number of calo objects
        nr_calo_objects => NR_{{ o1.type | upper }}_OBJECTS
{%- endblock %}

{%- block port_map %}
        {{ o1.type | lower }}_bx_{{ o1.bx }},
        {{ o2.type | lower }}_bx_{{ o2.bx }},
    {%- if condition.mass.type == condition.mass.InvariantMassDeltaRType %}
        mass_div_dr => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_div_dr,
    {%- else %}
        {%- if (condition.deltaEta) or (condition.deltaR) %}
        diff_eta => diff_{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_eta_vector,
        {%- endif %}
        {%- if (condition.deltaPhi) or (condition.deltaR) %}
        diff_phi => diff_{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_phi_vector,
        {%- endif %}
        {%- if (condition.mass) or (condition.twoBodyPt) %}
        pt1 => {{ o1.type | lower }}_pt_vector_bx_{{ o1.bx }},
        pt2 => {{ o2.type | lower }}_pt_vector_bx_{{ o2.bx }},
        {%- endif %}
        {%- if condition.mass %}
        cosh_deta => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_deta_vector,
        cos_dphi => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector,
        {%- endif %}
        {%- if condition.twoBodyPt %}
        cos_phi_1_integer => {{ o1.type | lower }}_cos_phi_bx_{{ o1.bx }},
        cos_phi_2_integer => {{ o2.type | lower }}_cos_phi_bx_{{ o2.bx }},
        sin_phi_1_integer => {{ o1.type | lower }}_sin_phi_bx_{{ o1.bx }},
        sin_phi_2_integer => {{ o2.type | lower }}_sin_phi_bx_{{ o2.bx }},
        {%- endif %}
    {%- endif %}
{%- endblock %}
