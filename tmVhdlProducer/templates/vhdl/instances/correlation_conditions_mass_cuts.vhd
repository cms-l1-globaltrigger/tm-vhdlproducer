{%- for o1, o2 in module.correlationCombinations %}
{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_deta_cos_dphi_i: entity work.cosh_deta_cos_dphi
    generic map(
    {%- if o1.is_calo_type and o2.is_calo_type %}
        calo_calo_cosh_deta_lut => {{ o1.type | upper }}_{{ o2.type | upper }}_COSH_DETA_LUT,
    {%- endif %}
    {%- if o1.is_calo_type and (o2.is_calo_type or o2.is_esums_type) %}
        calo_calo_cos_dphi_lut => {{ o1.type | upper }}_{{ o2.type | upper }}_COS_DPHI_LUT,
    {%- endif %}
    {%- if o1.is_calo_type and o2.is_muon_type %}
        calo_muon_cosh_deta_lut => {{ o1.type | upper }}_{{ o2.type | upper }}_COSH_DETA_LUT,
    {%- endif %}
    {%- if (o1.is_calo_type and o2.is_muon_type) or (o1.is_muon_type and o2.is_esums_type) %}
        calo_muon_cos_dphi_lut => {{ o1.type | upper }}_{{ o2.type | upper }}_COS_DPHI_LUT,
    {%- endif %}
    {%- if o1.is_muon_type and o2.is_muon_type %}
        muon_muon_cosh_deta_lut => {{ o1.type | upper }}_{{ o2.type | upper }}_COSH_DETA_LUT,
        muon_muon_cos_dphi_lut => {{ o1.type | upper }}_{{ o2.type | upper }}_COS_DPHI_LUT,
    {%- endif %}
    {%- if not o2.is_esums_type %}
        deta_bins_width => {{ o1.type | upper }}_{{ o2.type | upper }}_DETA_BINS_WIDTH,
        dphi_bins_width => {{ o1.type | upper }}_{{ o2.type | upper }}_DPHI_BINS_WIDTH,
    {%- endif %}
        cosh_cos_vector_width => {{ o1.type | upper }}_{{ o2.type | upper }}_COSH_COS_VECTOR_WIDTH,
        nr_obj1 => NR_{{ o1.type | upper }}_OBJECTS,
        type_obj1 => {{ o1.type | upper }}_TYPE,
        nr_obj2 => NR_{{ o2.type | upper }}_OBJECTS,
        type_obj2 => {{ o2.type | upper }}_TYPE
    )
    port map(
        dphi_integer => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer,
    {%- if not o2.is_esums_type %}
        deta_integer => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_integer,
        deta_bin_vector => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_bin_vector,
        dphi_bin_vector => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_bin_vector,
        cosh_deta_vector => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_deta_vector,
    {%- endif %}
        cos_dphi_vector => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector
    );
--
{%- endfor %}

{%- for o1, o2 in module.correlationCombinationsInvMassDivDr %}
-- Instantiations of invariant mass over deltaR calculation modules

{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_div_dr_i: entity work.mass_div_dr
    generic map(
        NR_{{ o1.type | upper }}_OBJECTS,
        NR_{{ o2.type | upper }}_OBJECTS,
        {{ o1.type | upper }}_{{ o2.type | upper }}_ROM,
        {{ o1.type | upper }}_{{ o2.type | upper }}_DETA_BINS_WIDTH_ROM,
        {{ o1.type | upper }}_{{ o2.type | upper }}_DPHI_BINS_WIDTH_ROM,
        {{ o1.type | upper }}_PT_VECTOR_WIDTH,
        {{ o2.type | upper }}_PT_VECTOR_WIDTH,
        {{ o1.type | upper }}_{{ o2.type | upper }}_COSH_COS_VECTOR_WIDTH,
        {{ o1.type | upper }}_{{ o2.type | upper }}_INV_DR_SQ_VECTOR_WIDTH
    )
    port map(
        lhc_clk,
        {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_bin_vector,
        {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_bin_vector,
        {{ o1.type | lower }}_bx_0_pt_vector,
        {{ o2.type | lower }}_bx_0_pt_vector,
        {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_deta_vector,
        {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector,
        {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_div_dr
    );
{%- endfor %}
