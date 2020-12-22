{%- block object_cuts_calo_orm %}
  {%- set thresholdList = [o1.threshold, o2.threshold, o3.threshold, o4.threshold] %}
  {%- set etaNrCutsList = [o1.etaNrCuts, o2.etaNrCuts, o3.etaNrCuts, o4.etaNrCuts] %}
  {%- set phiNrCutsList = [o1.phiNrCuts, o2.phiNrCuts, o3.phiNrCuts, o4.phiNrCuts] %}
  {%- set etaUpperLimitList = [o1.etaUpperLimit, o2.etaUpperLimit, o3.etaUpperLimits, o4.etaUpperLimit] %}
  {%- set etaLowerLimitList = [o1.etaLowerLimit, o2.etaLowerLimit, o3.etaLowerLimit, o4.etaLowerLimit] %}
  {%- set phiFullRangeList = [o1.phiFullRange, o2.phiFullRange, o3.phiFullRange, o4.phiFullRange] %}
  {%- set phiW2IgnoreList = [o1.phiW2Ignore, o2.phiW2Ignore, o3.phiW2Ignore, o4.phiW2Ignore] %}
  {%- set phiUpperLimitList = [o1.phiUpperLimit, o2.phiUpperLimit, o3.phiUpperLimits, o4.phiUpperLimit] %}
  {%- set phiLowerLimitList = [o1.phiLowerLimit, o2.phiLowerLimit, o3.phiLowerLimit, o4.phiLowerLimit] %}
  {%- set hasIsolationList = [o1.hasIsolation, o2.hasIsolation, o3.hasIsolation, o4.hasIsolation] %}
  {%- set isolationLUTList = [o1.isolationLUT, o2.isolationLUT, o3.isolationLUT, o4.isolationLUT] %}

  {%- for i in range(nr_requirements,condition.ReqObjects-1)|reverse %}
    {%- set temp = thresholdList.append(0) %}
    {%- set temp = thresholdList.pop(i) %}
    {%- set temp = etaNrCutsList.append(0) %}
    {%- set temp = etaNrCutsList.pop(i) %}
    {%- set temp = phiNrCutsList.append(0) %}
    {%- set temp = phiNrCutsList.pop(i) %}
    {%- set temp = etaUpperLimitList.append(0) %}
    {%- set temp = etaUpperLimitList.pop(i) %}
    {%- set temp = etaLowerLimitList.append(0) %}
    {%- set temp = etaLowerLimitList.pop(i) %}
    {%- set temp = phiFullRangeList.append(0) %}
    {%- set temp = phiFullRangeList.pop(i) %}
    {%- set temp = phiW2IgnoreList.append(0) %}
    {%- set temp = phiW2IgnoreList.pop(i) %}
    {%- set temp = phiUpperLimitList.append(0) %}
    {%- set temp = phiUpperLimitList.pop(i) %}
    {%- set temp = phiLowerLimitList.append(0) %}
    {%- set temp = phiLowerLimitList.pop(i) %}
    {%- set temp = hasIsolationList.append(0) %}
    {%- set temp = hasIsolationList.pop(i) %}
    {%- set temp = isolationLUTList.append(0) %}
    {%- set temp = isolationLUTList.pop(i) %}
  {%- endfor %}

  {%- for i in range(1,nr_requirements) %}
    {%- set o = condition.objects[i] %}
    {%- if nr_requirements > i and o.hasSlice %}
        slice_{{i}}_low_obj1 => {{ o.sliceLow }}, 
        slice_{{i}}_high_obj1 => {{ o.sliceHigh }}, 
    {%- endif %}        
  {%- endfor %}        
-- object cuts
  {%- if not o1.operator %}
        pt_ge_mode_obj1 => {{ o1.operator|vhdl_bool }}, 
  {%- endif %}        
        pt_thresholds_obj1 => (X"{{ thresholdList[0]|X04 }}", X"{{ thresholdList[1]|X04 }}", X"{{ thresholdList[2]|X04 }}", X"{{ thresholdList[3]|X04 }}"),
  {%- set max_eta_cuts = [etaNrCutsList[0], etaNrCutsList[1], etaNrCutsList[2], etaNrCutsList[3]]|max %}  
  {%- if etaNrCutsList[0] > 0 or etaNrCutsList[1] > 0 or etaNrCutsList[2] > 0 or etaNrCutsList[3] > 0 %}
        nr_eta_windows_obj1 => ({{ etaNrCutsList[0] }}, {{ etaNrCutsList[1] }}, {{ etaNrCutsList[2]}}, {{ etaNrCutsList[3] }}),
  {%- endif %}        
  {%- for i in range(0,max_eta_cuts) %}
    {%- if etaNrCuts[0] > i or etaNrCuts[1] > i or etaNrCuts3 > i or etaNrCuts4 > i %}
        eta_w{{i+1}}_upper_limits_obj1 => (X"{{ etaUpperLimitList[0][i]|X04 }}", X"{{ etaUpperLimitList[1][i]|X04 }}", X"{{ etaUpperLimitList[2][i]|X04}}", X"{{ etaUpperLimitList[3][i]|X04 }}"), 
        eta_w{{i+1}}_lower_limits_obj1 => (X"{{ etaLowerLimitList[0][i]|X04 }}", X"{{ etaLowerLimitList[1][i]|X04 }}", X"{{ etaLowerLimitList[2][i]|X04 }}", X"{{ etaLowerLimitList[3][i]|X04 }}"),
    {%- endif %}        
  {%- endfor %}
  {%- set max_phi_cuts = [phiNrCutsList[0], phiNrCutsList[1], phiNrCutsList[2], phiNrCutsList[3]]|max %}  
  {%- if phiNrCutsList[0] > 0 or phiNrCutsList[1] > 0 or phiNrCutsList[2] > 0 or phiNrCutsList[3] > 0 %}
        nr_phi_windows_obj1 => ({{ phiNrCutsList[0] }}, {{ phiNrCutsList[1] }}, {{ phiNrCutsList[2]}}, {{ phiNrCutsList[3] }}),
  {%- endif %}        
  {%- for i in range(0,max_phi_cuts) %}
    {%- if phiNrCutsList[0] > 0 or phiNrCutsList[1] > 0 or phiNrCutsList[2] > 0 or phiNrCutsList[3] > 0 %}
        phi_w{{i+1}}_upper_limits_obj1 => (X"{{ phiW1UpperLimitList[0][i]|X04 }}", X"{{ phiW1UpperLimitList[1][i]|X04 }}", X"{{ phiW1UpperLimitList[2][i]|X04 }}", X"{{ phiW1UpperLimitList[3][i]|X04 }}"), 
        phi_w{{i+1}}_lower_limits_obj1 => (X"{{ phiW1LowerLimitList[0][i]|X04 }}", X"{{ phiW1LowerLimitList[1][i]|X04 }}", X"{{ phiW1LowerLimitList[2][i]|X04 }}", X"{{ phiW1LowerLimitList[3][i]|X04 }}"),
    {%- endif %}        
  {%- endfor %}
  {%- if (hasIsolationList[0]) or (hasIsolationList[1]) or (hasIsolationList[2]) or (hasIsolationList[3]) %}
        iso_luts_obj1 => (X"{{ isolationLUTList[0]|X01 }}", X"{{ isolationLUTList[1]|X01 }}", X"{{ isolationLUTList[2]|X01 }}", X"{{ isolationLUTList[3]|X01 }}"),
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
        pt_ge_mode_obj2 => false, 
  {%- endif %}        
        pt_threshold_obj2 => X"{{ orm_obj.threshold|X04 }}",
  {%- if orm_obj.etaNrCuts > 0 %}
        nr_eta_windows_obj2 => {{ orm_obj.etaNrCuts }},
  {%- endif %}        
  {%- for j in range(0,(orm_obj.etaNrCuts)) %}
    {%- if orm_obj.etaNrCuts > j %}
        eta_w{{j+1}}_upper_limit_calo => X"{{ orm_obj.etaUpperLimit[j]|X04 }}", 
        eta_w{{j+1}}_lower_limit_calo => X"{{ orm_obj.etaLowerLimit[j]|X04 }}",
    {%- endif %}        
  {%- endfor %}
  {%- if orm_obj.phiNrCuts > 0 %}
        nr_phi_windows_obj2 => {{ orm_obj.phiNrCuts }},
  {%- endif %}        
  {%- for j in range(0,(orm_obj.phiNrCuts)) %}
    {%- if orm_obj.phiNrCuts > j %}
        phi_w{{j+1}}_upper_limit_calo => X"{{ orm_obj.phiUpperLimit[j]|X04 }}", 
        phi_w{{j+1}}_lower_limit_calo => X"{{ orm_obj.phiLowerLimit[j]|X04 }}",
    {%- endif %}        
  {%- endfor %}
  {%- if orm_obj.hasIsolation %}
        iso_lut_obj2 => X"{{ orm_obj.isolationLUT|X01 }}",
  {%- endif %}        
{%- endblock object_cuts_calo_orm %}
