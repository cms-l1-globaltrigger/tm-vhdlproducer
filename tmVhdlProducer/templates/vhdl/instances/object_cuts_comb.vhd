{%- block object_cuts_comb %}
  {%- for i in range(0,condition.nr_objects) %}
    {%- if condition.nr_objects > i and condition.objects[i].hasSlice  %}
        object_slice_{{i+1}}_low => {{ condition.objects[i].sliceLow }}, 
        object_slice_{{i+1}}_high => {{ condition.objects[i].sliceHigh }}, 
    {%- endif %}        
  {%- endfor %}
-- object cuts
  {%- if not condition.objects[0].operator %}
        pt_ge_mode => {{ condition.objects[0].operator|vhdl_bool }}, 
  {%- endif %}        
  {%- if condition.objects[0].is_calo_type %}        
        obj_type => {{ condition.objects[0].type }}_TYPE,
  {%- endif %}
        pt_thresholds => (X"{{ condition.objects[0].threshold|X04 }}", X"{{ condition.objects[1].threshold|X04 }}", X"{{ condition.objects[2].threshold|X04 }}", X"{{ condition.objects[3].threshold|X04 }}"),
  {%- set max_eta_cuts = [condition.objects[0].etaNrCuts, condition.objects[1].etaNrCuts, condition.objects[2].etaNrCuts, condition.objects[3].etaNrCuts]|max %}  
  {%- if o1.etaNrCuts > 0 or o2.etaNrCuts > 0 or o3.etaNrCuts > 0 or o4.etaNrCuts > 0 %}
        nr_eta_windows => ({{ o1.etaNrCuts }}, {{ o2.etaNrCuts }}, {{ o3.etaNrCuts }}, {{ o4.etaNrCuts }}),
  {%- endif %}        
  {%- for i in range(0,max_eta_cuts) %}
    {%- if o1.etaNrCuts > i or o2.etaNrCuts > i or o3.etaNrCuts > i or o4.etaNrCuts > i %}
        eta_w{{i+1}}_upper_limits => (X"{{ o1.etaUpperLimit[i]|X04 }}", X"{{ o2.etaUpperLimit[i]|X04 }}", X"{{ o3.etaUpperLimit[i]|X04}}", X"{{ o4.etaUpperLimit[i]|X04 }}"), 
        eta_w{{i+1}}_lower_limits => (X"{{ o1.etaLowerLimit[i]|X04 }}", X"{{ o2.etaLowerLimit[i]|X04 }}", X"{{ o3.etaLowerLimit[i]|X04 }}", X"{{ o4.etaLowerLimit[i]|X04 }}"),
    {%- endif %}        
  {%- endfor %}
  {%- if o1.phiNrCuts > 0 or o2.phiNrCuts > 0 or o3.phiNrCuts > 0 or o4.phiNrCuts > 0 %}
        phi_full_range => ({{ o1.phiFullRange }}, {{ o2.phiFullRange }}, {{ o3.phiFullRange }}, {{ o4.phiFullRange }}), 
        phi_w1_upper_limits => (X"{{ o1.phiW1UpperLimit|X04 }}", X"{{ o2.phiW1UpperLimit|X04 }}", X"{{ o3.phiW1UpperLimit|X04 }}", X"{{ o4.phiW1UpperLimit|X04 }}"), 
        phi_w1_lower_limits => (X"{{ o1.phiW1LowerLimit|X04 }}", X"{{ o2.phiW1LowerLimit|X04 }}", X"{{ o3.phiW1LowerLimit|X04 }}", X"{{ o4.phiW1LowerLimit|X04 }}"),
  {%- endif %}        
  {%- if o1.phiNrCuts > 1 or o2.phiNrCuts > 1 or o3.phiNrCuts > 1 or o4.phiNrCuts > 1 %}
        phi_w2_ignore => ({{ o1.phiW2Ignore }}, {{ o2.phiW2Ignore }}, {{ o3.phiW2Ignore }}, {{ o4.phiW2Ignore }}),
        phi_w2_upper_limits => (X"{{ o1.phiW2UpperLimit|X04 }}", X"{{ o2.phiW2UpperLimit|X04 }}", X"{{ o3.phiW2UpperLimit|X04 }}", X"{{ o4.phiW2UpperLimit|X04 }}"), 
        phi_w2_lower_limits => (X"{{ o1.phiW2LowerLimit|X04 }}", X"{{ o2.phiW2LowerLimit|X04 }}", X"{{ o3.phiW2LowerLimit|X04 }}", X"{{ o4.phiW2LowerLimit|X04 }}"),
  {%- endif %}     
  {%- if o1.is_muon_type %}
    {%- if (o1.hasCharge) or (o2.hasCharge) or (o3.hasCharge) or (o4.hasCharge) %}
        requested_charges => ("{{ o1.charge }}", "{{ o2.charge }}", "{{ o3.charge }}", "{{ o4.charge }}"), 
    {%- endif %}        
    {%- if (o1.hasQuality) or (o2.hasQuality) or (o3.hasQuality) or (o4.hasQuality) %}
        qual_luts => (X"{{ o1.qualityLUT|X04 }}", X"{{ o2.qualityLUT|X04 }}", X"{{ o3.qualityLUT|X04 }}", X"{{ o4.qualityLUT|X04 }}"), 
    {%- endif %}        
    {%- if (o1.hasIsolation) or (o2.hasIsolation) or (o3.hasIsolation) or (o4.hasIsolation) %}
        iso_luts => (X"{{ o1.isolationLUT|X01 }}", X"{{ o2.isolationLUT|X01 }}", X"{{ o3.isolationLUT|X01 }}", X"{{ o4.isolationLUT|X01 }}"),
    {%- endif %}        
    {%- if (o1.hasUpt) or (o2.hasUpt) or (o3.hasUpt) or (o4.hasUpt) %}
        upt_cuts => ({{ o1.hasUpt|vhdl_bool }}, {{ o2.hasUpt|vhdl_bool }}, {{ o3.hasUpt|vhdl_bool }}, {{ o4.hasUpt|vhdl_bool }}), 
        upt_upper_limits => (X"{{ o1.uptUpperLimit|X04 }}", X"{{ o2.uptUpperLimit|X04 }}", X"{{ o3.uptUpperLimit|X04 }}", X"{{ o4.uptUpperLimit|X04 }}"),
        upt_lower_limits => (X"{{ o1.uptLowerLimit|X04 }}", X"{{ o2.uptLowerLimit|X04 }}", X"{{ o3.uptLowerLimit|X04 }}", X"{{ o4.uptLowerLimit|X04 }}"), 
    {%- endif %}        
    {%- if (o1.hasImpactParameter) or (o2.hasImpactParameter) or (o3.hasImpactParameter) or (o4.hasImpactParameter) %}
        ip_luts => (X"{{ o1.impactParameterLUT|X01 }}", X"{{ o2.impactParameterLUT|X01 }}", X"{{ o3.impactParameterLUT|X01 }}", X"{{ o4.impactParameterLUT|X01 }}"), 
    {%- endif %}        
    {%- if condition.chargeCorrelation  %}
        requested_charge_correlation => "{{ condition.chargeCorrelation }}",
    {%- endif %}        
  {%- elif o1.is_calo_type %}        
    {%- if (o1.hasIsolation) or (o2.hasIsolation) or (o3.hasIsolation) or (o4.hasIsolation) %}
        iso_luts => (X"{{ o1.isolationLUT|X01 }}", X"{{ o2.isolationLUT|X01 }}", X"{{ o3.isolationLUT|X01 }}", X"{{ o4.isolationLUT|X01 }}"),
    {%- endif %}        
  {%- endif %} 
{%- endblock object_cuts_comb %}

