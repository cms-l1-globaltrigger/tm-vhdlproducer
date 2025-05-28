{# signal base name of first and last object of condition #}
{% macro signal_base(objects) -%}
{% set sorted_objects = objects | sort_objects -%}
{% set first = objects[0] -%}
{% set last = objects[-1] -%}
{{ first.type | lower }}_{{ last.type | lower }}_bx_{{ first.bx }}_bx_{{ last.bx }}
{%- endmacro %}
