{%- block instantiate_comparator_count %}
    comp_count_{{ obj|lower }}_bx_{{ bx }}_0x{{ count|lower }}_i: entity work.comparators_obj_cuts
        generic map(
            N_{{ obj|upper }}_OBJECTS, {{ obj|upper }}_WIDTH,
            GE, X"{{ count }}", X"0000", X"0000", "ign"
        )
        port map(
            lhc_clk, data.{{ obj|lower }}(bx({{ bx|bx_dec }})).count, comp_count_{{ obj|lower }}_bx_{{ bx }}_0x{{ count|lower }}
        );
{%- endblock instantiate_comparator_count %}
