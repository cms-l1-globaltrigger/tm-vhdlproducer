{%- for o in module.correlationObjects %}
    {{ o.type | lower }}_bx_{{ o.bx }}_parameter_i: entity work.obj_parameter
        generic map(
            nr_obj => NR_{{ o.type | upper }}_OBJECTS,
            type_obj => {{ o.type | upper }}_TYPE
        )
        port map(
        {%- if o.is_calo_type %}
            calo => {{ o.type | lower }}_bx_{{ o.bx }},
        {%- elif o.is_muon_type %}
            muon => {{ o.type | lower }}_bx_{{ o.bx }},
        {%- elif o.is_esums_type %}
            esums => {{ o.type | lower }}_bx_{{ o.bx }},
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
