{%- set ns_axo = namespace(models=[]) -%}
{%- for condition in module.signalConditions -%}
  {%- set o = condition.objects[0] -%}
  {%- if o.type == "AXO" and o.model.value not in ns_axo.models %}
    signal axol1tl_{{ o.model.value }}_score : std_logic_vector(AXO_SCORE_WIDTH-1 downto 0);
    {%- set _ = ns_axo.models.append(o.model.value) -%}
  {%- endif -%}
{%- endfor -%}
{%- set ns_topo = namespace(models=[]) -%}
{%- for condition in module.signalConditions -%}
  {%- set o = condition.objects[0] -%}
  {%- if o.type == "TOPO" and o.model.value not in ns_topo.models %}
    signal topo_{{ o.model.value }}_score : std_logic_vector(AXO_SCORE_WIDTH-1 downto 0);
    {%- set _ = ns_topo.models.append(o.model.value) -%}
  {%- endif -%}
{%- endfor -%}
