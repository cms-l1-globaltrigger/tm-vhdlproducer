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
        phi_full_range => {{ o.phiFullRange | vhdl_bool }},
        phi_w1_upper_limit => X"{{ o.phiW1.upper | X04 }}",
        phi_w1_lower_limit => X"{{ o.phiW1.lower | X04 }}",
  {%- endif %}
  {%- if o.phiNrCuts > 1 %}
        phi_w2_ignore => {{ o.phiW2Ignore | vhdl_bool }},
        phi_w2_upper_limit => X"{{ o.phiW2.upper | X04 }}",
        phi_w2_lower_limit => X"{{ o.phiW2.lower | X04 }}",
  {%- endif %}
        obj_type => {{ o.type | upper }}_TYPE
{%- endblock %}

{% block port_map %}
        bx_data.{{ o.type | lower }}({{ o.bx_arr }}),
{%- endblock %}
