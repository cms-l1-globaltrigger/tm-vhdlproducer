{%- block object_cuts_calos %}
  {%- if o.hasSlice %}
        calo{{i+1}}_object_low => {{ o.sliceLow }}, 
        calo{{i+1}}_object_high => {{ o.sliceHigh }}, 
  {%- endif %}        
  {%- if not o.operator %}
        pt_ge_mode_calo{{i+1}} => {{ o.operator|vhdl_bool }}, 
  {%- endif %}        
        obj_type_calo{{i+1}} => {{ o.type|upper }}_TYPE,
        pt_threshold_calo{{i+1}} => X"{{ o.threshold|X04 }}",
  {%- if o.etaNrCuts > 0 %}
        nr_eta_windows_calo{{i+1}} => {{ o.etaNrCuts }},
  {%- endif %}        
  {%- for j in range(0,(o.etaNrCuts)) %}
    {%- if o.etaNrCuts > j %}
        eta_w{{j+1}}_upper_limit_calo{{i+1}} => X"{{ o.etaUpperLimit[j]|X04 }}", 
        eta_w{{j+1}}_lower_limit_calo{{i+1}} => X"{{ o.etaLowerLimit[j]|X04 }}",
    {%- endif %}        
  {%- endfor %}
  {%- if o.phiNrCuts > 0 %}
        phi_full_range_calo{{i+1}} => {{ o.phiFullRange }}, 
        phi_w1_upper_limit_calo{{i+1}} => X"{{ o.phiW1UpperLimit|X04 }}", 
        phi_w1_lower_limit_calo{{i+1}} => X"{{ o.phiW1LowerLimit|X04 }}",
  {%- endif %}        
  {%- if o.phiNrCuts > 1 %}
        phi_w2_ignore_calo{{i+1}} => {{ o.phiW2Ignore }}, 
        phi_w2_upper_limit_calo{{i+1}} => X"{{ o.phiW2UpperLimit|X04 }}", 
        phi_w2_lower_limit_calo{{i+1}} => X"{{ o.phiW2LowerLimit|X04 }}",
  {%- endif %}        
  {%- if o.hasIsolation %}
        iso_lut_calo{{i+1}} => X"{{ o.isolationLUT|X01 }}",
  {%- endif %}
{%- endblock object_cuts_calos %}

