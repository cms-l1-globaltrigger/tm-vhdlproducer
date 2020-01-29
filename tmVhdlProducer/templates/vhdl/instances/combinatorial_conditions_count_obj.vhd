{%- block instantiate_combinatorial_conditions_count_obj %}
  {%- set o1 = condition.objects[0] %}
    {%- with obj = condition.objects[0] %}
        {{ condition.vhdl_signal }} => {%- include  "helper/helper_comb_and_count_signals_names.txt" %}(0);
    {%- endwith %}
{%- endblock instantiate_combinatorial_conditions_count_obj %}
