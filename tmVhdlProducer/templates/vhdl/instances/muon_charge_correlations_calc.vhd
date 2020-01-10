{%- block instantiate_muon_charge_correlations_calc %}
    calc_muon_charge_correlations_bx_{{ bx1 }}_bx_{{ bx2 }}_i: entity work.muon_charge_correlations
        port map(
            data.mu(bx({{ bx1|bx_dec }})).charge,
            data.mu(bx({{ bx2|bx_dec }})).charge,
            cc_double(bx({{ bx1|bx_dec }}),bx({{ bx2|bx_dec }})),
            cc_triple(bx({{ bx1|bx_dec }}),bx({{ bx2|bx_dec }})),
            cc_quad(bx({{ bx1|bx_dec }}),bx({{ bx2|bx_dec }}))
        );
{%- endblock instantiate_muon_charge_correlations_calc %}
