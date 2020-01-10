{%- block instantiate_comparator_iso_cut %}
    comp_iso_{{ obj|lower }}_bx_{{ bx }}_0x{{ iso_lut|lower }}_i: entity work.comparators_obj_cuts
        generic map(
            N_{{ obj|upper }}_OBJECTS, {{ obj|upper }}_ISO_WIDTH,
            ISO, X"0000", X"0000", X"{{ iso_lut|upper }}", "ign"
        )
        port map(
            lhc_clk, data.{{ obj|lower }}(bx({{ bx|bx_dec }})).iso, comp_iso_{{ obj|lower }}_bx_{{ bx }}_0x{{ iso_lut|lower }}
        );
{%- endblock instantiate_comparator_iso_cut %}
