{%- block correlation_conditions_eta_phi_conversion_loop %}
  {%- for o in module.conversionObjects %}
    {%- if o.is_calo_type %}
    {{ o.type | lower }}_conv_2_muon_bx_{{ o.bx }}_l: for i in 0 to NR_{{ o.type | upper }}_OBJECTS-1 generate
        {{ o.type | lower }}_eta_conv_2_muon_eta_integer_bx_{{ o.bx }}(i) <= {{ o.type | upper }}_ETA_CONV_2_MUON_ETA_LUT(CONV_INTEGER({{ o.type | lower }}_bx_{{ o.bx }}(i)(D_S_I_{{ o.type | upper }}_V2.eta_high downto D_S_I_{{ o.type | upper }}_V2.eta_low)));
        {{ o.type | lower }}_phi_conv_2_muon_phi_integer_bx_{{ o.bx }}(i) <= {{ o.type | upper }}_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER({{ o.type | lower }}_bx_{{ o.bx }}(i)(D_S_I_{{ o.type | upper }}_V2.phi_high downto D_S_I_{{ o.type | upper }}_V2.phi_low)));
    end generate {{ o.type | lower }}_conv_2_muon_bx_{{ o.bx }}_l;
    {%- elif o.is_esums_type %}
    {{ o.type | lower }}_phi_conv_2_muon_phi_integer_bx_{{ o.bx }}(0) <= {{ o.type | upper }}_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER({{ o.type | lower }}_bx_{{ o.bx }}(D_S_I_{{ o.type | upper }}_V2.phi_high downto D_S_I_{{ o.type | upper }}_V2.phi_low)));
    {%- endif %}
  {%- endfor %}
{%- endblock correlation_conditions_eta_phi_conversion_loop %}
{# eof #}
