{% extends "instances/base/condition.vhd" %}

{%- set o1 = condition.objects[0] %}
{%- set o2 = condition.objects[1] %}
{%- set o3 = condition.objects[2] %}

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
  {%- if not o3.slice %}
        slice_low_obj3 => {{ o3.slice.lower }},
        slice_high_obj3 => {{ o3.slice.upper }},
  {%- endif -%}
    {%- set o = condition.objects[0] %}
    {%- include  "instances/base/object_cuts_correlation.vhd" %}
-- correlation cuts
        mass_upper_limit_vector => X"{{ condition.mass.upper | X16 }}",
        mass_lower_limit_vector => X"{{ condition.mass.lower | X16 }}",
        mass_vector_width => MU_PT_VECTOR_WIDTH+MU_PT_VECTOR_WIDTH+MU_MU_COSH_COS_VECTOR_WIDTH,
        mass_3_obj => true,
-- number of objects and type
  {%- for i in range(0,condition.nr_objects) %}
    {%- set o = condition.objects[i] %}
        nr_obj{{i+1}} => NR_{{ o.type | upper }}_OBJECTS,
        type_obj{{i+1}} => {{ o.type | upper }}_TYPE,
  {%- endfor %}
  {%- if condition.chargeCorrelation %}
-- requested charge correlation
        requested_charge_correlation => "{{ condition.chargeCorrelation.value }}",
  {%- endif %}
-- selector same/different bunch crossings
        same_bx => {{ condition.objectsInSameBx | vhdl_bool}}
{%- endblock %}

{%- block port_map %}
        muon_obj1 => bx_data.mu({{ o1.bx_arr }}),
        muon_obj2 => bx_data.mu({{ o2.bx_arr }}),
        muon_obj3 => bx_data.mu({{ o3.bx_arr }}),
    {%- if condition.chargeCorrelation %}
        ls_charcorr_triple => ls_charcorr_triple_bx_{{ o1.bx }}_bx_{{ o1.bx }},
        os_charcorr_triple => os_charcorr_triple_bx_{{ o1.bx }}_bx_{{ o1.bx }},
    {%- endif %}
        mass_inv_pt => mu_mu_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_inv_pt,
{%- endblock %}
