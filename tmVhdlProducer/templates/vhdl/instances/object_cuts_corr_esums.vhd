{%- block object_cuts_corr_esums %}
-- esums obj cuts
  {%- if not o2.operator %}
        et_ge_mode_esums => {{ o2.operator|vhdl_bool }}, 
  {%- endif %}        
        obj_type_esums => {{ o2.type|upper }}_TYPE,
        et_threshold_esums => X"{{ o2.threshold|X04 }}",
  {%- if o2.phiNrCuts > 0 %}
        phi_full_range_esums => {{ o2.phiFullRange }}, 
        phi_w1_upper_limit_esums => X"{{ o2.phiW1UpperLimit|X04 }}", 
        phi_w1_lower_limit_esums => X"{{ o2.phiW1LowerLimit|X04 }}",
  {%- endif %}        
  {%- if o2.phiNrCuts > 1 %}
        phi_w2_ignore_esums => {{ o2.phiW2Ignore }}, 
        phi_w2_upper_limit_esums => X"{{ o2.phiW2UpperLimit|X04 }}", 
        phi_w2_lower_limit_esums => X"{{ o2.phiW2LowerLimit|X04 }}",
  {%- endif %}        
{%- endblock object_cuts_corr_esums %}

