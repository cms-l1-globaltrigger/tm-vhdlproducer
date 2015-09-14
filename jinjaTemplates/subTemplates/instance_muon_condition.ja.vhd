{%- for algoName in menu.reporter['index_sorted'] %}
{%- set algoDict = menu.reporter['algoDict'][algoName] %}
{%- set algoIndex = algoDict["index"] %}
{%- if algoIndex in menu.reporter['m2a'][iMod]%}
  {%- for condName in algoDict['condDict'].keys() if ( "MU" in condName )    %}
  {#-    ######################## if not "Muon" in algoDict['condDict'][condName]['TriggerGroup']    #}
    {%- set nMuons = menu.reporter['algoDict'][algoName]['condDict'][condName]['objList'] | count %}
    {%- set condDict = algoDict['condDict'][condName]%}
    {%- set muCondDict = condDict['ConditionTemplates']['muon_condition_dict']  %} 
    {%- set objInfo={}%}
    {%- for iObj in range(nMuons) if "MU" in condDict['objList'][iObj]['name']%}
      {%- set objDict = condDict['objList'][iObj] %}
            {%-if loop.index0==0 %}
              {%- if objInfo.update({"Bx": objDict['Bx']  , "op":objDict["op"] }) %}{%-endif%}{#- dirty way of doing "do" #}
            {%-endif %}
    {%-endfor%}
{#-#}
{#-#}
{#-#}
{#-#}
{#-#}
{{condName}}_i: muon_conditions
    generic map(NR_MUON_OBJECTS, {{nMuons}}, {{DoubleWsc|default("false")}}, {{ objInfo['op'] }}, d_s_i_muon,
        (X"{{muCondDict['PtThresholds'][0]|X04}}", X"{{muCondDict['PtThresholds'][1]|X04}}", X"{{muCondDict['PtThresholds'][2]|X04}}", X"{{muCondDict['PtThresholds'][3]|X04}}"),
        ({{muCondDict['EtaFullRange'][0]}}, {{muCondDict['EtaFullRange'][1]}}, {{muCondDict['EtaFullRange'][2]}}, {{muCondDict['EtaFullRange'][3]}}),
        (X"{{muCondDict['EtaW1UpperLimits'][0]|X04}}", X"{{muCondDict['EtaW1UpperLimits'][1]|X04}}", X"{{muCondDict['EtaW1UpperLimits'][2]|X04}}", X"{{muCondDict['EtaW1UpperLimits'][3]|X04}}"), (X"{{muCondDict['EtaW1LowerLimits'][0]|X04}}", X"{{muCondDict['EtaW1LowerLimits'][1]|X04}}", X"{{muCondDict['EtaW1LowerLimits'][2]|X04}}", X"{{muCondDict['EtaW1LowerLimits'][3]|X04}}"),
        ({{muCondDict['EtaW2Ignore'][0]}}, {{muCondDict['EtaW2Ignore'][1]}}, {{muCondDict['EtaW2Ignore'][2]}}, {{muCondDict['EtaW2Ignore'][3]}}),
        (X"{{muCondDict['EtaW2UpperLimits'][0]|X04}}", X"{{muCondDict['EtaW2UpperLimits'][1]|X04}}", X"{{muCondDict['EtaW2UpperLimits'][2]|X04}}", X"{{muCondDict['EtaW2UpperLimits'][3]|X04}}"), (X"{{muCondDict['EtaW2LowerLimits'][0]|X04}}", X"{{muCondDict['EtaW2LowerLimits'][1]|X04}}", X"{{muCondDict['EtaW2LowerLimits'][2]|X04}}", X"{{muCondDict['EtaW2LowerLimits'][3]|X04}}"),
        ({{muCondDict['PhiFullRange'][0]}}, {{muCondDict['PhiFullRange'][1]}}, {{muCondDict['PhiFullRange'][2]}}, {{muCondDict['PhiFullRange'][3]}}),
        (X"{{muCondDict['PhiW1UpperLimits'][0]|X04}}", X"{{muCondDict['PhiW1UpperLimits'][1]|X04}}", X"{{muCondDict['PhiW1UpperLimits'][2]|X04}}", X"{{muCondDict['PhiW1UpperLimits'][3]|X04}}"), (X"{{muCondDict['PhiW1LowerLimits'][0]|X04}}", X"{{muCondDict['PhiW1LowerLimits'][1]|X04}}", X"{{muCondDict['PhiW1LowerLimits'][2]|X04}}", X"{{muCondDict['PhiW1LowerLimits'][3]|X04}}"),
        ({{muCondDict['PhiW2Ignore'][0]}}, {{muCondDict['PhiW2Ignore'][1]}}, {{muCondDict['PhiW2Ignore'][2]}}, {{muCondDict['PhiW2Ignore'][3]}}),
        (X"{{muCondDict['PhiW2UpperLimits'][0]|X04}}", X"{{muCondDict['PhiW2UpperLimits'][1]|X04}}", X"{{muCondDict['PhiW2UpperLimits'][2]|X04}}", X"{{muCondDict['PhiW2UpperLimits'][3]|X04}}"), (X"{{muCondDict['PhiW2LowerLimits'][0]|X04}}", X"{{muCondDict['PhiW2LowerLimits'][1]|X04}}", X"{{muCondDict['PhiW2LowerLimits'][2]|X04}}", X"{{muCondDict['PhiW2LowerLimits'][3]|X04}}"),
        ("{{muCondDict['RequestedCharges'][0]}}", "{{muCondDict['RequestedCharges'][1]}}", "{{muCondDict['RequestedCharges'][2]}}", "{{muCondDict['RequestedCharges'][3]}}"),
        (X"{{muCondDict['QualityLuts'][0]|X04}}", X"{{muCondDict['QualityLuts'][1]|X04}}", X"{{muCondDict['QualityLuts'][2]|X04}}", X"{{muCondDict['QualityLuts'][3]|X04}}"),
        (X"{{muCondDict['IsolationLuts'][0]|X01}}", X"{{muCondDict['IsolationLuts'][1]|X01}}", X"{{muCondDict['IsolationLuts'][2]|X01}}", X"{{muCondDict['IsolationLuts'][3]|X01}}"),
        "{{muCondDict['RequestedChargeCorrelation']}}",
        {{muCondDict['DiffEtaUpperLimit']}}, {{muCondDict['DiffEtaLowerLimit']}}, {{muCondDict['DiffPhiUpperLimit']}}, {{muCondDict['DiffPhiLowerLimit']}})

    {%- set Bx = objInfo['Bx'] %}
    port map(lhc_clk, muon_bx_{{Bx|lower}},
        ls_charcorr_double_bx_{{Bx|lower}}, os_charcorr_double_bx_{{Bx|lower}},
        ls_charcorr_triple_bx_{{Bx|lower}}, os_charcorr_triple_bx_{{Bx|lower}},
        ls_charcorr_quad_bx_{{Bx|lower}}, os_charcorr_quad_bx_{{Bx|lower}},
        diff_muon_wsc_eta_bx_{{Bx|lower}}, diff_muon_wsc_phi_bx_{{Bx|lower}},
        {{condName}});
{#-#}
{#-#}
{#-#}
{#-#}
{%-endfor%}
{%-endif%}
{%-endfor%}
