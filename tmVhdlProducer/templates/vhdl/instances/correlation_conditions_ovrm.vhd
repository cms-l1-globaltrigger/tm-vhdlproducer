{%- block instantiate_correlation_conditions_ovrm %}
  {%- set o1 = condition.objects[0] %}
  {%- set o2 = condition.objects[1] %}
  {%- set o3 = condition.objects[2] %}
    cond_{{ condition.vhdl_signal }}_i: entity work.correlation_conditions_ovrm
        generic map(
  {%- if o1.type == o2.type %}  
            N_{{ o1.type|upper }}_OBJECTS, N_{{ o2.type|upper }}_OBJECTS,  N_{{ o3.type|upper }}_OBJECTS,
            (({{ o1.sliceLow }},{{ o1.sliceHigh }}), ({{ o2.sliceLow }},{{ o2.sliceHigh }}), ({{ o3.sliceLow }},{{ o3.sliceHigh }}), (0,0)),
  {%- else %}  
            N_{{ o1.type|upper }}_OBJECTS, N_{{ o1.type|upper }}_OBJECTS,  N_{{ o2.type|upper }}_OBJECTS,
            (({{ o1.sliceLow }},{{ o1.sliceHigh }}), ({{ o1.sliceLow }},{{ o1.sliceHigh }}), ({{ o2.sliceLow }},{{ o2.sliceHigh }}), (0,0)),  
  {%- endif %}
  {%- if condition.chargeCorrelation in ('os', 'ls') %}
            true,
  {%- else %}
            false,
  {%- endif %}
  {%- if o1.type == o2.type %}  
            true
  {%- else %}  
            false
  {%- endif %}
        )
        port map(
            lhc_clk, 
  {%- if o1.type == o2.type %}  
    {%- with obj = o1 %}
            in_1 => {% include "helper/helper_comb_and_calos_signals_names.txt" %}
    {%- endwith %}
    {%- with obj = o2 %}
            in_2 => {% include "helper/helper_comb_and_calos_signals_names.txt" %}
    {%- endwith %}
    {%- with obj = o3 %}
            in_3 => {% include "helper/helper_comb_and_calos_signals_names.txt" %}
    {%- endwith %}
  {%- else %}  
    {%- with obj = o1 %}
            in_1 => {% include "helper/helper_comb_and_calos_signals_names.txt" %}
    {%- endwith %}
    {%- with obj = o2 %}
            in_2 => {% include "helper/helper_comb_and_calos_signals_names.txt" %}
    {%- endwith %}
  {%- endif %}
  {%- if condition.deltaEta.enabled == "true" %} 
            deta => comp_deta_{{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_0x{{ condition.deltaEta.lower|X14|lower }}_0x{{ condition.deltaEta.upper|X14|lower }},         
  {%- endif %}            
  {%- if condition.deltaPhi.enabled == "true" %} 
            dphi => comp_dphi_{{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_0x{{ condition.deltaPhi.lower|X14|lower }}_0x{{ condition.deltaPhi.upper|X14|lower }},        
  {%- endif %}            
  {%- if condition.deltaR.enabled == "true" %} 
            delta_r => comp_dr_{{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_0x{{ condition.deltaR.lower|X14|lower }}_0x{{ condition.deltaR.upper|X14|lower }},        
  {%- endif %}            
  {%- if condition.mass.enabled == "true" %} 
    {%- if condition.mass.type == 0 %} 
            inv_mass => comp_invmass_{{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_0x{{ condition.mass.lower|X14|lower }}_0x{{ condition.mass.upper|X14|lower }},
    {%- endif %}            
    {%- if condition.mass.type == 1 %} 
            trans_mass => comp_transmass_{{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_0x{{ condition.mass.lower|X14|lower }}_0x{{ condition.mass.upper|X14|lower }},
    {%- endif %}
  {%- endif %}
  {%- if condition.twoBodyPt.enabled == "true" %} 
            tbpt => comp_tbpt_{{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_0x{{ condition.twoBodyPt.threshold|X14|lower }},     
  {%- endif %}            
  {%- if condition.chargeCorrelation in ('os', 'ls') %}
            charge_corr_double => comp_cc_double_bx_{{ o1.bx }}_bx_{{ o2.bx }}_{{ condition.chargeCorrelation }},
  {%- endif %}
  {%- if o1.type == o2.type %}  
    {%- if condition.deltaEtaOrm.enabled == "true" %} 
            deta_ovrm => comp_deta_{{ o1.type|lower }}_{{ o3.type|lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_0x{{ condition.deltaEtaOrm.lower|X14|lower }}_0x{{ condition.deltaEtaOrm.upper|X14|lower }},         
    {%- endif %}            
    {%- if condition.deltaPhiOrm.enabled == "true" %} 
            dphi_ovrm => comp_dphi_{{ o1.type|lower }}_{{ o3.type|lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_0x{{ condition.deltaPhiOrm.lower|X14|lower }}_0x{{ condition.deltaPhiOrm.upper|X14|lower }},        
    {%- endif %}            
    {%- if condition.deltaROrm.enabled == "true" %} 
            dr_ovrm => comp_dr_{{ o1.type|lower }}_{{ o3.type|lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_0x{{ condition.deltaROrm.lower|X14|lower }}_0x{{ condition.deltaROrm.upper|X14|lower }},        
    {%- endif %}            
  {%- else %}  
    {%- if condition.deltaEtaOrm.enabled == "true" %} 
            deta_ovrm => comp_deta_{{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_0x{{ condition.deltaEtaOrm.lower|X14|lower }}_0x{{ condition.deltaEtaOrm.upper|X14|lower }},         
    {%- endif %}            
    {%- if condition.deltaPhiOrm.enabled == "true" %} 
            dphi_ovrm => comp_dphi_{{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_0x{{ condition.deltaPhiOrm.lower|X14|lower }}_0x{{ condition.deltaPhiOrm.upper|X14|lower }},        
    {%- endif %}            
    {%- if condition.deltaROrm.enabled == "true" %} 
            dr_ovrm => comp_dr_{{ o1.type|lower }}_{{ o2.type|lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_0x{{ condition.deltaROrm.lower|X14|lower }}_0x{{ condition.deltaROrm.upper|X14|lower }},        
    {%- endif %}            
  {%- endif %}
            cond_o => {{ condition.vhdl_signal }}
        );
{%- endblock instantiate_correlation_conditions_ovrm %}
