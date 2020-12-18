{%- block object_cuts_corr_objects %}
  {%- if o.hasSlice %}
        slice_low_obj{{i+1}} => {{ o.sliceLow }}, 
        slice_high_obj{{i+1}} => {{ o.sliceHigh }}, 
  {%- endif %}        
  {%- if not o.operator %}
        pt_ge_mode_obj{{i+1}} => {{ o.operator|vhdl_bool }}, 
  {%- endif %}        
        pt_threshold_obj{{i+1}} => X"{{ o.threshold|X04 }}",
  {%- if o.etaNrCuts > 0 %}
        nr_eta_windows_obj{{i+1}} => {{ o.etaNrCuts }},
  {%- endif %}        
  {%- for j in range(0,(o.etaNrCuts)) %}
    {%- if o.etaNrCuts > j %}
        eta_w{{j+1}}_upper_limit_obj{{i+1}} => X"{{ o.etaUpperLimit[j]|X04 }}", 
        eta_w{{j+1}}_lower_limit_obj{{i+1}} => X"{{ o.etaLowerLimit[j]|X04 }}",
    {%- endif %}        
  {%- endfor %}
  {%- if o.phiNrCuts > 0 %}
        nr_phi_windows_obj{{i+1}} => {{ o.phiNrCuts }}, 
        phi_w1_upper_limit_obj{{i+1}} => X"{{ o.phiW1UpperLimit|X04 }}", 
        phi_w1_lower_limit_obj{{i+1}} => X"{{ o.phiW1LowerLimit|X04 }}",
  {%- endif %}        
  {%- if o.phiNrCuts > 1 %}
        phi_w2_upper_limit_obj{{i+1}} => X"{{ o.phiW2UpperLimit|X04 }}", 
        phi_w2_lower_limit_obj{{i+1}} => X"{{ o.phiW2LowerLimit|X04 }}",
  {%- endif %}        
  {%- if o.hasIsolation %}
        iso_lut_obj{{i+1}} => X"{{ o.isolationLUT|X01 }}",
  {%- endif %}        
  {%- if o.hasCharge %}
        requested_charge_obj{{i+1}} => "{{ o.charge }}",                      
  {%- endif %}        
  {%- if o.hasQuality %}
        qual_lut_obj{{i+1}} => X"{{ o.qualityLUT|X04 }}",
  {%- endif %}        
  {%- if o.hasUpt %}
        upt_cut_obj{{i+1}} => {{ o.hasUpt|vhdl_bool }}, 
        upt_upper_limit_obj{{i+1}} => X"{{ o.uptUpperLimit|X04 }}", 
        upt_lower_limit_obj{{i+1}} => X"{{ o.uptLowerLimit|X04 }}", 
  {%- endif %}        
  {%- if o.hasImpactParameter %}
        ip_lut_obj{{i+1}} => X"{{ o.impactParameterLUT|X01 }}",
  {%- endif %}
{%- endblock object_cuts_corr_objects %}
{# eof #}
