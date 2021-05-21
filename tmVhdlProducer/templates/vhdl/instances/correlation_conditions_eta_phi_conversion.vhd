{%- for o in module.conversionObjects %}
  {%- if o.is_calo_type %}
conv_eta_phi_{{ o.type | lower }}_bx_{{ o.bx }}_i: entity work.conv_eta_phi
    generic map(
        nr_obj => NR_{{ o.type | upper }}_OBJECTS,
        type_obj => {{ o.type | upper }}_TYPE
    )
    port map(
        calo => bx_data.{{ o.type | lower }}({{ o.bx_arr }}),
        eta_conv => {{ o.type | lower }}_bx_{{ o.bx }}_eta_conv_2_muon_eta_integer,
        phi_conv => {{ o.type | lower }}_bx_{{ o.bx }}_phi_conv_2_muon_phi_integer
    );
--
  {%- elif o.is_esums_type %}
conv_eta_phi_{{ o.type | lower }}_bx_{{ o.bx }}_i: entity work.conv_eta_phi
    generic map(
        nr_obj => NR_{{ o.type | upper }}_OBJECTS,
        type_obj => {{ o.type | upper }}_TYPE
    )
    port map(
        esums => bx_data.{{ o.type | lower }}({{ o.bx_arr }}),
        phi_conv => {{ o.type | lower }}_bx_{{ o.bx }}_phi_conv_2_muon_phi_integer
    );
--
  {%- endif %}
{%- endfor %}
