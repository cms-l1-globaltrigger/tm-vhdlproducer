{%- block instantiate_correlation_conditions_differences %}
  {%- for o1, o2 in module.correlationCombinations %}
    {%- if o1.is_muon_type and o2.is_esums_type %}
    {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_i: entity work.sub_phi_integer_obj_vs_obj
        generic map(NR_{{ o1.type | upper }}_OBJECTS, NR_{{ o2.type | upper }}_OBJECTS, MUON_PHI_HALF_RANGE_BINS)
        port map({{ o1.type | lower }}_bx_{{ o1.bx }}_phi_integer, {{ o2.type | lower }}_bx_{{ o2.bx }}_phi_conv_2_muon_phi_integer, {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer);
    {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_l1: for i in 0 to NR_{{ o1.type | upper }}_OBJECTS-1 generate
        {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_l2: for j in 0 to NR_{{ o2.type | upper }}_OBJECTS-1 generate
            {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_vector(i,j) <= CONV_STD_LOGIC_VECTOR({{ o1.type | upper }}_{{ o2.type | upper }}_DIFF_PHI_LUT({{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
        end generate {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_l2;
    end generate {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_l1;

    {%- elif o1.is_calo_type and o2.is_muon_type %}
    {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_i: entity work.sub_eta_integer_obj_vs_obj
        generic map(NR_{{ o1.type | upper }}_OBJECTS, NR_{{ o2.type | upper }}_OBJECTS)
        port map({{ o1.type | lower }}_bx_{{ o1.bx }}_eta_conv_2_muon_eta_integer, {{ o2.type | lower }}_bx_{{ o2.bx }}_eta_integer, {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_integer);
    {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_i: entity work.sub_phi_integer_obj_vs_obj
        generic map(NR_{{ o1.type | upper }}_OBJECTS, NR_{{ o2.type | upper }}_OBJECTS, MUON_PHI_HALF_RANGE_BINS)
        port map({{ o1.type | lower }}_bx_{{ o1.bx }}_phi_conv_2_muon_phi_integer, {{ o2.type | lower }}_bx_{{ o2.bx }}_phi_integer, {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer);
    {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_l1: for i in 0 to NR_{{ o1.type | upper }}_OBJECTS-1 generate
        {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_l2: for j in 0 to NR_{{ o2.type | upper }}_OBJECTS-1 generate
            {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_vector(i,j) <= CONV_STD_LOGIC_VECTOR({{ o1.type | upper }}_{{ o2.type | upper }}_DIFF_ETA_LUT({{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_integer(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
            {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_vector(i,j) <= CONV_STD_LOGIC_VECTOR({{ o1.type | upper }}_{{ o2.type | upper }}_DIFF_PHI_LUT({{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
        end generate {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_l2;
    end generate {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_l1;

    {%- elif o1.is_muon_type and o2.is_muon_type %}
    {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_i: entity work.sub_eta_integer_obj_vs_obj
        generic map(NR_{{ o1.type | upper }}_OBJECTS, NR_{{ o2.type | upper }}_OBJECTS)
        port map({{ o1.type | lower }}_bx_{{ o1.bx }}_eta_integer, {{ o2.type | lower }}_bx_{{ o2.bx }}_eta_integer, {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_integer);
    {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_i: entity work.sub_phi_integer_obj_vs_obj
        generic map(NR_{{ o1.type | upper }}_OBJECTS, NR_{{ o2.type | upper }}_OBJECTS, MUON_PHI_HALF_RANGE_BINS)
        port map({{ o1.type | lower }}_bx_{{ o1.bx }}_phi_integer, {{ o2.type | lower }}_bx_{{ o2.bx }}_phi_integer, {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer);
    {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_l1: for i in 0 to NR_{{ o1.type | upper }}_OBJECTS-1 generate
        {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_l2: for j in 0 to NR_{{ o2.type | upper }}_OBJECTS-1 generate
            {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_vector(i,j) <= CONV_STD_LOGIC_VECTOR({{ o1.type | upper }}_{{ o2.type | upper }}_DIFF_ETA_LUT({{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_integer(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
            {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_vector(i,j) <= CONV_STD_LOGIC_VECTOR({{ o1.type | upper }}_{{ o2.type | upper }}_DIFF_PHI_LUT({{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
        end generate {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_l2;
    end generate {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_l1;

    {%- elif o1.is_calo_type and o2.is_esums_type  %}
    {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_i: entity work.sub_phi_integer_obj_vs_obj
        generic map(NR_{{ o1.type | upper }}_OBJECTS, NR_{{ o2.type | upper }}_OBJECTS, CALO_PHI_HALF_RANGE_BINS)
        port map({{ o1.type | lower }}_bx_{{ o1.bx }}_phi_integer, {{ o2.type | lower }}_bx_{{ o2.bx }}_phi_integer, {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer);
    {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_l1: for i in 0 to NR_{{ o1.type | upper }}_OBJECTS-1 generate
        {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_l2: for j in 0 to NR_{{ o2.type | upper }}_OBJECTS-1 generate
            {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_vector(i,j) <= CONV_STD_LOGIC_VECTOR({{ o1.type | upper }}_{{ o2.type | upper }}_DIFF_PHI_LUT({{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
        end generate {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_l2;
    end generate {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_l1;

    {%- else %}
    {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_i: entity work.sub_eta_integer_obj_vs_obj
        generic map(NR_{{ o1.type | upper }}_OBJECTS, NR_{{ o2.type | upper }}_OBJECTS)
        port map({{ o1.type | lower }}_bx_{{ o1.bx }}_eta_integer, {{ o2.type | lower }}_bx_{{ o2.bx }}_eta_integer, {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_integer);
    {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_i: entity work.sub_phi_integer_obj_vs_obj
        generic map(NR_{{ o1.type | upper }}_OBJECTS, NR_{{ o2.type | upper }}_OBJECTS, CALO_PHI_HALF_RANGE_BINS)
        port map({{ o1.type | lower }}_bx_{{ o1.bx }}_phi_integer, {{ o2.type | lower }}_bx_{{ o2.bx }}_phi_integer, {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer);
    {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_l1: for i in 0 to NR_{{ o1.type | upper }}_OBJECTS-1 generate
        {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_l2: for j in 0 to NR_{{ o2.type | upper }}_OBJECTS-1 generate
            {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_vector(i,j) <= CONV_STD_LOGIC_VECTOR({{ o1.type | upper }}_{{ o2.type | upper }}_DIFF_ETA_LUT({{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_integer(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
            {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_vector(i,j) <= CONV_STD_LOGIC_VECTOR({{ o1.type | upper }}_{{ o2.type | upper }}_DIFF_PHI_LUT({{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer(i,j)),DETA_DPHI_VECTOR_WIDTH_ALL);
        end generate {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_l2;
    end generate {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_l1;

    {%- endif %}

  {%- endfor %}
{%- endblock instantiate_correlation_conditions_differences %}
{# eof #}
