{%- block bxComb_loop %}
  {%- for o1, o2 in module.muonBxCombinations %}
calc_muon_charge_correlations_bx_{{ o1.bx }}_bx_{{ o2.bx }}_i: entity work.muon_charge_correlations
    port map(bx_data.mu({{ o1.bx_arr }}), bx_data.mu({{ o2.bx_arr }}),
        ls_charcorr_double_bx_{{ o1.bx }}_bx_{{ o2.bx }}, os_charcorr_double_bx_{{ o1.bx }}_bx_{{ o2.bx }},
        ls_charcorr_triple_bx_{{ o1.bx }}_bx_{{ o2.bx }}, os_charcorr_triple_bx_{{ o1.bx }}_bx_{{ o2.bx }},
        ls_charcorr_quad_bx_{{ o1.bx }}_bx_{{ o2.bx }}, os_charcorr_quad_bx_{{ o1.bx }}_bx_{{ o2.bx }});
--
  {%-endfor%}
{%- endblock bxComb_loop %}

