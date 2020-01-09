{%- block instantiate_comparator_iso_cut %}
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
    comp_iso_{{ obj|lower }}_bx_{{ bx }}_0x{{ iso_lut|lower }}_i: entity work.comparators_obj_cuts
        generic map(
            N_{{ obj|upper }}_OBJECTS, {{ obj|upper }}_ISO_WIDTH,
            ISO, X"0000", X"0000", X"{{ iso_lut|upper }}", "ign"
        )
        port map(
            lhc_clk, data.{{ obj|lower }}(bx({{ bx_raw }})).iso, comp_iso_{{ obj|lower }}_bx_{{ bx }}_0x{{ iso_lut|lower }}
        );
{%- endblock instantiate_comparator_iso_cut %}
