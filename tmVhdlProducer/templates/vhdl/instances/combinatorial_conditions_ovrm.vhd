{%- block instantiate_combinatorial_conditions_ovrm %}
  {%- set o1 = condition.objects[0] %}
  {%- set o2 = condition.objects[1] %}
  {%- set o3 = condition.objects[2] %}
  {%- set o4 = condition.objects[3] %}
  {%- set o5 = condition.objects[4] %}
    cond_{{ condition.vhdl_signal }}_i: entity work.combinatorial_conditions_ovrm
        generic map(
  {%- if condition.nr_objects == 2 %}  
            N_{{ o1.type|upper }}_OBJECTS, N_{{ o2.type|upper }}_OBJECTS, 1,
            (({{ o1.sliceLow }},{{ o1.sliceHigh }}), (0,0), (0,0), (0,0)),
            (({{ o2.sliceLow }},{{ o2.sliceHigh }}), (0,0), (0,0), (0,0)),
  {%- elif condition.nr_objects == 3 %}  
            N_{{ o1.type|upper }}_OBJECTS, N_{{ o3.type|upper }}_OBJECTS, 2,
            (({{ o1.sliceLow }},{{ o1.sliceHigh }}), ({{ o2.sliceLow }},{{ o2.sliceHigh }}), (0,0), (0,0)),
            (({{ o3.sliceLow }},{{ o3.sliceHigh }}), (0,0), (0,0), (0,0)),
  {%- elif condition.nr_objects == 4 %}
            N_{{ o1.type|upper }}_OBJECTS, N_{{ o4.type|upper }}_OBJECTS, 3,
            (({{ o1.sliceLow }},{{ o1.sliceHigh }}), ({{ o2.sliceLow }},{{ o2.sliceHigh }}), ({{ o3.sliceLow }},{{ o3.sliceHigh }}), (0,0)),
            (({{ o4.sliceLow}},{{ o4.sliceHigh }}), (0,0), (0,0), (0,0)),
  {%- elif condition.nr_objects == 5 %}
            N_{{ o1.type|upper }}_OBJECTS, N_{{ o5.type|upper }}_OBJECTS, 4,
            (({{ o1.sliceLow }},{{ o1.sliceHigh }}), ({{ o2.sliceLow }},{{ o2.sliceHigh }}), ({{ o3.sliceLow }},{{ o3.sliceHigh }}), ({{ o4.sliceLow }},{{ o4.sliceHigh }})),
            (({{ o5.sliceLow }},{{ o5.sliceHigh }}), (0,0), (0,0), (0,0)),
  {%- endif %}
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
  {%- if condition.nr_objects > 4 %}
    {%- with obj = condition.objects[4] %}
            comb_ovrm =>  {%- include  "helper/helper_comb_and_calos_signals_names.txt" %}
    {%- endwith %}
  {%- endif %}
  {%- if condition.twoBodyPt.enabled == "true" %}
            tbpt => tbpt_{{ o1.type|lower }}_{{ o1.type|lower }}_bx_{{ o1.bx }}_bx_{{ o1.bx }}_0x{{ condition.twoBodyPt.lower|X14|lower }},        
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
  {%- if condition.nr_objects == 2 %}  
    {%- if condition.deltaEtaOrm.enabled == "true" %} 
            deta_ovrm => comp_deta_{{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_0x{{ condition.deltaEtaOrm.lower|X14|lower }}_0x{{ condition.deltaEtaOrm.upper|X14|lower }},         
    {%- endif %}            
    {%- if condition.deltaPhiOrm.enabled == "true" %} 
            dphi_ovrm => comp_dphi_{{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_0x{{ condition.deltaPhiOrm.lower|X14|lower }}_0x{{ condition.deltaPhiOrm.upper|X14|lower }},        
    {%- endif %}            
    {%- if condition.deltaROrm.enabled == "true" %} 
            dr_ovrm => comp_dr_{{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_0x{{ condition.deltaROrm.lower|X14|lower }}_0x{{ condition.deltaROrm.upper|X14|lower }},        
    {%- endif %}            
  {%- elif condition.nr_objects == 3 %}  
    {%- if condition.deltaEtaOrm.enabled == "true" %} 
            deta_ovrm => comp_deta_{{ o1.type|lower }}_{{ o3.type|lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_0x{{ condition.deltaEtaOrm.lower|X14|lower }}_0x{{ condition.deltaEtaOrm.upper|X14|lower }},         
    {%- endif %}            
    {%- if condition.deltaPhiOrm.enabled == "true" %} 
            dphi_ovrm => comp_dphi_{{ o1.type|lower }}_{{ o3.type|lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_0x{{ condition.deltaPhiOrm.lower|X14|lower }}_0x{{ condition.deltaPhiOrm.upper|X14|lower }},        
    {%- endif %}            
    {%- if condition.deltaROrm.enabled == "true" %} 
            dr_ovrm => comp_dr_{{ o1.type|lower }}_{{ o3.type|lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_0x{{ condition.deltaROrm.lower|X14|lower }}_0x{{ condition.deltaROrm.upper|X14|lower }},        
    {%- endif %}            
  {%- elif condition.nr_objects == 4 %}
    {%- if condition.deltaEtaOrm.enabled == "true" %} 
            deta_ovrm => comp_deta_{{ o1.type|lower }}_{{ o4.type|lower }}_bx_{{ o1.bx }}_bx_{{ o4.bx }}_0x{{ condition.deltaEtaOrm.lower|X14|lower }}_0x{{ condition.deltaEtaOrm.upper|X14|lower }},         
    {%- endif %}            
    {%- if condition.deltaPhiOrm.enabled == "true" %} 
            dphi_ovrm => comp_dphi_{{ o1.type|lower }}_{{ o4.type|lower }}_bx_{{ o1.bx }}_bx_{{ o4.bx }}_0x{{ condition.deltaPhiOrm.lower|X14|lower }}_0x{{ condition.deltaPhiOrm.upper|X14|lower }},        
    {%- endif %}            
    {%- if condition.deltaROrm.enabled == "true" %} 
            dr_ovrm => comp_dr_{{ o1.type|lower }}_{{ o4.type|lower }}_bx_{{ o1.bx }}_bx_{{ o4.bx }}_0x{{ condition.deltaROrm.lower|X14|lower }}_0x{{ condition.deltaROrm.upper|X14|lower }},        
    {%- endif %}            
  {%- elif condition.nr_objects == 5 %}
    {%- if condition.deltaEtaOrm.enabled == "true" %} 
            deta_ovrm => comp_deta_{{ o1.type|lower }}_{{ o5.type|lower }}_bx_{{ o1.bx }}_bx_{{ o5.bx }}_0x{{ condition.deltaEtaOrm.lower|X14|lower }}_0x{{ condition.deltaEtaOrm.upper|X14|lower }},         
    {%- endif %}            
    {%- if condition.deltaPhiOrm.enabled == "true" %} 
            dphi_ovrm => comp_dphi_{{ o1.type|lower }}_{{ o5.type|lower }}_bx_{{ o1.bx }}_bx_{{ o5.bx }}_0x{{ condition.deltaPhiOrm.lower|X14|lower }}_0x{{ condition.deltaPhiOrm.upper|X14|lower }},        
    {%- endif %}            
    {%- if condition.deltaROrm.enabled == "true" %} 
            dr_ovrm => comp_dr_{{ o1.type|lower }}_{{ o5.type|lower }}_bx_{{ o1.bx }}_bx_{{ o5.bx }}_0x{{ condition.deltaROrm.lower|X14|lower }}_0x{{ condition.deltaROrm.upper|X14|lower }},        
    {%- endif %}            
  {%- endif %}
            cond_o => {{ condition.vhdl_signal }}
        );
{% endblock instantiate_combinatorial_conditions_ovrm %}
{# eof #}
