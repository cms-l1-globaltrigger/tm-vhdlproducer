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
{%- set Bx = objInfo['Bx'] %}
{#-#}
{#-#}
muon_charges_bx_{{Bx}}_i: muon_charges
    port map(muon_bx_{{Bx}}, pos_charge_single_bx_{{Bx}}, neg_charge_single_bx_{{Bx}},
        eq_charge_double_bx_{{Bx}}, neq_charge_double_bx_{{Bx}},
        eq_charge_triple_bx_{{Bx}}, neq_charge_triple_bx_{{Bx}},
        eq_charge_quad_bx_{{Bx}}, pair_charge_quad_bx_{{Bx}});
{#-#}
{#-#}
{%-endfor%}
{%-endif%}
{%-endfor%}
