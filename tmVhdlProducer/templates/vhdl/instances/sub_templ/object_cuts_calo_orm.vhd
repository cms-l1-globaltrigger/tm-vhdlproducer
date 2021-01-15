{%- block object_cuts_calo_orm %}
  {%- set thresholdList = condition.objects[0].thresholdListDef %}
  {%- set etaNrCutsList = condition.objects[0].etaNrCutsListDef %}
  {%- set phiNrCutsList = condition.objects[0].phiNrCutsListDef %}
  {%- set etaUpperLimitList = condition.objects[0].etaUpperLimitListDef %}
  {%- set etaLowerLimitList = condition.objects[0].etaLowerLimitListDef %}
  {%- set phiUpperLimitList = condition.objects[0].phiUpperLimitListDef %}
  {%- set phiLowerLimitList = condition.objects[0].phiLowerLimitListDef %}
  {%- set hasIsolationList = condition.objects[0].hasIsolationListDef %}
  {%- set isolationLUTList = condition.objects[0].isolationLUTListDef %}

  {%- for i in range(0,nr_requirements) %}
    {%- if thresholdList.insert(i,condition.objects[i].threshold) %}{%- endif %}
    {%- if etaNrCutsList.insert(i,condition.objects[i].etaNrCuts) %}{%- endif %}
    {%- if phiNrCutsList.insert(i,condition.objects[i].phiNrCuts) %}{%- endif %}
    {%- if etaUpperLimitList.insert(i,condition.objects[i].etaUpperLimit) %}{%- endif %}
    {%- if etaLowerLimitList.insert(i,condition.objects[i].etaLowerLimit) %}{%- endif %}
    {%- if phiUpperLimitList.insert(i,condition.objects[i].phiUpperLimit) %}{%- endif %}
    {%- if phiLowerLimitList.insert(i,condition.objects[i].phiLowerLimit) %}{%- endif %}
    {%- if hasIsolationList.insert(i,condition.objects[i].hasIsolation) %}{%- endif %}
    {%- if isolationLUTList.insert(i,condition.objects[i].isolationLUT) %}{%- endif %}
  {%- endfor %}
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
        pt_ge_mode_obj2 => {{ orm_obj.operator|vhdl_bool }}, 
  {%- endif %}        
        pt_threshold_obj2 => X"{{ orm_obj.threshold|X04 }}",
  {%- if orm_obj.etaNrCuts > 0 %}
        nr_eta_windows_obj2 => {{ orm_obj.etaNrCuts }},
  {%- endif %}        
  {%- for j in range(0,(orm_obj.etaNrCuts)) %}
    {%- if orm_obj.etaNrCuts > j %}
        eta_w{{j+1}}_upper_limit_obj2 => X"{{ orm_obj.etaUpperLimit[j]|X04 }}", 
        eta_w{{j+1}}_lower_limit_obj2 => X"{{ orm_obj.etaLowerLimit[j]|X04 }}",
    {%- endif %}        
  {%- endfor %}
  {%- if orm_obj.phiNrCuts > 0 %}
        nr_phi_windows_obj2 => {{ orm_obj.phiNrCuts }},
  {%- endif %}        
  {%- for j in range(0,(orm_obj.phiNrCuts)) %}
    {%- if orm_obj.phiNrCuts > j %}
        phi_w{{j+1}}_upper_limit_obj2 => X"{{ orm_obj.phiUpperLimit[j]|X04 }}", 
        phi_w{{j+1}}_lower_limit_obj2 => X"{{ orm_obj.phiLowerLimit[j]|X04 }}",
    {%- endif %}        
  {%- endfor %}
  {%- if orm_obj.hasIsolation %}
        iso_lut_obj2 => X"{{ orm_obj.isolationLUT|X01 }}",
  {%- endif %}        
{%- endblock object_cuts_calo_orm %}
