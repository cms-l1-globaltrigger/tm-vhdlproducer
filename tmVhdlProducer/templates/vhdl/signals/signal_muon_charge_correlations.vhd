{%- block bx_comb_loop scoped %}
  {%- for o1, o2 in module.muonBxCombinations %}
    signal ls_charcorr_double_bx_{{ o1.bx }}_bx_{{ o2.bx }}, os_charcorr_double_bx_{{ o1.bx }}_bx_{{ o2.bx }} : std_logic_2dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1);
    signal ls_charcorr_triple_bx_{{ o1.bx }}_bx_{{ o2.bx }}, os_charcorr_triple_bx_{{ o1.bx }}_bx_{{ o2.bx }} : std_logic_3dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1);
    signal ls_charcorr_quad_bx_{{ o1.bx }}_bx_{{ o2.bx }}, os_charcorr_quad_bx_{{ o1.bx }}_bx_{{ o2.bx }} : std_logic_4dim_array(0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1, 0 to NR_MU_OBJECTS-1);
  {%- endfor %}
{%- endblock bx_comb_loop %}
