{%- block instantiate_minbiashf_condition %}
  {%- set o = condition.objects[0] %}
{{ condition.vhdl_signal }}_i: entity work.min_bias_hf_conditions
    generic map(
    {%- if not o.operator %}
        et_ge_mode => {{ o.operator|vhdl_bool }}, 
    {%- endif %}        
        obj_type => {{ o.type|upper }}_TYPE, 
        count_threshold => X"{{ o.count|X01 }}"
    )
    port map(
        lhc_clk, 
        {{ o.type|lower }}_bx_{{ o.bx }}, 
        {{ condition.vhdl_signal }}
    );
{%- endblock instantiate_minbiashf_condition %}
{# eof #}
