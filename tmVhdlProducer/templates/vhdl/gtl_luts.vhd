{%- macro dump_lut(ll, v_p_r, lut) -%}
  {% for i in range(0,ll,v_p_r) -%}
    {% if i <= ll-v_p_r -%}
      {% for j in range(0,v_p_r) -%}
        {%- if i+j == ll-1 -%}
{{lut[i+j]}}
        {%- else -%}
{{lut[i+j]}}{{", "}}
        {%- endif -%}
      {%- endfor %}
    {%- endif %}
  {% endfor -%}
{%- endmacro -%}

-- eg and tau pt LUTs
type eg_pt_lut_array is array (0 to 2**(EG_ET_HIGH-EG_ET_LOW+1)-1) of natural range {{eg_pt_min}} to {{eg_pt_max}};

constant EG_PT_LUT : eg_pt_lut_array := (
{{ dump_lut(eg_pt_ll, v_p_r, eg_pt_lut)|trim }}
);

-- jet pt LUTs
type jet_pt_lut_array is array (0 to 2**(JET_ET_HIGH-JET_ET_LOW+1)-1) of natural range {{jet_pt_min}} to {{jet_pt_max}};

constant JET_PT_LUT : jet_pt_lut_array := (
{{ dump_lut(jet_pt_ll, v_p_r, jet_pt_lut)|trim }}
);

-- esums pt LUTs
type etm_pt_lut_array is array (0 to 2**(ETM_ET_HIGH-ETM_ET_LOW+1)-1) of natural range {{etm_pt_min}} to {{etm_pt_max}};

constant ETM_PT_LUT : etm_pt_lut_array := (
{{ dump_lut(etm_pt_ll, v_p_r, etm_pt_lut)|trim }}
);

-- calo-calo differences LUTs
type calo_calo_diff_eta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of natural range {{cc_deta_min}} to {{cc_deta_max}};

constant CALO_CALO_DIFF_ETA_LUT : calo_calo_diff_eta_lut_array := (
{{ dump_lut(cc_deta_ll, v_p_r, cc_deta_lut)|trim }}
);

type calo_calo_diff_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of natural range {{cc_dphi_min}} to {{cc_dphi_max}};

constant CALO_CALO_DIFF_PHI_LUT : calo_calo_diff_phi_lut_array := (
{{ dump_lut(cc_dphi_ll, v_p_r, cc_dphi_lut)|trim }}
);

-- muon-muon differences LUTs
type muon_muon_diff_eta_lut_array is array (0 to 2**(MUON_ETA_HIGH-MUON_ETA_LOW+1)-1) of natural range {{mm_deta_min}} to {{mm_deta_max}};

constant MU_MU_DIFF_ETA_LUT : muon_muon_diff_eta_lut_array := (
{{ dump_lut(mm_deta_ll, v_p_r, mm_deta_lut)|trim }}
);

type muon_muon_diff_phi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of natural range {{mm_dphi_min}} to {{mm_dphi_max}};

constant MU_MU_DIFF_PHI_LUT : muon_muon_diff_phi_lut_array := (
{{ dump_lut(mm_dphi_ll, v_p_r, mm_dphi_lut)|trim }}
);
