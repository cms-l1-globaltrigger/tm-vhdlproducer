{%- block instantiate_comparator_charge_cut %}
    comp_charge_{{ obj|lower }}_bx_{{ bx }}_{{ charge_str }}_i: entity work.comparators_obj_cuts
        generic map(
            N_{{ obj|upper }}_OBJECTS, {{ obj|upper }}_CHARGE_WIDTH,
            CHARGE, X"0000", X"0000", X"0000", "{{ charge_str }}"
        )
        port map(
            lhc_clk, data.{{ obj|lower }}(bx({{ bx|bx_dec }})).charge, comp_charge_{{ obj|lower }}_bx_{{ bx }}_{{ charge_str }}
        );
{%- endblock instantiate_comparator_charge_cut %}
