{% extends "instances/base/condition.vhd" %}

{% set o = condition.objects[0] %}

{%- if o.type == "ZDCP" or o.type == "ZDCM" %}
{% set e = "zdc_condition" %}
{%- else %}
{% set e = "towercount_condition" %}
{%- endif %}

{% block entity %}work.{{e}}{% endblock entity %}

{% block generic_map %}
    {%- if not o.operator %}
        et_ge_mode => {{ o.operator | vhdl_bool }},
    {%- endif %}
        count_threshold => X"{{ o.count.threshold | X04 }}"
{%- endblock %}

{% block port_map %}
        bx_data.{{ o.type | lower }}({{ o.bx_arr }}),
{%- endblock %}
