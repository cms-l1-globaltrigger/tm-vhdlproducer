{%- block instantiate_comparator_asymmetry %}
  {%- if bx == 'm2' %}
    {%- set bx_raw = -2 %} 
  {%- elif bx == 'm1' %}
    {%- set bx_raw = -1 %} 
  {%- elif bx == 'p1' %}
    {%- set bx_raw = 1 %} 
  {%- elif bx == 'p2' %}
    {%- set bx_raw = 2 %} 
  {%- else %}
    {%- set bx_raw = 0 %} 
  {%- endif %}  
    comp_count_{{ obj|lower }}_bx_{{ bx }}_0x{{ count|X04|lower }}_i: entity work.comparators_obj_cuts
        generic map(
            N_{{ obj|upper }}_OBJECTS, {{ obj|upper }}_WIDTH,
            GE, X"{{ count|X04 }}", X"0000", X"0000", "ign"
        )
        port map(
            lhc_clk, data.{{ obj|lower }}(bx({{ bx_raw }})).count, comp_count_{{ obj|lower }}_bx_{{ bx }}_0x{{ count|X04|lower }}
        );
{%- endblock instantiate_comparator_asymmetry %}
