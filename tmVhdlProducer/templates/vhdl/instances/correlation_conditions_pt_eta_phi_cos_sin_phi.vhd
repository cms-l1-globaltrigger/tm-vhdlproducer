{%- block object_loop scoped %}
  {%- for o in module.correlationObjects %}
    {%- if o.is_calo_type %}
    {{ o.type | lower }}_bx_{{ o.bx }}_data_l: for i in 0 to NR_{{ o.type | upper }}_OBJECTS-1 generate
        {{ o.type | lower }}_bx_{{ o.bx }}_pt_vector(i)({{ o.type | upper }}_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR({{ o.type | upper }}_PT_LUT(CONV_INTEGER({{ o.type | lower }}_bx_{{ o.bx }}(i)(D_S_I_{{ o.type | upper }}_V2.et_high downto D_S_I_{{ o.type | upper }}_V2.et_low))), {{ o.type | upper }}_PT_VECTOR_WIDTH);
        {{ o.type | lower }}_bx_{{ o.bx }}_eta_integer(i) <= CONV_INTEGER(signed({{ o.type | lower }}_bx_{{ o.bx }}(i)(D_S_I_{{ o.type | upper }}_V2.eta_high downto D_S_I_{{ o.type | upper }}_V2.eta_low)));
        {{ o.type | lower }}_bx_{{ o.bx }}_phi_integer(i) <= CONV_INTEGER({{ o.type | lower }}_bx_{{ o.bx }}(i)(D_S_I_{{ o.type | upper }}_V2.phi_high downto D_S_I_{{ o.type | upper }}_V2.phi_low));
        {{ o.type | lower }}_bx_{{ o.bx }}_cos_phi(i) <= CALO_COS_PHI_LUT(CONV_INTEGER({{ o.type | lower }}_bx_{{ o.bx }}(i)(D_S_I_{{ o.type | upper }}_V2.phi_high downto D_S_I_{{ o.type | upper }}_V2.phi_low)));
        {{ o.type | lower }}_bx_{{ o.bx }}_sin_phi(i) <= CALO_SIN_PHI_LUT(CONV_INTEGER({{ o.type | lower }}_bx_{{ o.bx }}(i)(D_S_I_{{ o.type | upper }}_V2.phi_high downto D_S_I_{{ o.type | upper }}_V2.phi_low)));
        {{ o.type | lower }}_bx_{{ o.bx }}_conv_cos_phi(i) <= MUON_COS_PHI_LUT({{ o.type | lower }}_bx_{{ o.bx }}_phi_conv_2_muon_phi_integer(i));
        {{ o.type | lower }}_bx_{{ o.bx }}_conv_sin_phi(i) <= MUON_SIN_PHI_LUT({{ o.type | lower }}_bx_{{ o.bx }}_phi_conv_2_muon_phi_integer(i));
    end generate {{ o.type | lower }}_bx_{{ o.bx }}_data_l;
    {%- elif o.is_muon_type %}
    {{ o.type | lower }}_bx_{{ o.bx }}_data_l: for i in 0 to NR_{{ o.type | upper }}_OBJECTS-1 generate
        {{ o.type | lower }}_bx_{{ o.bx }}_pt_vector(i)({{ o.type | upper }}_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR({{ o.type | upper }}_PT_LUT(CONV_INTEGER({{ o.type | lower }}_bx_{{ o.bx }}(i)(D_S_I_{{ o.type | upper }}_V2.pt_high downto D_S_I_{{ o.type | upper }}_V2.pt_low))), {{ o.type | upper }}_PT_VECTOR_WIDTH);
        {{ o.type | lower }}_bx_{{ o.bx }}_upt_vector(i)({{ o.type | upper }}_UPT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR({{ o.type | upper }}_UPT_LUT(CONV_INTEGER({{ o.type | lower }}_bx_{{ o.bx }}(i)(D_S_I_{{ o.type | upper }}_V2.upt_high downto D_S_I_{{ o.type | upper }}_V2.upt_low))), {{ o.type | upper }}_UPT_VECTOR_WIDTH);
        {{ o.type | lower }}_bx_{{ o.bx }}_eta_integer(i) <= CONV_INTEGER(signed({{ o.type | lower }}_bx_{{ o.bx }}(i)(D_S_I_{{ o.type | upper }}_V2.eta_high downto D_S_I_{{ o.type | upper }}_V2.eta_low)));
        {{ o.type | lower }}_bx_{{ o.bx }}_phi_integer(i) <= CONV_INTEGER({{ o.type | lower }}_bx_{{ o.bx }}(i)(D_S_I_{{ o.type | upper }}_V2.phi_high downto D_S_I_{{ o.type | upper }}_V2.phi_low));
        {{ o.type | lower }}_bx_{{ o.bx }}_cos_phi(i) <= MUON_COS_PHI_LUT(CONV_INTEGER({{ o.type | lower }}_bx_{{ o.bx }}(i)(D_S_I_{{ o.type | upper }}_V2.phi_high downto D_S_I_{{ o.type | upper }}_V2.phi_low)));
        {{ o.type | lower }}_bx_{{ o.bx }}_sin_phi(i) <= MUON_SIN_PHI_LUT(CONV_INTEGER({{ o.type | lower }}_bx_{{ o.bx }}(i)(D_S_I_{{ o.type | upper }}_V2.phi_high downto D_S_I_{{ o.type | upper }}_V2.phi_low)));
    end generate {{ o.type | lower }}_bx_{{ o.bx }}_data_l;
    {%- elif o.is_esums_type %}
    {{ o.type | lower }}_bx_{{ o.bx }}_data_l: for i in 0 to NR_{{ o.type | upper }}_OBJECTS-1 generate
        {{ o.type | lower }}_bx_{{ o.bx }}_pt_vector(0)({{ o.type | upper }}_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR({{ o.type | upper }}_PT_LUT(CONV_INTEGER({{ o.type | lower }}_bx_{{ o.bx }}(D_S_I_{{ o.type | upper }}_V2.et_high downto D_S_I_{{ o.type | upper }}_V2.et_low))), {{ o.type | upper }}_PT_VECTOR_WIDTH);
        {{ o.type | lower }}_bx_{{ o.bx }}_phi_integer(0) <= CONV_INTEGER({{ o.type | lower }}_bx_{{ o.bx }}(D_S_I_{{ o.type | upper }}_V2.phi_high downto D_S_I_{{ o.type | upper }}_V2.phi_low));
        {{ o.type | lower }}_bx_{{ o.bx }}_cos_phi(0) <= CALO_COS_PHI_LUT(CONV_INTEGER({{ o.type | lower }}_bx_{{ o.bx }}(D_S_I_{{ o.type | upper }}_V2.phi_high downto D_S_I_{{ o.type | upper }}_V2.phi_low)));
        {{ o.type | lower }}_bx_{{ o.bx }}_sin_phi(0) <= CALO_SIN_PHI_LUT(CONV_INTEGER({{ o.type | lower }}_bx_{{ o.bx }}(D_S_I_{{ o.type | upper }}_V2.phi_high downto D_S_I_{{ o.type | upper }}_V2.phi_low)));
        {{ o.type | lower }}_bx_{{ o.bx }}_conv_cos_phi(0) <= MUON_COS_PHI_LUT({{ o.type | lower }}_bx_{{ o.bx }}_phi_conv_2_muon_phi_integer(0));
        {{ o.type | lower }}_bx_{{ o.bx }}_conv_sin_phi(0) <= MUON_SIN_PHI_LUT({{ o.type | lower }}_bx_{{ o.bx }}_phi_conv_2_muon_phi_integer(0));
    end generate {{ o.type | lower }}_bx_{{ o.bx }}_data_l;
    {%- endif %}
  {%- endfor %}
{%- endblock object_loop %}
{# eof #}
