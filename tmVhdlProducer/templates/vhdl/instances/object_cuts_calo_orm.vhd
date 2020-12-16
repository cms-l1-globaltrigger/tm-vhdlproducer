{%- block object_cuts_calo_orm %}
        pt_thresholds_calo1 => (X"{{ thresholdList[0]|X04 }}", X"{{ thresholdList[1]|X04 }}", X"{{ thresholdList[2]|X04 }}", X"{{ thresholdList[3]|X04 }}"),
  {%- set max_eta_cuts = [etaNrCutsList[0], etaNrCutsList[1], etaNrCutsList[2], etaNrCutsList[3]]|max %}  
  {%- if etaNrCutsList[0] > 0 or etaNrCutsList[1] > 0 or etaNrCutsList[2] > 0 or etaNrCutsList[3] > 0 %}
        nr_eta_windows => ({{ etaNrCutsList[0] }}, {{ etaNrCutsList[1] }}, {{ etaNrCutsList[2]}}, {{ etaNrCutsList[3] }}),
  {%- endif %}        
  {%- for i in range(0,max_eta_cuts) %}
    {%- if etaNrCuts[0] > i or etaNrCuts[1] > i or etaNrCuts3 > i or etaNrCuts4 > i %}
        eta_w{{i+1}}_upper_limits => (X"{{ etaUpperLimitList[0][i]|X04 }}", X"{{ etaUpperLimitList[1][i]|X04 }}", X"{{ etaUpperLimitList[2][i]|X04}}", X"{{ etaUpperLimitList[3][i]|X04 }}"), 
        eta_w{{i+1}}_lower_limits => (X"{{ etaLowerLimitList[0][i]|X04 }}", X"{{ etaLowerLimitList[1][i]|X04 }}", X"{{ etaLowerLimitList[2][i]|X04 }}", X"{{ etaLowerLimitList[3][i]|X04 }}"),
    {%- endif %}        
  {%- endfor %}
  {%- if phiNrCutsList[0] > 0 or phiNrCutsList[1] > 0 or phiNrCutsList[2] > 0 or phiNrCutsList[3] > 0 %}
        phi_full_range_calo1 => ({{ phiFullRangeList[0] }}, {{ phiFullRangeList[1] }}, {{ phiFullRangeList[2] }}, {{ phiFullRangeList[3] }}), 
        phi_w1_upper_limits_calo1 => (X"{{ phiW1UpperLimitList[0]|X04 }}", X"{{ phiW1UpperLimitList[1]|X04 }}", X"{{ phiW1UpperLimitList[2]|X04 }}", X"{{ phiW1UpperLimitList[3]|X04 }}"), 
        phi_w1_lower_limits_calo1 => (X"{{ phiW1LowerLimitList[0]|X04 }}", X"{{ phiW1LowerLimitList[1]|X04 }}", X"{{ phiW1LowerLimitList[2]|X04 }}", X"{{ phiW1LowerLimitList[3]|X04 }}"),
  {%- endif %}        
  {%- if phiNrCutsList[0] > 1 or phiNrCutsList[1] > 1 or phiNrCutsList[2] > 1 or phiNrCutsList[3] > 1 %}
        phi_w2_ignore_calo1 => ({{ phiW2IgnoreList[0] }}, {{ phiW2IgnoreList[1] }}, {{ phiW2IgnoreList[2] }}, {{ phiW2IgnoreList[3] }}), 
        phi_w2_upper_limits_calo1 => (X"{{ phiW2UpperLimitList[0]|X04 }}", X"{{ phiW2UpperLimitList[1]|X04 }}", X"{{ phiW2UpperLimitList[2]|X04 }}", X"{{ phiW2UpperLimitList[3]|X04 }}"), 
        phi_w2_lower_limits_calo1 => (X"{{ phiW2LowerLimitList[0]|X04 }}", X"{{ phiW2LowerLimitList[1]|X04 }}", X"{{ phiW2LowerLimitList[2]|X04 }}", X"{{ phiW2LowerLimitList[3]|X04 }}"),
  {%- endif %}        
  {%- if (hasIsolationList[0]) or (hasIsolationList[1]) or (hasIsolationList[2]) or (hasIsolationList[3]) %}
        iso_luts => (X"{{ isolationLUTList[0]|X01 }}", X"{{ isolationLUTList[1]|X01 }}", X"{{ isolationLUTList[2]|X01 }}", X"{{ isolationLUTList[3]|X01 }}"),
  {%- endif %} 
  {%- if nr_requirements == 1 %}
    {%- set orm_obj = condition.objects[1] %}
  {%- elif nr_requirements == 2 %}
    {%- set orm_obj = condition.objects[2] %}
  {%- elif nr_requirements == 3 %}
    {%- set orm_obj = condition.objects[3] %}
  {%- elif nr_requirements == 4 %}
    {%- set orm_obj = condition.objects[4] %}
  {%- endif %}        
-- orm object cuts
  {%- if not orm_obj.operator %}
        pt_ge_mode_calo2 => false, 
  {%- endif %}        
        obj_type_calo2 => {{ orm_obj.type|upper }}_TYPE,
        pt_threshold_calo2 => X"{{ orm_obj.threshold|X04 }}",
  {%- if orm_obj.etaNrCuts > 0 %}
        nr_eta_windows_calo2 => {{ orm_obj.etaNrCuts }},
  {%- endif %}        
  {%- for j in range(0,(orm_obj.etaNrCuts)) %}
    {%- if orm_obj.etaNrCuts > j %}
        eta_w{{j+1}}_upper_limit_calo => X"{{ orm_obj.etaUpperLimit[j]|X04 }}", 
        eta_w{{j+1}}_lower_limit_calo => X"{{ orm_obj.etaLowerLimit[j]|X04 }}",
    {%- endif %}        
  {%- endfor %}
  {%- if orm_obj.phiNrCuts > 0 %}
        phi_full_range_calo2 => {{ orm_obj.phiFullRange }}, 
        phi_w1_upper_limit_calo2 => X"{{ orm_obj.phiW1UpperLimit|X04 }}", 
        phi_w1_lower_limit_calo2 => X"{{ orm_obj.phiW1LowerLimit|X04 }}",
  {%- endif %}        
  {%- if orm_obj.phiNrCuts > 1 %}
        phi_w2_ignore_calo2 => {{ orm_obj.phiW2Ignore }}, 
        phi_w2_upper_limit_calo2 => X"{{ orm_obj.phiW2UpperLimit|X04 }}", 
        phi_w2_lower_limit_calo2 => X"{{ orm_obj.phiW2LowerLimit|X04 }}",
  {%- endif %}        
  {%- if orm_obj.hasIsolation %}
        iso_lut_calo2 => X"{{ orm_obj.isolationLUT|X01 }}",
  {%- endif %}        
{%- endblock object_cuts_calo_orm %}
{# eof #}
