{%- for o in module.conversionObjects %}
  {%- if o.is_calo_type %}
{{ o.type | lower }}_bx_{{ o.bx }}_conv_eta_phi_i: entity work.conv_eta_phi
    generic map(
        nr_obj => NR_{{ o.type | upper }}_OBJECTS,
        type_obj => {{ o.type | upper }}_TYPE
    )
    port map(
        calo => {{ o.type | lower }}_bx_{{ o.bx }},
        eta_conv => {{ o.type | lower }}_bx_{{ o.bx }}_eta_conv_2_muon_eta_integer,
        phi_conv => {{ o.type | lower }}_bx_{{ o.bx }}_phi_conv_2_muon_phi_integer
    );
--
  {%- elif o.is_esums_type %}
{{ o.type | lower }}_bx_{{ o.bx }}_conv_eta_phi_i: entity work.conv_eta_phi
    generic map(
        nr_obj => NR_{{ o.type | upper }}_OBJECTS,
        type_obj => {{ o.type | upper }}_TYPE
    )
    port map(
        esums => {{ o.type | lower }}_bx_{{ o.bx }},
        phi_conv => {{ o.type | lower }}_bx_{{ o.bx }}_phi_conv_2_muon_phi_integer
    );
--
  {%- endif %}
{%- endfor %}
