{% extends "instances/base/condition.vhd" %}

{% set o = condition.objects[0] %}

{% block entity %}work.esums_conditions{% endblock %}

{% block generic_map %}
  {%- if not o.operator %}
        et_ge_mode => {{ o.operator | vhdl_bool }},
  {%- endif %}
  {%- if o.count  %}
        et_threshold => X"{{ o.count.threshold | X04 }}",
  {%- else %}
        et_threshold => X"{{ o.threshold | X04 }}",
  {%- endif %}
  {%- if o.phiNrCuts > 0 %}
        nr_phi_windows => {{ o.phiNrCuts }},
        phi_w1_upper_limit => X"{{ o.phiUpperLimit[0] | X04 }}",
        phi_w1_lower_limit => X"{{ o.phiLowerLimit[0] | X04 }}",
  {%- endif %}
  {%- if o.phiNrCuts > 1 %}
        phi_w2_upper_limit => X"{{ o.phiUpperLimit[1] | X04 }}",
        phi_w2_lower_limit => X"{{ o.phiLowerLimit[1] | X04 }}",
  {%- endif %}
        obj_type => {{ o.type | upper }}_TYPE
{%- endblock %}

{% block port_map %}
        bx_data.{{ o.type | lower }}({{ o.bx_arr }}),
{%- endblock %}
