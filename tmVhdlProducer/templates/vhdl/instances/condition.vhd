{% block signal %}{{ condition.vhdl_signal }}{% endblock %}_i: entity {% block entity %}{% endblock %}
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
