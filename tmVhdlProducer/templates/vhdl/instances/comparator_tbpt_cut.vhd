{%- block instantiate_condition_tbpt_cut %}
  {%- if bx1 == 'm2' %}
    {%- set bx1_raw = -2 %} 
  {%- elif bx1 == 'm1' %}
    {%- set bx1_raw = -1 %} 
  {%- elif bx1 == 'p1' %}
    {%- set bx1_raw = 1 %} 
  {%- elif bx1 == 'p2' %}
    {%- set bx1_raw = 2 %} 
  {%- else %}
    {%- set bx1_raw = 0 %} 
  {%- endif %}  
  {%- if bx2 == 'm2' %}
    {%- set bx2_raw = -2 %} 
  {%- elif bx2 == 'm1' %}
    {%- set bx2_raw = -1 %} 
  {%- elif bx2 == 'p1' %}
    {%- set bx2_raw = 1 %} 
  {%- elif bx2 == 'p2' %}
    {%- set bx2_raw = 2 %} 
  {%- else %}
    {%- set bx2_raw = 0 %} 
  {%- endif %}  
    comp_tbpt_{{ obj1|lower }}_{{ obj2|lower }}_bx{{ bx1 }}_bx{{ bx2 }}_0x{{ limit_l|lower }}_i: entity work.conditions_corr_cuts
        generic map(
            N_{{ obj1|upper }}_OBJECTS, N_{{ obj2|upper }}_OBJECTS, ({{ obj1|lower }}_t,{{ obj2|lower }}_t), (bx({{ bx1_raw }}),bx({{ bx2_raw }})),
            {{ obj1|upper }}_{{ obj2|upper }}_TBPT_VECTOR_WIDTH, twoBodyPt, 
            X"{{ limit_l|upper }}"        
        )
        port map(
            lhc_clk, 
            tbpt_{{ obj1|lower }}_{{ obj2|lower }}(bx({{ bx1_raw }}),bx({{ bx2_raw }})), comp_tbpt_{{ obj1|lower }}_{{ obj2|lower }}_bx_{{ bx1 }}_bx_{{ bx2 }}_0x{{ limit_l|lower }}
        );
{% endblock instantiate_condition_tbpt_cut %}
