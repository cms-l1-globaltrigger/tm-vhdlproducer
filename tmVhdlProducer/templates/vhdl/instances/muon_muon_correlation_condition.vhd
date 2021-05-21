{% extends "instances/base/correlation_condition.vhd" %}

{% block entity %}work.correlation_conditions{% endblock %}

{%- block generic_map %}
-- slices for muon
  {%- if not o1.slice %}
        slice_low_obj1 => {{ o1.slice.lower }},
        slice_high_obj1 => {{ o1.slice.upper }},
  {%- endif -%}
  {%- if not o2.slice %}
        slice_low_obj2 => {{ o2.slice.lower }},
        slice_high_obj2 => {{ o2.slice.upper }},
  {%- endif -%}
{{ super() }}
-- number of objects and type
  {%- for i in range(0,condition.nr_objects) %}
    {%- set o = condition.objects[i] %}
        nr_obj{{i+1}} => NR_{{ o.type | upper }}_OBJECTS,
        type_obj{{i+1}} => {{ o.type | upper }}_TYPE,
  {%- endfor %}
-- selector same/different bunch crossings
        same_bx => {{ condition.objectsInSameBx | vhdl_bool }}
{%- endblock %}

{%- block port_map %}
        muon_obj1 => bx_data.{{ o1.type | lower }}({{ o1.bx_arr }}),
        muon_obj2 => bx_data.{{ o2.type | lower }}({{ o2.bx_arr }}),
  {%- if condition.chargeCorrelation %}
        ls_charcorr_double => ls_charcorr_double_bx_{{ o1.bx }}_bx_{{ o2.bx }},
        os_charcorr_double => os_charcorr_double_bx_{{ o1.bx }}_bx_{{ o2.bx }},
  {%- endif %}
  {%- if condition.mass and condition.mass.type == condition.mass.InvariantMassDeltaRType %}
        mass_div_dr => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_over_dr,
  {%- else %}
    {%- if condition.deltaEta %}
        deta => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta,
    {%- endif %}
    {%- if condition.deltaPhi %}
        dphi => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi,
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
    {%- if condition.twoBodyPt %}
        tbpt => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_tbpt,
    {%- endif %}
  {%- endif %}
{%- endblock %}
