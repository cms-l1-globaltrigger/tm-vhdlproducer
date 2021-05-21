{%- set o = condition.objects[0] %}
{%- if o.is_signal_type %}
{{ condition.vhdl_signal }} <= {{ o.type | lower }}({{ o.bx_arr }});
{%- endif %}
