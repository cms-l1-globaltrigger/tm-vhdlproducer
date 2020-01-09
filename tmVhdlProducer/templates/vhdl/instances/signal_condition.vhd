{%- block instantiate_signal_condition %}
  {%- set o = condition.objects[0] %}
  {%- if o.bx == 'm2' %}
    {%- set o.bx_raw = -2 %} 
  {%- elif o.bx == 'm1' %}
    {%- set o.bx_raw = -1 %} 
  {%- elif o.bx == 'p1' %}
    {%- set o.bx_raw = 1 %} 
  {%- elif o.bx == 'p2' %}
    {%- set o.bx_raw = 2 %} 
  {%- else %}
    {%- set o.bx_raw = 0 %} 
  {%- endif %}  
    {%- if o.type == 'CENT0' %}
        {%- set cent_bit = 0 %}
    {%- elif o.type == 'CENT1' %}  
        {%- set cent_bit = 1 %}
    {%- elif o.type == 'CENT2' %}  
        {%- set cent_bit = 2 %}
    {%- elif o.type == 'CENT3' %}  
        {%- set cent_bit = 3 %}
    {%- elif o.type == 'CENT4' %}  
        {%- set cent_bit = 4 %}
    {%- elif o.type == 'CENT5' %}  
        {%- set cent_bit = 5 %}
    {%- elif o.type == 'CENT6' %}  
        {%- set cent_bit = 6 %}
    {%- elif o.type == 'CENT7' %}  
        {%- set cent_bit = 7 %}
    {%- endif %}  
    {{ condition.vhdl_signal }} <= data.centrality(bx({{ bx_raw }}))({{ cent_bit }});
{%- endblock instantiate_signal_condition %}
