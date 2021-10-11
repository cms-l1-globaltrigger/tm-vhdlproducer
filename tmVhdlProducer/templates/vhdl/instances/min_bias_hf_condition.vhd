{% extends "instances/base/condition.vhd" %}

{% set o = condition.objects[0] %}

{% block entity %}work.min_bias_hf_conditions{% endblock entity %}

{% block generic_map %}
    {%- if not o.operator %}
        et_ge_mode => {{ o.operator | vhdl_bool }},
    {%- endif %}
        obj_type => {{ o.type | upper }}_TYPE,
        count_threshold => X"{{ o.count.threshold | X01 }}"
{%- endblock %}

{% block port_map %}
        bx_data.{{ o.type | lower }}({{ o.bx_arr }}),
{%- endblock %}
