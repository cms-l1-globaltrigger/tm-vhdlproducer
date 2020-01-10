{%- block instantiate_signal_condition %}
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
    {{ condition.vhdl_signal }} <= data.centrality(bx({{ bx|bx_dec }}))({{ cent_bit }});
{%- endblock instantiate_signal_condition %}
