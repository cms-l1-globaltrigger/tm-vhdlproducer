        
        sel_esums => true,
        obj_type_esums => {{ o2.type|upper }}_TYPE,
  {%- if not o2.operator %}
        et_ge_mode_esums => {{ o2.operator|vhdl_bool }}, 
  {%- endif %}        
        et_threshold_esums => X"{{ o2.threshold|X04 }}",
  {%- if o2.phiNrCuts > 0 %}
        nr_phi_windows_esums => {{ o2.phiNrCuts }}, 
        phi_w1_upper_limit_esums => X"{{ o2.phiW1UpperLimit|X04 }}", 
        phi_w1_lower_limit_esums => X"{{ o2.phiW1LowerLimit|X04 }}",
  {%- endif %}        
  {%- if o2.phiNrCuts > 1 %}
        phi_w2_upper_limit_esums => X"{{ o2.phiW2UpperLimit|X04 }}", 
        phi_w2_lower_limit_esums => X"{{ o2.phiW2LowerLimit|X04 }}",
  {%- endif %}        
