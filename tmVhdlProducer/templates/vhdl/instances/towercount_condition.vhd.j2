{%- block instantiate_towercount_condition %}
  {%- set o = condition.objects[0] %}
{{ condition.vhdl_signal }}_i: entity work.towercount_condition
    generic map(
    {%- if not o.operator %}
        et_ge_mode => {{ o.operator|vhdl_bool }}, 
    {%- endif %}        
        count_threshold => X"{{ o.count|X04 }}"
    )
    port map(
        lhc_clk, 
        {{ o.type|lower }}_bx_{{ o.bx }}, 
        {{ condition.vhdl_signal }}
    );
{%- endblock instantiate_towercount_condition %}
{# eof #}
