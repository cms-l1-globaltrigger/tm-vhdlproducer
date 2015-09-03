{%- for algoName in menu.reporter['index_sorted'] %}
{%- set algoDict = menu.reporter['algoDict'][algoName] %}
  {%- for condName in algoDict['condDict'].keys() %}
    {%- set condDict = algoDict['condDict'][condName]%}
    {%- for objDict in condDict['objList'] %}
      {%- set objName = objDict['name'] %}
      {%- set Bx = objDict['Bx'] %}
      {{condName}},{{objName}}, {{objDict['objType']}} 
      
    signal {{objDict['objType']}}_eta_bx_{{Bx}} : diff_inputs_array(0 to nr_{{objDict['objType']}}_objects-1) := (others => (others => '0'));
    signal {{objDict['objType']}}_eta_common_bx_{{Bx}} : diff_inputs_array(0 to nr_{{objDict['objType']}}_objects-1) := (others => (others => '0'));
    signal {{objDict['objType']}}_phi_bx_{{Bx}} : diff_inputs_array(0 to nr_{{objDict['objType']}}_objects-1) := (others => (others => '0'));
    signal {{objDict['objType']}}_phi_common_bx_{{Bx}} : diff_inputs_array(0 to nr_{{objDict['objType']}}_objects-1) := (others => (others => '0'));
    {%-endfor%}
  {%-endfor%}
{%-endfor%}

