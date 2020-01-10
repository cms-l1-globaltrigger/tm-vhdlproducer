{%- block instantiate_comparator_muon_charge_corr_triple %}
    comp_cc_triple_bx_{{ bx1 }}_bx_{{ bx2 }}_cc_{{ cc_val|lower }}_i: entity work.comparators_muon_charge_corr
        generic map(
            triple, CC_{{ cc_val|upper }}
        )
        port map(
            lhc_clk, 
            cc_triple => cc_triple(bx({{ bx1|bx_dec }}),bx({{ bx2|bx_dec }})), 
            comp_o_triple => comp_cc_triple_bx_{{ bx1 }}_bx_{{ bx2 }}_cc_{{ cc_val|lower }}
        );
{%- endblock instantiate_comparator_muon_charge_corr_triple %}
