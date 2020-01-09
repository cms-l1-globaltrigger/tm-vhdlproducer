{%- block instantiate_comparator_qual_cut %}
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
    comp_qual_{{ obj|lower }}_bx_{{ bx }}_0x{{ qual_lut|lower }}_i: entity work.comparators_obj_cuts
        generic map(
            N_{{ obj|upper }}_OBJECTS, {{ obj|upper }}_QUAL_WIDTH,
            QUAL, X"0000", X"0000", X"{{ qual_lut|upper }}", "ign"
        )
        port map(
            lhc_clk, data.{{ obj|lower }}(bx({{ bx_raw }})).qual, comp_qual_{{ obj|lower }}_bx_{{ bx }}_0x{{ qual_lut|lower }}
        );
{%- endblock instantiate_comparator_qual_cut %}
