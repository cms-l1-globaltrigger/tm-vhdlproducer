{%- block object_cuts_corr_calo %}
-- calo obj cuts
  {%- if o.hasSlice %}
        calo_object_low => {{ o.sliceLow }}, 
        calo_object_high => {{ o.sliceHigh }}, 
  {%- endif %}        
  {%- if not o.operator %}
        pt_ge_mode_calo => {{ o.operator|vhdl_bool }}, 
  {%- endif %}        
        obj_type_calo => {{ o.type|upper }}_TYPE,
        pt_threshold_calo => X"{{ o.threshold|X04 }}",
  {%- if o.etaNrCuts > 0 %}
        nr_eta_windows_calo => {{ o.etaNrCuts }},
  {%- endif %}        
  {%- for j in range(0,(o.etaNrCuts)) %}
    {%- if o.etaNrCuts > j %}
        eta_w{{j+1}}_upper_limit_calo => X"{{ o.etaUpperLimit[j]|X04 }}", 
        eta_w{{j+1}}_lower_limit_calo => X"{{ o.etaLowerLimit[j]|X04 }}",
    {%- endif %}        
  {%- endfor %}
  {%- if o.phiNrCuts > 0 %}
        phi_full_range_calo => {{ o.phiFullRange }}, 
        phi_w1_upper_limit_calo => X"{{ o.phiW1UpperLimit|X04 }}", 
        phi_w1_lower_limit_calo => X"{{ o.phiW1LowerLimit|X04 }}",
  {%- endif %}        
  {%- if o.phiNrCuts > 1 %}
        phi_w2_ignore_calo => {{ o.phiW2Ignore }}, 
        phi_w2_upper_limit_calo => X"{{ o.phiW2UpperLimit|X04 }}", 
        phi_w2_lower_limit_calo => X"{{ o.phiW2LowerLimit|X04 }}",
  {%- endif %}        
  {%- if o.hasIsolation %}
        iso_lut_calo => X"{{ o.isolationLUT|X01 }}",
  {%- endif %}        
{%- endblock object_cuts_corr_calo %}

