{% extends "instances/sub_templ/correlation_condition.vhd" %}

{% block entity %}work.correlation_conditions{% endblock %}

{%- block generic_map_end %}
-- number of objects and type
  {%- for i in range(0,condition.nr_objects) %}
    {%- set o = condition.objects[i] %}
        nr_obj{{i+1}} => NR_{{ o.type|upper }}_OBJECTS,
        type_obj{{i+1}} => {{ o.type|upper }}_TYPE,
        width_obj{{i+1}} => MAX_MUON_BITS,
{%- endfor %}
-- selector same/different bunch crossings
        same_bx => {{ condition.objectsInSameBx | vhdl_bool }}
{%- endblock %}

{%- block port_map %}
        obj1 => {{ o1.type|lower }}_bx_{{ o1.bx }},
        obj2 => {{ o2.type|lower }}_bx_{{ o2.bx }},
  {%- if condition.chargeCorrelation %}
        ls_charcorr_double => ls_charcorr_double_bx_{{ o1.bx }}_bx_{{ o2.bx }}, 
        os_charcorr_double => os_charcorr_double_bx_{{ o1.bx }}_bx_{{ o2.bx }},
  {%- endif %}        
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
