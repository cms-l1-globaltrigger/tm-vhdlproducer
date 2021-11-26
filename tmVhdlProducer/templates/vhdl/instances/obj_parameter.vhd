{%- for o in module.correlationObjects %}
calc_obj_parameter_{{ o.type | lower }}_bx_{{ o.bx }}_i: entity work.obj_parameter
    generic map(
        nr_obj => NR_{{ o.type | upper }}_OBJECTS,
        type_obj => {{ o.type | upper }}_TYPE
    )
    port map(
    {%- if o.is_calo_type %}
        calo => bx_data.{{ o.type | lower }}({{ o.bx_arr }}),
    {%- elif o.is_muon_type %}
        muon => bx_data.{{ o.type | lower }}({{ o.bx_arr }}),
    {%- elif o.is_esums_type %}
        esums => bx_data.{{ o.type | lower }}({{ o.bx_arr }}),
    {%- endif %}
    {%- if not o.is_muon_type %}
        phi_conv_2_muon_phi_integer => {{ o.type | lower }}_bx_{{ o.bx }}_phi_conv_2_muon_phi_integer,
    {%- endif %}
        pt_vector => {{ o.type | lower }}_bx_{{ o.bx }}_pt_vector,
    {%- if o.is_muon_type %}
        upt_vector => {{ o.type | lower }}_bx_{{ o.bx }}_upt_vector,
    {%- endif %}
    {%- if not o.is_esums_type %}
        eta_integer => {{ o.type | lower }}_bx_{{ o.bx }}_eta_integer,
    {%- endif %}
        phi_integer => {{ o.type | lower }}_bx_{{ o.bx }}_phi_integer,
    {%- if o.is_muon_type %}
        eta_integer_h_r => {{ o.type | lower }}_bx_{{ o.bx }}_eta_integer_half_res,
        phi_integer_h_r => {{ o.type | lower }}_bx_{{ o.bx }}_phi_integer_half_res,
    {%- endif %}
        cos_phi => {{ o.type | lower }}_bx_{{ o.bx }}_cos_phi,
    {%- if not o.is_muon_type %}
        sin_phi => {{ o.type | lower }}_bx_{{ o.bx }}_sin_phi,
        conv_cos_phi => {{ o.type | lower }}_bx_{{ o.bx }}_conv_cos_phi,
        conv_sin_phi => {{ o.type | lower }}_bx_{{ o.bx }}_conv_sin_phi
    {%- else %}
        sin_phi => {{ o.type | lower }}_bx_{{ o.bx }}_sin_phi
    {%- endif %}
    );
--

{%- endfor %}
