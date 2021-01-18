{% extends "instances/sub_templ/correlation_condition.vhd" %}

{% block entity %}work.calo_muon_correlation_condition{% endblock %}

{%- block generic_map_end %}
-- number of calo objects and type
        type_obj1 => {{ o1.type|upper }}_TYPE,
        nr_calo_objects => NR_{{ o1.type|upper }}_OBJECTS
{%- endblock %}

{%- block port_map %}
        calo => {{ o1.type|lower }}_bx_{{ o1.bx }}, 
        muon => {{ o2.type|lower }}_bx_{{ o2.bx }},
  {%- if condition.mass.type == condition.mass.InvariantMassDeltaRType %}
        mass_div_dr => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_div_dr,
  {%- else %}
    {%- if (condition.hasDeltaEta) or (condition.hasDeltaR) %}
        deta => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_vector,        
    {%- endif %}        
    {%- if (condition.hasDeltaPhi) or (condition.hasDeltaR) %}
        dphi => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_vector,
    {%- endif %}        
    {%- if (condition.hasMass) or (condition.hasTwoBodyPt) %}
        pt1 => {{ o1.type|lower }}_bx_{{ o1.bx }}_pt_vector, 
        pt2 => {{ o2.type|lower }}_bx_{{ o2.bx }}_pt_vector,
    {%- endif %}        
    {%- if condition.hasMass %}
        cosh_deta => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_deta_vector, 
        cos_dphi => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector,
    {%- endif %}        
    {%- if condition.hasTwoBodyPt %}
        cos_phi_1_integer => {{ o1.type|lower }}_bx_{{ o1.bx }}_cos_phi, 
        cos_phi_2_integer => {{ o2.type|lower }}_bx_{{ o2.bx }}_cos_phi, 
        sin_phi_1_integer => {{ o1.type|lower }}_bx_{{ o1.bx }}_sin_phi, 
        sin_phi_2_integer => {{ o2.type|lower }}_bx_{{ o2.bx }}_sin_phi,
    {%- endif %}        
  {%- endif %}
{%- endblock %}
