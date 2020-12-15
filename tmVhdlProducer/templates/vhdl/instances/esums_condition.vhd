{%- block instantiate_esums_condition %}
  {%- set o = condition.objects[0] %}
    {%- if o.is_esums_type  %}
{{ condition.vhdl_signal }}_i: entity work.esums_conditions
    generic map(
    {%- if not o.operator %}
        et_ge_mode => {{ o.operator|vhdl_bool }}, 
    {%- endif %}        
    {%- if o.hasCount  %}
        count_threshold => X"{{ o.count|X04 }}",
    {%- else %}
        et_threshold => X"{{ o.threshold|X04 }}",
    {%- endif %}
    {%- if o.phiNrCuts > 0 %}
        phi_full_range => {{ o.phiFullRange }}, 
        phi_w1_upper_limit => X"{{ o.phiW1UpperLimit|X04 }}", 
        phi_w1_lower_limit => X"{{ o.phiW1LowerLimit|X04 }}",
    {%- endif %}
    {%- if o.phiNrCuts > 1 %}
        phi_w2_ignore => {{ o.phiW2Ignore }},
        phi_w2_upper_limit => X"{{ o.phiW2UpperLimit|X04 }}",
        phi_w2_lower_limit => X"{{ o.phiW2LowerLimit|X04 }}",
    {%- endif %}        
        obj_type => {{ o.type|upper }}_TYPE
    )
    port map(
        lhc_clk, 
        {{ o.type|lower }}_bx_{{ o.bx }}, 
        {{ condition.vhdl_signal }}
    );
    {%- endif %}
{%- endblock instantiate_esums_condition %}
{# eof #}
