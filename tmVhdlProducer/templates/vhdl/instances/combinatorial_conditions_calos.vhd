{%- block instantiate_combinatorial_conditions_calos %}
  {%- set o1 = condition.objects[0] %}
  {%- set o2 = condition.objects[1] %}
  {%- set o3 = condition.objects[2] %}
  {%- set o4 = condition.objects[3] %}
    cond_{{ condition.vhdl_signal }}_i: entity work.combinatorial_conditions
        generic map(
            N_{{ o1.type|upper }}_OBJECTS, {{ condition.nr_objects }},
            (({{ o1.sliceLow }},{{ o1.sliceHigh }}), ({{ o2.sliceLow }},{{ o2.sliceHigh }}), ({{ o3.sliceLow }},{{ o3.sliceHigh }}), ({{ o4.sliceLow }},{{ o4.sliceHigh }})),
            false
        )
        port map(
            lhc_clk, 
  {%- if condition.nr_objects > 0 %}
    {%- with obj = condition.objects[0] %}
            comb_1 =>  {%- include  "helper/helper_comb_and_calos_signals_names.txt" %}
    {%- endwith %}
  {%- endif %}
  {%- if condition.nr_objects > 1 %}
    {%- with obj = condition.objects[1] %}
            comb_2 =>  {%- include  "helper/helper_comb_and_calos_signals_names.txt" %}
    {%- endwith %}
  {%- endif %}
  {%- if condition.nr_objects > 2 %}
    {%- with obj = condition.objects[2] %}
            comb_3 =>  {%- include  "helper/helper_comb_and_calos_signals_names.txt" %}
    {%- endwith %}
  {%- endif %}
  {%- if condition.nr_objects > 3 %}
    {%- with obj = condition.objects[3] %}
            comb_4 =>  {%- include  "helper/helper_comb_and_calos_signals_names.txt" %}
    {%- endwith %}
  {%- endif %}
  {%- if condition.twoBodyPt.enabled == "true" %}
            tbpt => tbpt_{{ o1.type|lower }}_{{ o1.type|lower }}_bx_{{ o1.bx }}_bx_{{ o1.bx }}_0x{{ condition.twoBodyPt.threshold|X14|lower }},        
  {%- endif %}
            cond_o => {{ condition.vhdl_signal }}
        );
{%- endblock instantiate_combinatorial_conditions_calos %}
