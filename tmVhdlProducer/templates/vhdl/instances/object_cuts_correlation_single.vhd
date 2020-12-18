{%- if o.is_muon_type %}
  {%- set obj = "muon" %}
{%- elif o.is_calo_type %}
  {%- set obj = "calo" %}
{%- endif %}        
  {%- if o.hasSlice %}
        {{ obj }}_object_low => {{ o.sliceLow }}, 
        {{ obj }}_object_high => {{ o.sliceHigh }}, 
  {%- endif %}        
  {%- if not o.operator %}
        pt_ge_mode_{{ obj }} => {{ o.operator|vhdl_bool }}, 
  {%- endif %}        
  {%- if o.is_calo_type %}
        obj_type_{{ obj }} => {{ o.type|upper }}_TYPE,
  {%- endif %}        
        pt_threshold_{{ obj }} => X"{{ o.threshold|X04 }}",
  {%- if o.etaNrCuts > 0 %}
        nr_eta_windows_{{ obj }} => {{ o.etaNrCuts }},
  {%- endif %}        
  {%- for j in range(0,(o.etaNrCuts)) %}
    {%- if o.etaNrCuts > j %}
        eta_w{{j+1}}_upper_limit_{{ obj }} => X"{{ o.etaUpperLimit[j]|X04 }}", 
        eta_w{{j+1}}_lower_limit_{{ obj }} => X"{{ o.etaLowerLimit[j]|X04 }}",
    {%- endif %}        
  {%- endfor %}
  {%- if o.phiNrCuts > 0 %}
        phi_full_range_{{ obj }} => {{ o.phiFullRange }}, 
        phi_w1_upper_limit_{{ obj }} => X"{{ o.phiW1UpperLimit|X04 }}", 
        phi_w1_lower_limit_{{ obj }} => X"{{ o.phiW1LowerLimit|X04 }}",
  {%- endif %}        
  {%- if o.phiNrCuts > 1 %}
        phi_w2_ignore_{{ obj }} => {{ o.phiW2Ignore }}, 
        phi_w2_upper_limit_{{ obj }} => X"{{ o.phiW2UpperLimit|X04 }}", 
        phi_w2_lower_limit_{{ obj }} => X"{{ o.phiW2LowerLimit|X04 }}",
  {%- endif %}        
  {%- if o.hasCharge %}
        requested_charge_{{ obj }} => "{{ o.charge }}",
  {%- endif %}        
  {%- if o.hasQuality %}
        qual_lut_{{ obj }} => X"{{ o.qualityLUT|X04 }}",
  {%- endif %}        
  {%- if o.hasIsolation %}
        iso_lut_{{ obj }} => X"{{ o.isolationLUT|X01 }}",
  {%- endif %}        
  {%- if o.hasUpt %}
        upt_cut_{{ obj }} => {{ o.hasUpt|vhdl_bool }}, 
        upt_upper_limit_{{ obj }} => X"{{ o.uptUpperLimit|X04 }}", 
        upt_lower_limit_{{ obj }} => X"{{ o.uptLowerLimit|X04 }}", 
  {%- endif %}        
  {%- if o.hasImpactParameter %}
        ip_lut_{{ obj }} => X"{{ o.impactParameterLUT|X01 }}",
  {%- endif %}

