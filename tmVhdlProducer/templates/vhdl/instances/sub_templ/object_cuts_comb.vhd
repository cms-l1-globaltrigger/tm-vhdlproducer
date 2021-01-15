{%- block object_cuts_comb %}
  {%- for i in range(0,condition.nr_objects) %}
    {%- if condition.nr_objects > i and condition.objects[i].hasSlice  %}
        slice_{{i+1}}_low_obj1 => {{ condition.objects[i].sliceLow }}, 
        slice_{{i+1}}_high_obj1 => {{ condition.objects[i].sliceHigh }}, 
    {%- endif %}        
  {%- endfor %}
-- object cuts
  {%- if not o1.operator %}
        pt_ge_mode_obj1 => {{ o1.operator|vhdl_bool }}, 
  {%- endif %}        
        pt_thresholds_obj1 => (X"{{ o1.threshold|X04 }}", X"{{ o2.threshold|X04 }}", X"{{ o3.threshold|X04 }}", X"{{ o4.threshold|X04 }}"),
  {%- set max_eta_cuts = [condition.objects[0].etaNrCuts, condition.objects[1].etaNrCuts, condition.objects[2].etaNrCuts, condition.objects[3].etaNrCuts]|max %}  
  {%- if o1.etaNrCuts > 0 or o2.etaNrCuts > 0 or o3.etaNrCuts > 0 or o4.etaNrCuts > 0 %}
        nr_eta_windows_obj1 => ({{ o1.etaNrCuts }}, {{ o2.etaNrCuts }}, {{ o3.etaNrCuts }}, {{ o4.etaNrCuts }}),
  {%- endif %}        
  {%- for i in range(0,max_eta_cuts) %}
    {%- if o1.etaNrCuts > i or o2.etaNrCuts > i or o3.etaNrCuts > i or o4.etaNrCuts > i %}
        eta_w{{i+1}}_upper_limits_obj1 => (X"{{ o1.etaUpperLimit[i]|X04 }}", X"{{ o2.etaUpperLimit[i]|X04 }}", X"{{ o3.etaUpperLimit[i]|X04}}", X"{{ o4.etaUpperLimit[i]|X04 }}"), 
        eta_w{{i+1}}_lower_limits_obj1 => (X"{{ o1.etaLowerLimit[i]|X04 }}", X"{{ o2.etaLowerLimit[i]|X04 }}", X"{{ o3.etaLowerLimit[i]|X04 }}", X"{{ o4.etaLowerLimit[i]|X04 }}"),
    {%- endif %}        
  {%- endfor %}
  {%- set max_phi_cuts = [condition.objects[0].phiNrCuts, condition.objects[1].phiNrCuts, condition.objects[2].phiNrCuts, condition.objects[3].phiNrCuts]|max %}  
  {%- if o1.phiNrCuts > 0 or o2.phiNrCuts > 0 or o3.phiNrCuts > 0 or o4.phiNrCuts > 0 %}
        nr_phi_windows_obj1 => ({{ o1.phiNrCuts }}, {{ o2.phiNrCuts }}, {{ o3.phiNrCuts }}, {{ o4.phiNrCuts }}),
  {%- endif %}        
  {%- for i in range(0,max_phi_cuts) %}
    {%- if o1.phiNrCuts > i or o2.phiNrCuts > i or o3.phiNrCuts > i or o4.phiNrCuts > i %}
        phi_w{{i+1}}_upper_limits_obj1 => (X"{{ o1.phiUpperLimit[i]|X04 }}", X"{{ o2.phiUpperLimit[i]|X04 }}", X"{{ o3.phiUpperLimit[i]|X04}}", X"{{ o4.phiUpperLimit[i]|X04 }}"), 
        phi_w{{i+1}}_lower_limits_obj1 => (X"{{ o1.phiLowerLimit[i]|X04 }}", X"{{ o2.phiLowerLimit[i]|X04 }}", X"{{ o3.phiLowerLimit[i]|X04 }}", X"{{ o4.phiLowerLimit[i]|X04 }}"),
    {%- endif %}        
  {%- endfor %}
  {%- if (o1.hasIsolation) or (o2.hasIsolation) or (o3.hasIsolation) or (o4.hasIsolation) %}
        iso_luts_obj1 => (X"{{ o1.isolationLUT|X01 }}", X"{{ o2.isolationLUT|X01 }}", X"{{ o3.isolationLUT|X01 }}", X"{{ o4.isolationLUT|X01 }}"),
  {%- endif %}        
  {%- if (o1.hasCharge) or (o2.hasCharge) or (o3.hasCharge) or (o4.hasCharge) %}
        requested_charges_obj1 => ("{{ o1.charge }}", "{{ o2.charge }}", "{{ o3.charge }}", "{{ o4.charge }}"), 
  {%- endif %}        
  {%- if (o1.hasQuality) or (o2.hasQuality) or (o3.hasQuality) or (o4.hasQuality) %}
        qual_luts_obj1 => (X"{{ o1.qualityLUT|X04 }}", X"{{ o2.qualityLUT|X04 }}", X"{{ o3.qualityLUT|X04 }}", X"{{ o4.qualityLUT|X04 }}"), 
  {%- endif %}        
  {%- if (o1.hasUpt) or (o2.hasUpt) or (o3.hasUpt) or (o4.hasUpt) %}
        upt_cuts_obj1 => ({{ o1.hasUpt|vhdl_bool }}, {{ o2.hasUpt|vhdl_bool }}, {{ o3.hasUpt|vhdl_bool }}, {{ o4.hasUpt|vhdl_bool }}), 
        upt_upper_limits_obj1 => (X"{{ o1.uptUpperLimit|X04 }}", X"{{ o2.uptUpperLimit|X04 }}", X"{{ o3.uptUpperLimit|X04 }}", X"{{ o4.uptUpperLimit|X04 }}"),
        upt_lower_limits_obj1 => (X"{{ o1.uptLowerLimit|X04 }}", X"{{ o2.uptLowerLimit|X04 }}", X"{{ o3.uptLowerLimit|X04 }}", X"{{ o4.uptLowerLimit|X04 }}"), 
  {%- endif %}        
  {%- if (o1.hasImpactParameter) or (o2.hasImpactParameter) or (o3.hasImpactParameter) or (o4.hasImpactParameter) %}
        ip_luts_obj1 => (X"{{ o1.impactParameterLUT|X01 }}", X"{{ o2.impactParameterLUT|X01 }}", X"{{ o3.impactParameterLUT|X01 }}", X"{{ o4.impactParameterLUT|X01 }}"), 
  {%- endif %}        
{%- endblock object_cuts_comb %}
