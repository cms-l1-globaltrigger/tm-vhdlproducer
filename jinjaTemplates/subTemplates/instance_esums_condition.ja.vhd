{%- for algoName in menu.reporter['index_sorted'] %}
{%- set algoDict = menu.reporter['algoDict'][algoName] %}
{%- set algoIndex = algoDict["index"] %}
{%- if algoIndex in menu.reporter['m2a'][iMod]%}
  {%- for condName in algoDict['condDict'].keys() if ( "ETT" in condName or "HTT" in condName or "ETM" in condName or "HTM" in condName )    %}   
    {%- if "ETT" in condName %}  {%- set objName="ETT"%} {%-endif%}
    {%- if "HTT" in condName %}  {%- set objName="HTT"%} {%-endif%}
    {%- if "ETM" in condName %}  {%- set objName="ETM"%} {%-endif%}
    {%- if "HTM" in condName %}  {%- set objName="HTM"%} {%-endif%}
    {% set ObjectType= objName + "_TYPE" %}
    {%- set nObj = menu.reporter['algoDict'][algoName]['condDict'][condName]['objList'] | count %}
    {%- set condDict = algoDict['condDict'][condName]%}
    {%- set esumsCondDict = condDict['ConditionTemplates']['esums_condition_dict']  %}
    {%- set objInfo={}%}
    {%- for iObj in range(nObj) if objName in condDict['objList'][iObj]['name']%}
      {%- set objDict = condDict['objList'][iObj] %}
            {%-if loop.index0==0 %}
              {%- if objInfo.update({"Bx": objDict['Bx']  , "op": objDict["op"]>0  }) %}{%-endif%}{#- dirty way of doing "do" #}
            {%-endif %}
    {%-endfor%}
    {%- set Bx = objInfo['Bx'] %}



{{condName}}_i: esums_conditions
    generic map({{ objInfo['op'] | lower  }}, {{ObjectType}}_TYPE,
        X"{{esumsCondDict["EtThreshold"][0]|X04}}",
        {{esumsCondDict["PhiFullRange"][0]}}, X"{{esumsCondDict["PhiW1UpperLimit"][0]|X04}}", X"{{esumsCondDict["PhiW1LowerLimit"][0]|X04}}",
        {{esumsCondDict["PhiW2Ignore"][0]}}, X"{{esumsCondDict["PhiW2UpperLimit"][0]|X04}}", X"{{esumsCondDict["PhiW2LowerLimit"][0]|X04}}"
        )
    port map(lhc_clk, {{ObjectType|lower}}_bx_{{Bx|lower}}, {{condName}});


{#-#}
{#-#}
{#-#}
{%-endfor%}
{%-endif%}
{%-endfor%}


