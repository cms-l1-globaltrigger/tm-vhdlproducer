{%- for o1, o2 in module.correlationCombinations %}
deta_dphi_{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_i: entity work.deta_dphi_calculations
    generic map(
    {%- if o1.is_calo_type and o2.is_calo_type %}
        calo_calo_deta_lut => {{ o1.type | upper }}_{{ o2.type | upper }}_DIFF_ETA_LUT,
    {%- endif %}
    {%- if o1.is_calo_type and (o2.is_esums_type or o2.is_calo_type) %}
        calo_calo_dphi_lut => {{ o1.type | upper }}_{{ o2.type | upper }}_DIFF_PHI_LUT,
        phi_half_range => CALO_PHI_HALF_RANGE_BINS,
    {%- endif %}
    {%- if o1.is_calo_type and o2.is_muon_type %}
        calo_muon_deta_lut => {{ o1.type | upper }}_{{ o2.type | upper }}_DIFF_ETA_LUT,
        calo_muon_dphi_lut => {{ o1.type | upper }}_{{ o2.type | upper }}_DIFF_PHI_LUT,
        phi_half_range => MUON_PHI_HALF_RANGE_BINS,
    {%- endif %}
    {%- if o1.is_muon_type and o2.is_esums_type %}
        calo_muon_dphi_lut => {{ o1.type | upper }}_{{ o2.type | upper }}_DIFF_PHI_LUT,
    {%- endif %}
    {%- if o1.is_muon_type and o2.is_muon_type %}
        muon_muon_deta_lut => {{ o1.type | upper }}_{{ o2.type | upper }}_DIFF_ETA_LUT,
        muon_muon_dphi_lut => {{ o1.type | upper }}_{{ o2.type | upper }}_DIFF_PHI_LUT,
    {%- endif %}
    {%- if o1.is_muon_type %}
        phi_half_range => MUON_PHI_HALF_RANGE_BINS,
    {%- endif %}
        nr_obj1 => NR_{{ o1.type | upper }}_OBJECTS,
        type_obj1 => {{ o1.type | upper }}_TYPE,
        nr_obj2 => NR_{{ o2.type | upper }}_OBJECTS,
        type_obj2 => {{ o2.type | upper }}_TYPE
    )
    port map(
    {%- if (o1.is_calo_type and o2.is_calo_type) or (o1.is_muon_type and o2.is_muon_type) %}
        eta_integer_obj1 => {{ o1.type | lower }}_bx_{{ o1.bx }}_eta_integer,
        phi_integer_obj1 => {{ o1.type | lower }}_bx_{{ o1.bx }}_phi_integer,
        eta_integer_obj2 => {{ o2.type | lower }}_bx_{{ o2.bx }}_eta_integer,
        phi_integer_obj2 => {{ o2.type | lower }}_bx_{{ o2.bx }}_phi_integer,
    {%- endif %}
    {%- if o1.is_calo_type and o2.is_muon_type %}
        eta_integer_obj1 => {{ o1.type | lower }}_bx_{{ o1.bx }}_eta_conv_2_muon_eta_integer,
        phi_integer_obj1 => {{ o1.type | lower }}_bx_{{ o1.bx }}_phi_conv_2_muon_phi_integer,
        eta_integer_obj2 => {{ o2.type | lower }}_bx_{{ o2.bx }}_eta_integer,
        phi_integer_obj2 => {{ o2.type | lower }}_bx_{{ o2.bx }}_phi_integer,
    {%- endif %}
    {%- if o1.is_calo_type and o2.is_esums_type %}
        phi_integer_obj1 => {{ o1.type | lower }}_bx_{{ o1.bx }}_phi_integer,
        phi_integer_obj2 => {{ o2.type | lower }}_bx_{{ o2.bx }}_phi_integer,
    {%- endif %}
    {%- if o1.is_muon_type and o2.is_esums_type %}
        phi_integer_obj1 => {{ o1.type | lower }}_bx_{{ o1.bx }}_phi_integer,
        phi_integer_obj2 => {{ o2.type | lower }}_bx_{{ o2.bx }}_phi_conv_2_muon_phi_integer,
    {%- endif %}
    {%- if not o2.is_esums_type %}
        deta_integer => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_integer,
        deta_vector => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_vector,
    {%- endif %}
        dphi_integer => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer,
        dphi_vector => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_vector
    );
--
{%- endfor %}
