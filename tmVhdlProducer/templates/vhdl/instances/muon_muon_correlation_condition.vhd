{% extends "instances/base/correlation_condition.vhd" %}

{% block entity %}work.correlation_conditions_muon{% endblock %}

{%- block generic_map -%}
{{ super() }}
-- number and type of object 2
        nr_obj2 => NR_{{ o2.type | upper }}_OBJECTS,
        type_obj2 => {{ o2.type | upper }}_TYPE,
-- selector same/different bunch crossings
        same_bx => {{ condition.objectsInSameBx | vhdl_bool }}
{%- endblock %}

{%- block port_map %}
        obj1 => {{ o1.type | lower }}_bx_{{ o1.bx }},
        obj2 => {{ o2.type | lower }}_bx_{{ o2.bx }},
  {%- if condition.chargeCorrelation %}
        ls_charcorr_double => ls_charcorr_double_bx_{{ o1.bx }}_bx_{{ o2.bx }},
        os_charcorr_double => os_charcorr_double_bx_{{ o1.bx }}_bx_{{ o2.bx }},
  {%- endif %}
  {%- if condition.mass and condition.mass.type == condition.mass.InvariantMassDeltaRType %}
        mass_div_dr => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_div_dr,
  {%- else %}
    {%- if (condition.deltaEta) or (condition.deltaR) %}
        deta => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_vector,
    {%- endif %}
    {%- if (condition.deltaPhi) or (condition.deltaR) %}
        dphi => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_vector,
    {%- endif %}
    {%- if (condition.mass) or (condition.twoBodyPt) %}
        pt1 => {{ o1.type | lower }}_bx_{{ o1.bx }}_pt_vector,
        pt2 => {{ o2.type | lower }}_bx_{{ o2.bx }}_pt_vector,
    {%- endif %}
    {%- if (condition.mass) and (condition.mass.type == condition.mass.InvariantMassUptType) %}
        upt1 => {{ o1.type | lower }}_bx_{{ o1.bx }}_upt_vector,
        upt2 => {{ o2.type | lower }}_bx_{{ o2.bx }}_upt_vector,
    {%- endif %}
    {%- if condition.mass %}
        cosh_deta => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_deta_vector,
        cos_dphi => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector,
    {%- endif %}
    {%- if condition.twoBodyPt %}
        cos_phi_1_integer => {{ o1.type | lower }}_bx_{{ o1.bx }}_cos_phi,
        cos_phi_2_integer => {{ o2.type | lower }}_bx_{{ o2.bx }}_cos_phi,
        sin_phi_1_integer => {{ o1.type | lower }}_bx_{{ o1.bx }}_sin_phi,
        sin_phi_2_integer => {{ o2.type | lower }}_bx_{{ o2.bx }}_sin_phi,
    {%- endif %}
    {%- if condition.deltaR %}
        dr => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dr,
    {%- endif %}
    {%- if condition.mass %}
      {%- if  condition.mass.type == condition.mass.InvariantMassType %}
        mass_inv_pt => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_inv_pt,
      {%- elif  condition.mass.type == condition.mass.InvariantMassUptType %}
        mass_inv_upt => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_inv_upt,
      {%- endif %}
    {%- endif %}
  {%- endif %}
{%- endblock %}
