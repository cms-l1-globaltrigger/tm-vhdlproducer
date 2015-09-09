{%- for algoName in menu.reporter['index_sorted'] %}
{%- set algoIndex = menu.reporter['algoDict'][algoName]["index"] %}
{%- if algoIndex in menu.reporter['m2a'][iMod]%}
    signal {{algoName}} : std_logic;
{%-endif%}
{%-endfor%}
