cond_{{ condition.vhdl_signal }}_i: entity {% block entity %}{% endblock %}
    generic map(
{%- block generic_map %}
{%- endblock %}
    )
    port map(
        lhc_clk,
{%- block port_map %}
{%- endblock %}
        condition_o => {{ condition.vhdl_signal }}
    );
