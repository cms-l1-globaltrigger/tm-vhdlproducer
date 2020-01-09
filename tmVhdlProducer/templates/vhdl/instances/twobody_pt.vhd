{%- block instantiate_twobody_pt %}
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
    calc_twobody_pt_{{ obj1|lower }}_{{ obj2|lower }}_bx_{{ bx1 }}_bx_{{ bx2 }}_i: entity work.twobody_pt
        generic map(
            N_{{ obj1|upper }}_OBJECTS, N_{{ obj2|upper }}_OBJECTS
            {{ obj1|upper }}_PT_VECTOR_WIDTH, {{ obj2|upper }}_PT_VECTOR_WIDTH
        )
        port map(
            conv.{{ obj1|lower }}(bx({{ bx1_raw }})).pt_vector,
            conv.{{ obj2|lower }}(bx({{ bx2_raw }})).pt_vector,
            conv.{{ obj1|lower }}(bx({{ bx1_raw }})).cos_phi,
            conv.{{ obj2|lower }}(bx({{ bx2_raw }})).cos_phi,
            conv.{{ obj1|lower }}(bx({{ bx1_raw }})).sin_phi,
            conv.{{ obj2|lower }}(bx({{ bx2_raw }})).sin_phi,
            tbpt_{{ obj1|lower }}_{{ obj2|lower }}(bx({{ bx1_raw }}),bx({{ bx2_raw }}))
       );
{%- endblock instantiate_twobody_pt %}
