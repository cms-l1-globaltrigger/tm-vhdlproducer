{%- block instantiate_combinatorial_conditions_esums %}
  {%- set o1 = condition.objects[0] %}
    {%- with obj = condition.objects[0] %}
        {{ condition.vhdl_signal }} => {% include "helper/helper_comb_and_esums_signals_names.txt" %}(0);
    {%- endwith %}
{%- endblock instantiate_combinatorial_conditions_esums %}
