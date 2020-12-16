{%- block comb_conditions_base %}
  {%- set o1 = condition.objects[0] %}
  {%- set o2 = condition.objects[1] %}
  {%- set o3 = condition.objects[2] %}
  {%- set o4 = condition.objects[3] %}
  {%- block entity %}
  {%- endblock entity %}
    generic map(
  {%- block generic_beg %}
  {%- endblock generic_beg %}
  {%- include  "instances/object_cuts_comb.vhd" %}
  {%- include  "instances/correlation_cuts_comb.vhd" %}
  {%- block charge_correlation %}
  {%- endblock charge_correlation %}
  {%- block generic_end %}
        nr_templates => {{ condition.nr_objects }}
  {%- endblock generic_end %}
    )
    port map(
  {%- block port %}
  {%- endblock port %}
    );
{%- endblock comb_conditions_base %}
{# eof #}
