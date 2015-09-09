{%- set signalEtaPhiList={} %}
{%- for algoName in menu.reporter['index_sorted'] %}
{%- set algoDict = menu.reporter['algoDict'][algoName] %}
{%- set algoIndex = algoDict["index"] %}
{%- if algoIndex in menu.reporter['m2a'][iMod]%}
  {%- for condName in algoDict['condDict'].keys() %}
    {%- set objType = algoDict['condDict'][condName]['TriggerGroup'] %} 
    {%- if not signalEtaPhiList.has_key(objType)%}
        {%-if signalEtaPhiList.__setitem__(objType,[]) %}
        {%-endif %}
    {%-endif%}
    {%- set condDict = algoDict['condDict'][condName]%}
    {%- set nObj = condDict['objList'] | count %}
    {%- set objInfo={}%}
    {%- for iObj in range(nObj) %}
      {%- set objDict = condDict['objList'][iObj] %}
            {%-if not objDict['Bx'] in signalEtaPhiList[objType] %}
              {%-if signalEtaPhiList[objType].append(objDict['Bx'])%}
              {%-endif%}
            {%-endif%}
    {%-endfor%}
  {%-endfor%}
{%-endif %}
{%-endfor%}
{%- for objName in signalEtaPhiList %}
  {%- for Bx in signalEtaPhiList[objName] %}

    signal {{objName}}_eta_bx_{{Bx}} : diff_inputs_array(0 to nr_{{objName}}_objects-1) := (others => (others => '0'));
    signal {{objName}}_eta_common_bx_{{Bx}} : diff_inputs_array(0 to nr_{{objName}}_objects-1) := (others => (others => '0'));
    signal {{objName}}_phi_bx_{{Bx}} : diff_inputs_array(0 to nr_{{objName}}_objects-1) := (others => (others => '0'));
    signal {{objName}}_phi_common_bx_{{Bx}} : diff_inputs_array(0 to nr_{{objName}}_objects-1) := (others => (others => '0'));

  {%-endfor%}
{%-endfor%}
