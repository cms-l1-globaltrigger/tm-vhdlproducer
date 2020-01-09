{%- block instantiate_combinatorial_conditions_esums %}
  {%- set o1 = condition.objects[0] %}
    cond_{{ condition.vhdl_signal }}_i: entity work.combinatorial_conditions
        generic map(
            N_{{ o1.type|upper }}_OBJECTS, 1,
            ((0,0), (0,0), (0,0), (0,0)), 
            false
        )
        port map(
            lhc_clk, 
    {%- with obj = condition.objects[0] %}
            comb_1 => {%- include "helper/helper_comb_and_esums_signals_names.txt" %}
    {%- endwith %}
            cond_o => {{ condition.vhdl_signal }}
        );
{%- endblock instantiate_combinatorial_conditions_esums %}
