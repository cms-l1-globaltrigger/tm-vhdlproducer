{%- block object_cuts_corr_muon %}
-- muon obj cuts
  {%- if o2.hasSlice %}
        muon_object_low => {{ o2.sliceLow }}, 
        muon_object_high => {{ o2.sliceHigh }}, 
  {%- endif %}        
  {%- if not o2.operator %}
        pt_ge_mode_muon => {{ o2.operator|vhdl_bool }}, 
  {%- endif %}        
        pt_threshold_muon => X"{{ o2.threshold|X04 }}",
  {%- if o2.etaNrCuts > 0 %}
        nr_eta_windows_muon => {{ o2.etaNrCuts }},
  {%- endif %}        
  {%- for j in range(0,(o2.etaNrCuts)) %}
    {%- if o2.etaNrCuts > j %}
        eta_w{{j+1}}_upper_limit_muon => X"{{ o2.etaUpperLimit[j]|X04 }}", 
        eta_w{{j+1}}_lower_limit_muon => X"{{ o2.etaLowerLimit[j]|X04 }}",
    {%- endif %}        
  {%- endfor %}
  {%- if o2.phiNrCuts > 0 %}
        phi_full_range_muon => {{ o2.phiFullRange }}, 
        phi_w1_upper_limit_muon => X"{{ o2.phiW1UpperLimit|X04 }}", 
        phi_w1_lower_limit_muon => X"{{ o2.phiW1LowerLimit|X04 }}",
  {%- endif %}        
  {%- if o2.phiNrCuts > 1 %}
        phi_w2_ignore_muon => {{ o2.phiW2Ignore }}, 
        phi_w2_upper_limit_muon => X"{{ o2.phiW2UpperLimit|X04 }}", 
        phi_w2_lower_limit_muon => X"{{ o2.phiW2LowerLimit|X04 }}",
  {%- endif %}        
  {%- if o2.hasCharge %}
        requested_charge_muon => "{{ o2.charge }}",
  {%- endif %}        
  {%- if o2.hasQuality %}
        qual_lut_muon => X"{{ o2.qualityLUT|X04 }}",
  {%- endif %}        
  {%- if o2.hasIsolation %}
        iso_lut_muon => X"{{ o2.isolationLUT|X01 }}",
  {%- endif %}        
  {%- if o2.hasUpt %}
        upt_cut_muon => {{ o2.hasUpt|vhdl_bool }}, 
        upt_upper_limit_muon => X"{{ o2.uptUpperLimit|X04 }}", 
        upt_lower_limit_muon => X"{{ o2.uptLowerLimit|X04 }}", 
  {%- endif %}        
  {%- if o2.hasImpactParameter %}
        ip_lut_muon => X"{{ o2.impactParameterLUT|X01 }}",
  {%- endif %}
{%- endblock object_cuts_corr_muon %}

