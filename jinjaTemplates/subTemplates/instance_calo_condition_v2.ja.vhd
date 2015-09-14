{%- for algoName in menu.reporter['index_sorted'] %}
{%- set algoDict = menu.reporter['algoDict'][algoName] %}
{%- set algoIndex = algoDict["index"] %}
{%- if algoIndex in menu.reporter['m2a'][iMod]%}
  {%- for condName in algoDict['condDict'].keys() if ( "EG" in condName or "JET" in condName or "TAU" in condName )    %}   
  {#%- for condName in algoDict['condDict'].keys() if ( "EG" in condName or "JET" in condName or "TAU" in condName )    %#}  
    {%- if "JET" in condName %}
      {%set objName="JET"%}
    {%-endif%}
    {%- if "TAU" in condName %}
      {%set objName="TAU"%}
    {%-endif%}
    {%- if "EG" in condName %}
      {%set objName="EG"%}
    {%-endif%}
    {% set ObjectType= objName %}
    {%- set nObj = menu.reporter['algoDict'][algoName]['condDict'][condName]['objList'] | count %}
    {%- set condDict = algoDict['condDict'][condName]%}
    {%- set caloCondDict = condDict['ConditionTemplates']['calo_condition_dict']  %}
    {%- set objInfo={}%}
    {%- for iObj in range(nObj) if objName in condDict['objList'][iObj]['name']%}
      {%- set objDict = condDict['objList'][iObj] %}
            {%-if loop.index0==0 %}
              {%- if objInfo.update({"Bx": objDict['Bx']  , "op":objDict["op"] }) %}{%-endif%}{#- dirty way of doing "do" #}
            {%-endif %}
    {%-endfor%}
    {%- set Bx = objInfo['Bx'] %}
{#-#}
{#-#}
{#-#}
{#-#}
{#-#}
{{condName}}_i: entity work.calo_conditions_v2
    generic map(NR_{{ObjectType}}_OBJECTS, {{nObj}}, {{DoubleWsc|default("false")}} , {{ objInfo['op'] }}, {{ObjectType}}_TYPE,
        (X"{{caloCondDict['EtThresholds'][0]|X04}}", X"{{caloCondDict['EtThresholds'][1]|X04}}", X"{{caloCondDict['EtThresholds'][2]|X04}}", X"{{caloCondDict['EtThresholds'][3]|X04}}"),
        ({{caloCondDict['EtaFullRange'][0]}}, {{caloCondDict['EtaFullRange'][1]}}, {{caloCondDict['EtaFullRange'][2]}}, {{caloCondDict['EtaFullRange'][3]}}),
        (X"{{caloCondDict['EtaW1UpperLimits'][0]|X04}}", X"{{caloCondDict['EtaW1UpperLimits'][1]|X04}}", X"{{caloCondDict['EtaW1UpperLimits'][2]|X04}}", X"{{caloCondDict['EtaW1UpperLimits'][3]|X04}}"), (X"{{caloCondDict['EtaW1LowerLimits'][0]|X04}}", X"{{caloCondDict['EtaW1LowerLimits'][1]|X04}}", X"{{caloCondDict['EtaW1LowerLimits'][2]|X04}}", X"{{caloCondDict['EtaW1LowerLimits'][3]|X04}}"),
        ({{caloCondDict['EtaW2Ignore'][0]}}, {{caloCondDict['EtaW2Ignore'][1]}}, {{caloCondDict['EtaW2Ignore'][2]}}, {{caloCondDict['EtaW2Ignore'][3]}}),
        (X"{{caloCondDict['EtaW2UpperLimits'][0]|X04}}", X"{{caloCondDict['EtaW2UpperLimits'][1]|X04}}", X"{{caloCondDict['EtaW2UpperLimits'][2]|X04}}", X"{{caloCondDict['EtaW2UpperLimits'][3]|X04}}"), (X"{{caloCondDict['EtaW2LowerLimits'][0]|X04}}", X"{{caloCondDict['EtaW2LowerLimits'][1]|X04}}", X"{{caloCondDict['EtaW2LowerLimits'][2]|X04}}", X"{{caloCondDict['EtaW2LowerLimits'][3]|X04}}"),
        ({{caloCondDict['PhiFullRange'][0]}}, {{caloCondDict['PhiFullRange'][1]}}, {{caloCondDict['PhiFullRange'][2]}}, {{caloCondDict['PhiFullRange'][3]}}),
        (X"{{caloCondDict['PhiW1UpperLimits'][0]|X04}}", X"{{caloCondDict['PhiW1UpperLimits'][1]|X04}}", X"{{caloCondDict['PhiW1UpperLimits'][2]|X04}}", X"{{caloCondDict['PhiW1UpperLimits'][3]|X04}}"), (X"{{caloCondDict['PhiW1LowerLimits'][0]|X04}}", X"{{caloCondDict['PhiW1LowerLimits'][1]|X04}}", X"{{caloCondDict['PhiW1LowerLimits'][2]|X04}}", X"{{caloCondDict['PhiW1LowerLimits'][3]|X04}}"),
        ({{caloCondDict['PhiW2Ignore'][0]}}, {{caloCondDict['PhiW2Ignore'][1]}}, {{caloCondDict['PhiW2Ignore'][2]}}, {{caloCondDict['PhiW2Ignore'][3]}}),
        (X"{{caloCondDict['PhiW2UpperLimits'][0]|X04}}", X"{{caloCondDict['PhiW2UpperLimits'][1]|X04}}", X"{{caloCondDict['PhiW2UpperLimits'][2]|X04}}", X"{{caloCondDict['PhiW2UpperLimits'][3]|X04}}"), (X"{{caloCondDict['PhiW2LowerLimits'][0]|X04}}", X"{{caloCondDict['PhiW2LowerLimits'][1]|X04}}", X"{{caloCondDict['PhiW2LowerLimits'][2]|X04}}", X"{{caloCondDict['PhiW2LowerLimits'][3]|X04}}"),   
        (X"{{caloCondDict['IsoLuts'][0]|X01}}", X"{{caloCondDict['IsoLuts'][1]|X01}}", X"{{caloCondDict['IsoLuts'][2]|X01}}", X"{{caloCondDict['IsoLuts'][3]|X01}}"),
        {{caloCondDict['DiffEtaUpperLimit']}}, {{caloCondDict['DiffEtaLowerLimit']}}, {{caloCondDict['DiffPhiUpperLimit']}}, {{caloCondDict['DiffPhiLowerLimit']}})
    port map(lhc_clk, {{ObjectType|lower}}_bx_{{Bx}}, diff_{{ObjectType|lower}}_wsc_eta_bx_{{Bx}}, diff_{{ObjectType|lower}}_wsc_phi_bx_{{Bx}},
        {{condName}});
{#-#}
{#-#}
{#-#}
{%-endfor%}
{%-endif%}
{%-endfor%}
