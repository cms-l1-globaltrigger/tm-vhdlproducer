{% extends "instances/sub_templ/correlation_condition.vhd" %}

{% block entity %}work.muon_muon_correlation_condition{% endblock %}

{%- block generic_map_end %}
-- selector same/different bunch crossings
        same_bx => {{ condition.objectsInSameBx }}
{%- endblock %}

{%- block port_map %}
        {{ o1.type|lower }}_bx_{{ o1.bx }},
        {{ o2.type|lower }}_bx_{{ o2.bx }},
  {%- if condition.chargeCorrelation %}
        ls_charcorr_double_bx_{{ o1.bx }}_bx_{{ o2.bx }}, 
        os_charcorr_double_bx_{{ o1.bx }}_bx_{{ o2.bx }},
  {%- endif %}        
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
