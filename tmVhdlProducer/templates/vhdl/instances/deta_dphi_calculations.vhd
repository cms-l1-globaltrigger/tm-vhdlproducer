{%- for o1, o2 in module.correlationCombinations %}
calc_deta_dphi_{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_i: entity work.deta_dphi_calculations
    generic map(
    {%- if o1.is_muon_type or o2.is_muon_type %}
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
    {%- endif %}
        dphi_integer => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer
    );
--
{%- endfor %}
