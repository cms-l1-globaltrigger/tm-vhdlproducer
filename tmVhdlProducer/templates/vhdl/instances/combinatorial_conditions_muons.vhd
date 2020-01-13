{%- block instantiate_combinatorial_conditions_muons %}
  {%- set o1 = condition.objects[0] %}
  {%- set o2 = condition.objects[1] %}
  {%- set o3 = condition.objects[2] %}
  {%- set o4 = condition.objects[3] %}
    cond_{{ condition.vhdl_signal }}_i: entity work.combinatorial_conditions
        generic map(
            N_{{ o1.type|upper }}_OBJECTS, {{ condition.nr_objects }},
            (({{ o1.sliceLow }},{{ o1.sliceHigh }}), ({{ o2.sliceLow }},{{ o2.sliceHigh }}), ({{ o3.sliceLow }},{{ o3.sliceHigh }}), ({{ o4.sliceLow }},{{ o4.sliceHigh }})),
  {%- if condition.chargeCorrelation in ('os', 'ls') %}
            true
  {%- else %}
            false
  {%- endif %}
        )
        port map(
            lhc_clk, 
  {%- if condition.nr_objects > 0 %}
    {%- with obj = condition.objects[0] %}
            comb_1 =>  {%- include  "helper/helper_comb_and_muons_signals_names.txt" %}
    {%- endwith %}
  {%- endif %}
  {%- if condition.nr_objects > 1 %}
    {%- with obj = condition.objects[1] %}
            comb_2 =>  {%- include  "helper/helper_comb_and_muons_signals_names.txt" %}
    {%- endwith %}
  {%- endif %}
  {%- if condition.nr_objects > 2 %}
    {%- with obj = condition.objects[2] %}
            comb_3 =>  {%- include  "helper/helper_comb_and_muons_signals_names.txt" %}
    {%- endwith %}
  {%- endif %}
  {%- if condition.nr_objects > 3 %}
    {%- with obj = condition.objects[3] %}
            comb_4 =>  {%- include  "helper/helper_comb_and_muons_signals_names.txt" %}
    {%- endwith %}
  {%- endif %}
  {%- if condition.twoBodyPt.enabled == "true" %}
            tbpt => tbpt_{{ o1.type|lower }}_{{ o1.type|lower }}_bx_{{ o1.bx }}_bx_{{ o1.bx }}_0x{{ condition.twoBodyPt.threshold|X14|lower }},        
  {%- endif %}
  {%- if condition.chargeCorrelation in ('os', 'ls') %}
   {%- if condition.nr_objects  == 2 %}
            charge_corr_double => comp_cc_double_bx_{{ o1.bx }}_bx_{{ o1.bx }}_cc_{{ condition.chargeCorrelation }},
    {%- elif condition.nr_objects  == 3 %}
            charge_corr_triple => comp_cc_triple_bx_{{ o1.bx }}_bx_{{ o1.bx }}_cc_{{ condition.chargeCorrelation }},
    {%- elif condition.nr_objects  == 4 %}
            charge_corr_quad => comp_cc_quad_bx_{{ o1.bx }}_bx_{{ o1.bx }}_cc_{{ condition.chargeCorrelation }},
    {%- endif %}
  {%- endif %}
            cond_o => {{ condition.vhdl_signal }}
        );
{%- endblock instantiate_combinatorial_conditions_muons %}
