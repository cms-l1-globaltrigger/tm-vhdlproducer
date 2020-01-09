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
            comb_1 => comb_a,
  {%- if condition.nr_objects == 3 %}
            comb_2 => comb_b,
  {%- elif condition.nr_objects == 4 %}
            comb_2 => comb_b,
            comb_3 => comb_c,
  {%- elif condition.nr_objects == 5 %}
            comb_2 => comb_b,
            comb_3 => comb_c,
            comb_4 => comb_d,
  {%- endif %}
            comb_ovrm => comb_ovrm,            
  {%- if condition.twoBodyPt.enabled == "true" %}
            tbpt => tbpt,        
  {%- endif %}
  {%- if condition.chargeCorrelation in ('os', 'ls') %}
    {%- if condition.nr_objects == 2 %}
            charge_corr_double => cc_double__index_comp_cc_double,
    {%- elif condition.nr_objects == 3 %}
            charge_corr_triple => cc_triple__index_comp_cc_triple,
    {%- elif condition.nr_objects == 4 %}
            charge_corr_quad => cc_quad__index_comp_cc_quad,
    {%- endif %}
  {%- endif %}
  {%- if condition.nr_objects == 2 %}  
    {%- if condition.deltaEtaOrm.enabled == "true" %}
            deta_ovrm => deta_{{ o1.type|lower }}_{{ o2.type|lower }}__index_comp_deta,         
    {%- endif %}            
    {%- if condition.deltaPhiOrm.enabled == "true" %}
            dphi_ovrm => dphi_{{ o1.type|lower }}_{{ o2.type|lower }}__index_comp_dphi,        
    {%- endif %}            
    {%- if condition.deltaROrm.enabled == "true" %}
            dr_ovrm => dr_{{ o1.type|lower }}_{{ o2.type|lower }}__index_comp_dr,        
    {%- endif %}            
  {%- elif condition.nr_objects == 3 %}  
    {%- if condition.deltaEtaOrm.enabled == "true" %}
            deta_ovrm => deta_{{ o1.type|lower }}_{{ o3.type|lower }}__index_comp_deta,         
    {%- endif %}            
    {%- if condition.deltaPhiOrm.enabled == "true" %}
            dphi_ovrm => dphi_{{ o1.type|lower }}_{{ o3.type|lower }}__index_comp_dphi,        
    {%- endif %}            
    {%- if condition.deltaROrm.enabled == "true" %}
            dr_ovrm => dr_{{ o1.type|lower }}_{{ o3.type|lower }}__index_comp_dr,        
    {%- endif %}            
  {%- elif condition.nr_objects == 4 %}
    {%- if condition.deltaEtaOrm.enabled == "true" %}
            deta_ovrm => deta_{{ o1.type|lower }}_{{ o4.type|lower }}__index_comp_deta,         
    {%- endif %}            
    {%- if condition.deltaPhiOrm.enabled == "true" %}
            dphi_ovrm => dphi_{{ o1.type|lower }}_{{ o4.type|lower }}__index_comp_dphi,        
    {%- endif %}            
    {%- if condition.deltaROrm.enabled == "true" %}
            dr_ovrm => dr_{{ o1.type|lower }}_{{ o4.type|lower }}__index_comp_dr,        
    {%- endif %}            
  {%- elif condition.nr_objects == 5 %}
    {%- if condition.deltaEtaOrm.enabled == "true" %}
            deta_ovrm => deta_{{ o1.type|lower }}_{{ o5.type|lower }}__index_comp_deta,         
    {%- endif %}            
    {%- if condition.deltaPhiOrm.enabled == "true" %}
            dphi_ovrm => dphi_{{ o1.type|lower }}_{{ o5.type|lower }}__index_comp_dphi,        
    {%- endif %}            
    {%- if condition.deltaROrm.enabled == "true" %}
            dr_ovrm => dr_{{ o1.type|lower }}_{{ o5.type|lower }}__index_comp_dr,        
    {%- endif %}            
  {%- endif %}
            cond_o => {{ condition.vhdl_signal }}
        );
{% endblock instantiate_combinatorial_conditions_ovrm %}
{# eof #}
