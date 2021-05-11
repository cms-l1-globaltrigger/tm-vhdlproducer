-- Instantiations of correlation cuts calculations
--
-- Instantiations of DeltaEta LUTs

{%- for o1, o2 in module.correlationCombinationsDeta %}

calc_deta_{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_i: entity work.correlation_cuts_calculation
    generic map(
        nr_obj1 => NR_{{ o1.type | upper }}_OBJECTS,
        type_obj1 => {{ o1.type | upper }}_TYPE,
        nr_obj2 => NR_{{ o2.type | upper }}_OBJECTS,
        type_obj2 => {{ o2.type | upper }}_TYPE,
        deta_cut => true
    )
    port map(
        deta_integer => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_integer,
        deta => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta
    );
{%- endfor %}

-- Instantiations of DeltaPhi LUTs

{%- for o1, o2 in module.correlationCombinationsDphi %}

calc_dphi_{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_i: entity work.correlation_cuts_calculation
    generic map(
        nr_obj1 => NR_{{ o1.type | upper }}_OBJECTS,
        type_obj1 => {{ o1.type | upper }}_TYPE,
        nr_obj2 => NR_{{ o2.type | upper }}_OBJECTS,
        type_obj2 => {{ o2.type | upper }}_TYPE,
        dphi_cut => true
    )
    port map(
        dphi_integer => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer,
        dphi => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi
    );
{%- endfor %}

-- Instantiations of DeltaR calculation

{%- for o1, o2 in module.correlationCombinationsDeltaR %}

calc_deltaR_{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_i: entity work.correlation_cuts_calculation
    generic map(
        nr_obj1 => NR_{{ o1.type | upper }}_OBJECTS,
        type_obj1 => {{ o1.type | upper }}_TYPE,
        nr_obj2 => NR_{{ o2.type | upper }}_OBJECTS,
        type_obj2 => {{ o2.type | upper }}_TYPE,
        dr_cut => true
    )
    port map(
        deta_integer => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_integer,
        dphi_integer => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer,
        dr => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dr
    );
{%- endfor %}

-- Instantiations of Invariant mass calculation

{%- for o1, o2 in module.correlationCombinationsInvMass %}

calc_mass_inv_pt_{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_i: entity work.correlation_cuts_calculation
    generic map(
        nr_obj1 => NR_{{ o1.type | upper }}_OBJECTS,
        type_obj1 => {{ o1.type | upper }}_TYPE,
        nr_obj2 => NR_{{ o2.type | upper }}_OBJECTS,
        type_obj2 => {{ o2.type | upper }}_TYPE,
        mass_cut => true,
        mass_type => INVARIANT_MASS_TYPE,
        pt1_width => {{ o1.type | upper }}_PT_VECTOR_WIDTH,
        pt2_width => {{ o2.type | upper }}_PT_VECTOR_WIDTH,
    {%- if o1.is_calo_type and (o2.is_calo_type or o2.is_esums_type) %}
        cosh_cos_width => CALO_CALO_COSH_COS_VECTOR_WIDTH
    {%- elif (o1.is_calo_type and o2.is_muon_type) or (o1.is_muon_type and o2.is_esums_type) %}
        cosh_cos_width => CALO_MUON_COSH_COS_VECTOR_WIDTH
    {%- elif o1.is_muon_type or o2.is_muon_type %}
        cosh_cos_width => MUON_MUON_COSH_COS_VECTOR_WIDTH
    {%- endif %}
    )
    port map(
        deta_integer => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_integer,
        dphi_integer => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer,
        pt1 => {{ o1.type | lower }}_bx_{{ o1.bx }}_pt_vector,
        pt2 => {{ o2.type | lower }}_bx_{{ o2.bx }}_pt_vector,
        inv_mass_pt => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_inv_pt
    );
{%- endfor %}

-- Instantiations of Invariant mass divided DeltaR calculation

{%- for o1, o2 in module.correlationCombinationsInvMassDivDr %}

calc_mass_over_dr_{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_i: entity work.correlation_cuts_calculation
    generic map(
        nr_obj1 => NR_{{ o1.type | upper }}_OBJECTS,
        type_obj1 => {{ o1.type | upper }}_TYPE,
        nr_obj2 => NR_{{ o2.type | upper }}_OBJECTS,
        type_obj2 => {{ o2.type | upper }}_TYPE,
        pt1_width => {{ o1.type | upper }}_PT_VECTOR_WIDTH,
        pt2_width => {{ o2.type | upper }}_PT_VECTOR_WIDTH,
    {%- if o1.is_calo_type and (o2.is_calo_type or o2.is_esums_type) %}
        cosh_cos_width => CALO_CALO_COSH_COS_VECTOR_WIDTH,
    {%- elif o1.is_muon_type or o2.is_muon_type %}
        cosh_cos_width => MUON_MUON_COSH_COS_VECTOR_WIDTH,
    {%- endif %}
        mass_over_dr_cut => true,
    {%- if o1.is_calo_type and o2.is_calo_type %}
        rom_sel => CALO_CALO_ROM,
    {%- elif o1.is_calo_type and o2.is_muon_type %}
        rom_sel => CALO_MU_ROM,
    {%- elif o1.is_muon_type and o2.is_muon_type %}
        rom_sel => MU_MU_ROM,
    {%- endif %}
    {%- if o1.is_calo_type and o2.is_calo_type %}
        deta_bins_width => CALO_DETA_BINS_WIDTH_ROM,
        dphi_bins_width => CALO_DPHI_BINS_WIDTH_ROM,
    {%- elif o1.is_muon_type or o2.is_muon_type %}
        deta_bins_width => MU_DETA_BINS_WIDTH_ROM,
        dphi_bins_width => MU_DETA_BINS_WIDTH_ROM,
    {%- endif %}
    {%- if o1.is_calo_type and o2.is_calo_type %}
        inverted_dr_sq_width => CALO_CALO_INV_DR_SQ_VECTOR_WIDTH
    {%- elif o1.is_muon_type or o2.is_muon_type %}
        inverted_dr_sq_width => MU_MU_INV_DR_SQ_VECTOR_WIDTH
    {%- endif %}
    )
    port map(
        lhc_clk,
        deta_integer => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_integer,
        dphi_integer => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer,
        inv_mass_pt_in => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_inv_pt,
        mass_over_dr => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_over_dr
    );
{%- endfor %}

-- Instantiations of Invariant mass unconstrained pt calculation

{%- for o1, o2 in module.correlationCombinationsInvMassUpt %}

calc_mass_inv_upt_{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_i: entity work.correlation_cuts_calculation
    generic map(
        nr_obj1 => NR_{{ o1.type | upper }}_OBJECTS,
        type_obj1 => {{ o1.type | upper }}_TYPE,
        nr_obj2 => NR_{{ o2.type | upper }}_OBJECTS,
        type_obj2 => {{ o2.type | upper }}_TYPE,
        mass_cut => true,
        mass_type => INVARIANT_MASS_UPT_TYPE,
        upt1_width => {{ o1.type | upper }}_UPT_VECTOR_WIDTH,
        upt2_width => {{ o2.type | upper }}_UPT_VECTOR_WIDTH,
        cosh_cos_width => MUON_MUON_COSH_COS_VECTOR_WIDTH
    )
    port map(
        deta_integer => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_deta_integer,
        dphi_integer => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer,
        upt1 => {{ o1.type | lower }}_bx_{{ o1.bx }}_upt_vector,
        upt2 => {{ o2.type | lower }}_bx_{{ o2.bx }}_upt_vector,
        inv_mass_upt => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_inv_upt
    );
{%- endfor %}

-- Instantiations of Transverse mass calculation

{%- for o1, o2 in module.correlationCombinationsTransMass %}

calc_mass_trans_{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_i: entity work.correlation_cuts_calculation
    generic map(
        nr_obj1 => NR_{{ o1.type | upper }}_OBJECTS,
        type_obj1 => {{ o1.type | upper }}_TYPE,
        nr_obj2 => NR_{{ o2.type | upper }}_OBJECTS,
        type_obj2 => {{ o2.type | upper }}_TYPE,
        mass_cut => true,
        mass_type => TRANSVERSE_MASS_TYPE,
        pt1_width => {{ o1.type | upper }}_PT_VECTOR_WIDTH,
        pt2_width => {{ o2.type | upper }}_PT_VECTOR_WIDTH,
    {%- if o1.is_calo_type and o2.is_esums_type %}
        cosh_cos_width => CALO_CALO_COSH_COS_VECTOR_WIDTH,
    {%- elif o1.is_muon_type and o2.is_esums_type %}
        cosh_cos_width => CALO_MUON_COSH_COS_VECTOR_WIDTH,
    {%- endif %}
    {%- if o1.is_calo_type and o2.is_esums_type %}
        cosh_cos_precision => CALO_CALO_COSH_COS_PRECISION
    {%- elif o1.is_muon_type and o2.is_esums_type %}
        cosh_cos_precision => CALO_MUON_COSH_COS_PRECISION
    {%- endif %}
    )
    port map(
        dphi_integer => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_dphi_integer,
        pt1 => {{ o1.type | lower }}_bx_{{ o1.bx }}_pt_vector,
        pt2 => {{ o2.type | lower }}_bx_{{ o2.bx }}_pt_vector,
        trans_mass => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_mass_trans
    );
{%- endfor %}

-- Instantiations of Two-body pt calculation

{%- for o1, o2 in module.correlationCombinationsTbpt %}

calc_tbpt_{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_i: entity work.correlation_cuts_calculation
    generic map(
        nr_obj1 => NR_{{ o1.type | upper }}_OBJECTS,
        nr_obj2 => NR_{{ o2.type | upper }}_OBJECTS,
        tbpt_cut => true,
        pt1_width => {{ o1.type | upper }}_PT_VECTOR_WIDTH,
        pt2_width => {{ o2.type | upper }}_PT_VECTOR_WIDTH,
    {%- if o1.is_calo_type and (o2.is_calo_type or o2.is_esums_type) %}
        sin_cos_width => CALO_SIN_COS_VECTOR_WIDTH,
    {%- elif o1.is_muon_type or o2.is_muon_type %}
        sin_cos_width => MUON_SIN_COS_VECTOR_WIDTH,
    {%- endif %}
    {%- if o1.is_calo_type and (o2.is_calo_type or o2.is_esums_type) %}
        sin_cos_precision => CALO_SIN_COS_PRECISION
    {%- elif o1.is_muon_type or o2.is_muon_type %}
        sin_cos_precision => MUON_SIN_COS_PRECISION
    {%- endif %}
    )
    port map(
        pt1 => {{ o1.type | lower }}_bx_{{ o1.bx }}_pt_vector,
        pt2 => {{ o2.type | lower }}_bx_{{ o2.bx }}_pt_vector,
    {%- if o1.is_calo_type and o2.is_muon_type %}
        cos_phi_integer1 => {{ o1.type|lower }}_bx_{{ o1.bx }}_conv_cos_phi,
        cos_phi_integer2 => {{ o2.type|lower }}_bx_{{ o2.bx }}_cos_phi,
        sin_phi_integer1 => {{ o1.type|lower }}_bx_{{ o1.bx }}_conv_sin_phi,
        sin_phi_integer2 => {{ o2.type|lower }}_bx_{{ o2.bx }}_sin_phi,
    {%- elif o1.is_muon_type and o2.is_esums_type %}
        cos_phi_integer1 => {{ o1.type|lower }}_bx_{{ o1.bx }}_cos_phi,
        cos_phi_integer2 => {{ o2.type|lower }}_bx_{{ o2.bx }}_conv_cos_phi,
        sin_phi_integer1 => {{ o1.type|lower }}_bx_{{ o1.bx }}_sin_phi,
        sin_phi_integer2 => {{ o2.type|lower }}_bx_{{ o2.bx }}_conv_sin_phi,
    {%- else %}
        cos_phi_integer1 => {{ o1.type|lower }}_bx_{{ o1.bx }}_cos_phi,
        cos_phi_integer2 => {{ o2.type|lower }}_bx_{{ o2.bx }}_cos_phi,
        sin_phi_integer1 => {{ o1.type|lower }}_bx_{{ o1.bx }}_sin_phi,
        sin_phi_integer2 => {{ o2.type|lower }}_bx_{{ o2.bx }}_sin_phi,
    {%- endif %}
        tbpt => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_tbpt
    );

{%- endfor %}
