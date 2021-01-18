{%- block instantiate_correlation_conditions_differences %}
  {%- for o1, o2 in module.correlationCombinations %}

    {%- if o2.is_esums_type %}
    {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_l1: for i in 0 to NR_{{ o1.type|upper }}_OBJECTS-1 generate
        {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_l2: for j in 0 to NR_{{ o2.type|upper }}_OBJECTS-1 generate
            {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector(i,j) <= CONV_STD_LOGIC_VECTOR({{ o1.type|upper }}_{{ o2.type|upper }}_COS_DPHI_LUT({{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer(i,j)), {{ o1.type|upper }}_{{ o2.type|upper }}_COSH_COS_VECTOR_WIDTH);
        end generate {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_l2;
    end generate {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_l1;

    {%- else %}
    {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_cos_l1: for i in 0 to NR_{{ o1.type|upper }}_OBJECTS-1 generate
        {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_cos_l2: for j in 0 to NR_{{ o2.type|upper }}_OBJECTS-1 generate
            {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_deta_vector(i,j) <= CONV_STD_LOGIC_VECTOR({{ o1.type|upper }}_{{ o2.type|upper }}_COSH_DETA_LUT({{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_integer(i,j)), {{ o1.type|upper }}_{{ o2.type|upper }}_COSH_COS_VECTOR_WIDTH);
            {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector(i,j) <= CONV_STD_LOGIC_VECTOR({{ o1.type|upper }}_{{ o2.type|upper }}_COS_DPHI_LUT({{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer(i,j)), {{ o1.type|upper }}_{{ o2.type|upper }}_COSH_COS_VECTOR_WIDTH);
            {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_bin_vector(i,j) <= CONV_STD_LOGIC_VECTOR({{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_integer(i,j), {{ o1.type|upper }}_{{ o2.type|upper }}_DETA_BINS_WIDTH);
            {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_bin_vector(i,j) <= CONV_STD_LOGIC_VECTOR({{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer(i,j), {{ o1.type|upper }}_{{ o2.type|upper }}_DPHI_BINS_WIDTH);
        end generate {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_cos_l2;
    end generate {{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_cos_l1;

    {%- endif %}
  {%- endfor %}

  {%- for o1, o2 in module.correlationCombinationsInvMassDivDr %}
    {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_calc_l1: for i in 0 to NR_{{ o1.type | upper }}_OBJECTS-1 generate
        {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_calc_l2: for j in 0 to NR_{{ o2.type | upper }}_OBJECTS-1 generate
            calculator_i: entity work.mass_div_dr_calculator
                generic map(
                    {{ o1.type | upper }}_{{ o2.type | upper }}_ROM, {{ o1.type | upper }}_{{ o2.type | upper }}_DETA_BINS_WIDTH_ROM, {{ o1.type | upper }}_{{ o2.type | upper }}_DPHI_BINS_WIDTH_ROM,
                    {{ o1.type | upper }}_PT_VECTOR_WIDTH, {{ o2.type | upper }}_PT_VECTOR_WIDTH, {{ o1.type | upper }}_{{ o2.type | upper }}_COSH_COS_VECTOR_WIDTH, {{ o1.type | upper }}_{{ o2.type | upper }}_INV_DR_SQ_VECTOR_WIDTH
                )
                port map(
                    lhc_clk,
                    {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_bin_vector(i,j)({{ o1.type | upper }}_{{ o2.type | upper }}_DETA_BINS_WIDTH-1 downto {{ o1.type | upper }}_{{ o2.type | upper }}_DETA_BINS_WIDTH-{{ o1.type | upper }}_{{ o2.type | upper }}_DETA_BINS_WIDTH_ROM),
                    {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_bin_vector(i,j)({{ o1.type | upper }}_{{ o2.type | upper }}_DPHI_BINS_WIDTH-1 downto {{ o1.type | upper }}_{{ o2.type | upper }}_DPHI_BINS_WIDTH-{{ o1.type | upper }}_{{ o2.type | upper }}_DPHI_BINS_WIDTH_ROM),
                    {{ o1.type | lower }}_pt_vector_bx_0(i)({{ o1.type | upper }}_PT_VECTOR_WIDTH-1 downto 0),
                    {{ o2.type | lower }}_pt_vector_bx_0(j)({{ o2.type | upper }}_PT_VECTOR_WIDTH-1 downto 0),
                    {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_deta_vector(i,j),
                    {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector(i,j),
                    {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_div_dr(i,j)
                );
        end generate {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_calc_l2;
    end generate {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_calc_l1;
  {%- endfor %}

{%- endblock instantiate_correlation_conditions_differences %}
{# eof #}
