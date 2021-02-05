{% extends "instances/common/correlation_condition.vhd" %}

{% block entity %}work.correlation_conditions_calo{% endblock %}

{%- block generic_map_end %}
  {%- if not o2.slice %}
-- slices for muon
        slice_low_obj2 => {{ o2.slice.lower }}, 
        slice_high_obj2 => {{ o2.slice.upper }}, 
  {%- endif %}        
-- number of objects and type
        nr_obj1 => NR_{{ o1.type|upper }}_OBJECTS,
        type_obj1 => {{ o1.type|upper }}_TYPE,
        nr_obj2 => NR_{{ o2.type|upper }}_OBJECTS,
        type_obj2 => {{ o2.type|upper }}_TYPE,
-- selector same/different bunch crossings
        same_bx => {{ condition.objectsInSameBx | vhdl_bool }}
{%- endblock %}

{%- block port_map %}
        obj1 => {{ o1.type|lower }}_bx_{{ o1.bx }}, 
        muon => {{ o2.type|lower }}_bx_{{ o2.bx }},
  {%- if condition.mass.type == condition.mass.InvariantMassDeltaRType %}
        mass_div_dr => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_div_dr,
  {%- else %}
    {%- if (condition.deltaEta) or (condition.deltaR) %}
        deta => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_vector,        
    {%- endif %}        
    {%- if (condition.deltaPhi) or (condition.deltaR) %}
        dphi => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_vector,
    {%- endif %}        
    {%- if (condition.mass) or (condition.twoBodyPt) %}
        pt1 => {{ o1.type|lower }}_bx_{{ o1.bx }}_pt_vector, 
        pt2 => {{ o2.type|lower }}_bx_{{ o2.bx }}_pt_vector,
    {%- endif %}        
    {%- if condition.mass %}
        cosh_deta => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_deta_vector, 
        cos_dphi => {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector,
    {%- endif %}        
    {%- if condition.twoBodyPt %}
        cos_phi_1_integer => {{ o1.type|lower }}_bx_{{ o1.bx }}_cos_phi, 
        cos_phi_2_integer => {{ o2.type|lower }}_bx_{{ o2.bx }}_cos_phi, 
        sin_phi_1_integer => {{ o1.type|lower }}_bx_{{ o1.bx }}_sin_phi, 
        sin_phi_2_integer => {{ o2.type|lower }}_bx_{{ o2.bx }}_sin_phi,
    {%- endif %}        
  {%- endif %}
{%- endblock %}
