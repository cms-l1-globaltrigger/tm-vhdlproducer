{%- block instantiate_comparator_eta_cut %}
    comp_eta_{{ obj|lower }}_bx_{{ bx }}_0x{{ limit_l|lower }}_0x{{ limit_u|lower }}_i: entity work.comparators_obj_cuts
        generic map(
            N_{{ obj|upper }}_OBJECTS, {{ obj|upper }}_ETA_WIDTH,
            ETA, X"{{ limit_l|upper }}", X"{{ limit_u|upper }}", X"0000", "ign"
        )
        port map(
            lhc_clk, data.{{ obj|lower }}(bx({{ bx|bx_dec }})).eta, comp_eta_{{ obj|lower }}_bx_{{ bx }}_0x{{ limit_l|lower }}_0x{{ limit_u|lower }}
        );
{%- endblock instantiate_comparator_eta_cut %}
