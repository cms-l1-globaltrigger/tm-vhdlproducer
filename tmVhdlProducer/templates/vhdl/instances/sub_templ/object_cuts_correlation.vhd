{%- if condition.objects[1].is_esums_type %}
  {%- set nr_o = 1 %}    
{%- else %}
  {%- set nr_o = condition.nr_objects %}    
{%- endif %} 
{%- for i in range(0,nr_o) %}
  {%- set o = condition.objects[i] %}
  {%- if o.hasSlice %}
        obj{{i+1}}_object_low => {{ o.sliceLow }}, 
        obj{{i+1}}_object_high => {{ o.sliceHigh }}, 
  {%- endif %}        
  {%- if not o.operator %}
        pt_ge_mode_obj{{i+1}} => {{ o.operator|vhdl_bool }}, 
  {%- endif %}        
  {%- if o.is_calo_type %}
        obj_type_obj{{i+1}} => {{ o.type|upper }}_TYPE,
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
        phi_full_range_obj{{i+1}} => {{ o.phiFullRange }}, 
        phi_w1_upper_limit_obj{{i+1}} => X"{{ o.phiW1UpperLimit|X04 }}", 
        phi_w1_lower_limit_obj{{i+1}} => X"{{ o.phiW1LowerLimit|X04 }}",
  {%- endif %}        
  {%- if o.phiNrCuts > 1 %}
        phi_w2_ignore_obj{{i+1}} => {{ o.phiW2Ignore }}, 
        phi_w2_upper_limit_obj{{i+1}} => X"{{ o.phiW2UpperLimit|X04 }}", 
        phi_w2_lower_limit_obj{{i+1}} => X"{{ o.phiW2LowerLimit|X04 }}",
  {%- endif %}        
  {%- if o.hasCharge %}
        requested_charge_obj{{i+1}} => "{{ o.charge }}",
  {%- endif %}        
  {%- if o.hasQuality %}
        qual_lut_obj{{i+1}} => X"{{ o.qualityLUT|X04 }}",
  {%- endif %}        
  {%- if o.hasIsolation %}
        iso_lut_obj{{i+1}} => X"{{ o.isolationLUT|X01 }}",
  {%- endif %}        
  {%- if o.hasUpt %}
        upt_cut_obj{{i+1}} => {{ o.hasUpt|vhdl_bool }}, 
        upt_upper_limit_obj{{i+1}} => X"{{ o.uptUpperLimit|X04 }}", 
        upt_lower_limit_obj{{i+1}} => X"{{ o.uptLowerLimit|X04 }}", 
  {%- endif %}        
  {%- if o.hasImpactParameter %}
        ip_lut_obj{{i+1}} => X"{{ o.impactParameterLUT|X01 }}",
  {%- endif %}
{%- endfor %}
