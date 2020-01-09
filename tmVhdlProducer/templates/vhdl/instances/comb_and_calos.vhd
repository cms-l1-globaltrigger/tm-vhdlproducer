{%- block instantiate_comb_and_calos %}
  {%- if condition.nr_objects > 0 %}  
    {%- with obj = condition.objects[0] %}
    {%- include  "helper/helper_comb_and_calos.txt" %}
    {%- endwith -%}
  {%- endif -%}    
  {%- if condition.nr_objects > 1 %}  
    {%- with obj = condition.objects[1] %}
    {%- include  "helper/helper_comb_and_calos.txt" %}
    {%- endwith -%}
  {%- endif -%}    
  {%- if condition.nr_objects > 2 %}  
    {%- with obj = condition.objects[2] %}
    {%- include  "helper/helper_comb_and_calos.txt" %}
    {%- endwith -%}
  {%- endif -%}    
  {%- if condition.nr_objects > 3 %}  
    {%- with obj = condition.objects[3] %}
    {%- include  "helper/helper_comb_and_calos.txt" %}
    {%- endwith -%}
  {%- endif -%}    
{%- endblock instantiate_comb_and_calos -%}
