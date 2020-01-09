{%- block instantiate_comparator_charge_cut %}
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
    comp_charge_{{ obj|lower }}_bx_{{ bx }}_{{ charge_str }}_i: entity work.comparators_obj_cuts
        generic map(
            N_{{ obj|upper }}_OBJECTS, {{ obj|upper }}_CHARGE_WIDTH,
            CHARGE, X"0000", X"0000", X"0000", "{{ charge_str }}"
        )
        port map(
            lhc_clk, data.{{ obj|lower }}(bx({{ bx_raw }})).charge, comp_charge_{{ obj|lower }}_bx_{{ bx }}_{{ charge_str }}
        );
{%- endblock instantiate_comparator_charge_cut %}
