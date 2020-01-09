{%- block instantiate_comparator_eta_cut %}
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
    comp_eta_{{ obj|lower }}_bx_{{ bx }}_0x{{ limit_l|lower }}_0x{{ limit_u|lower }}_i: entity work.comparators_obj_cuts
        generic map(
            N_{{ obj|upper }}_OBJECTS, {{ obj|upper }}_ETA_WIDTH,
            ETA, X"{{ limit_l|upper }}", X"{{ limit_u|upper }}", X"0000", "ign"
        )
        port map(
            lhc_clk, data.{{ obj|lower }}(bx({{ bx_raw }})).eta, comp_eta_{{ obj|lower }}_bx_{{ bx }}_0x{{ limit_l|lower }}_0x{{ limit_u|lower }}
        );
{%- endblock instantiate_comparator_eta_cut %}
