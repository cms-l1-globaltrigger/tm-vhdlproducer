{%- block condition_base %}
  {%- set o1 = condition.objects[0] %}
  {%- set o2 = condition.objects[1] %}
  {%- set o3 = condition.objects[2] %}
  {%- set o4 = condition.objects[3] %}
  {%- block entity %}
  {%- endblock entity %}
    generic map(
  {%- block generic_beg %}
  {%- endblock generic_beg %}
  {%- for i in range(0,condition.nr_objects) %}
    {%- if condition.nr_objects > i and condition.objects[i].hasSlice  %}
        slice_{{i+1}}_low_obj1 => {{ condition.objects[i].sliceLow }}, 
        slice_{{i+1}}_high_obj1 => {{ condition.objects[i].sliceHigh }}, 
    {%- endif %}        
  {%- endfor %}
-- object cuts
  {%- if not condition.objects[0].operator %}
        pt_ge_mode_obj1 => {{ condition.objects[0].operator|vhdl_bool }}, 
  {%- endif %}        
        pt_thresholds_obj1 => (X"{{ condition.objects[0].threshold|X04 }}", X"{{ condition.objects[1].threshold|X04 }}", X"{{ condition.objects[2].threshold|X04 }}", X"{{ condition.objects[3].threshold|X04 }}"),
  {%- set max_eta_cuts = [condition.objects[0].etaNrCuts, condition.objects[1].etaNrCuts, condition.objects[2].etaNrCuts, condition.objects[3].etaNrCuts]|max %}  
  {%- if o1.etaNrCuts > 0 or o2.etaNrCuts > 0 or o3.etaNrCuts > 0 or o4.etaNrCuts > 0 %}
        nr_eta_windows_obj1 => ({{ o1.etaNrCuts }}, {{ o2.etaNrCuts }}, {{ o3.etaNrCuts }}, {{ o4.etaNrCuts }}),
  {%- endif %}        
  {%- for i in range(0,max_eta_cuts) %}
    {%- if o1.etaNrCuts > i or o2.etaNrCuts > i or o3.etaNrCuts > i or o4.etaNrCuts > i %}
        eta_w{{i+1}}_upper_limits_obj1 => (X"{{ o1.etaUpperLimit[i]|X04 }}", X"{{ o2.etaUpperLimit[i]|X04 }}", X"{{ o3.etaUpperLimit[i]|X04}}", X"{{ o4.etaUpperLimit[i]|X04 }}"), 
        eta_w{{i+1}}_lower_limits_obj1 => (X"{{ o1.etaLowerLimit[i]|X04 }}", X"{{ o2.etaLowerLimit[i]|X04 }}", X"{{ o3.etaLowerLimit[i]|X04 }}", X"{{ o4.etaLowerLimit[i]|X04 }}"),
    {%- endif %}        
  {%- endfor %}
  {%- set max_phi_cuts = [condition.objects[0].phiNrCuts, condition.objects[1].phiNrCuts, condition.objects[2].phiNrCuts, condition.objects[3].phiNrCuts]|max %}  
  {%- if o1.phiNrCuts > 0 or o2.phiNrCuts > 0 or o3.phiNrCuts > 0 or o4.phiNrCuts > 0 %}
        nr_phi_windows_obj1 => ({{ o1.phiNrCuts }}, {{ o2.phiNrCuts }}, {{ o3.phiNrCuts }}, {{ o4.phiNrCuts }}),
  {%- endif %}        
  {%- for i in range(0,max_phi_cuts) %}
    {%- if o1.phiNrCuts > 0 or o2.phiNrCuts > 0 or o3.phiNrCuts > 0 or o4.phiNrCuts > 0 %}
        phi_w{{i+1}}_upper_limits_obj1 => (X"{{ o1.phiW1UpperLimit|X04 }}", X"{{ o2.phiW1UpperLimit|X04 }}", X"{{ o3.phiW1UpperLimit|X04 }}", X"{{ o4.phiW1UpperLimit|X04 }}"), 
        phi_w{{i+1}}_lower_limits_obj1 => (X"{{ o1.phiW1LowerLimit|X04 }}", X"{{ o2.phiW1LowerLimit|X04 }}", X"{{ o3.phiW1LowerLimit|X04 }}", X"{{ o4.phiW1LowerLimit|X04 }}"),
    {%- endif %}        
  {%- endfor %}
  {%- if (o1.hasIsolation) or (o2.hasIsolation) or (o3.hasIsolation) or (o4.hasIsolation) %}
        iso_luts_obj1 => (X"{{ o1.isolationLUT|X01 }}", X"{{ o2.isolationLUT|X01 }}", X"{{ o3.isolationLUT|X01 }}", X"{{ o4.isolationLUT|X01 }}"),
  {%- endif %}        
  {%- if o1.is_muon_type %}
    {%- if (o1.hasCharge) or (o2.hasCharge) or (o3.hasCharge) or (o4.hasCharge) %}
        requested_charges_obj1 => ("{{ o1.charge }}", "{{ o2.charge }}", "{{ o3.charge }}", "{{ o4.charge }}"), 
    {%- endif %}        
    {%- if (o1.hasQuality) or (o2.hasQuality) or (o3.hasQuality) or (o4.hasQuality) %}
        qual_luts_obj1 => (X"{{ o1.qualityLUT|X04 }}", X"{{ o2.qualityLUT|X04 }}", X"{{ o3.qualityLUT|X04 }}", X"{{ o4.qualityLUT|X04 }}"), 
    {%- endif %}        
    {%- if (o1.hasUpt) or (o2.hasUpt) or (o3.hasUpt) or (o4.hasUpt) %}
        upt_cuts => ({{ o1.hasUpt|vhdl_bool }}, {{ o2.hasUpt|vhdl_bool }}, {{ o3.hasUpt|vhdl_bool }}, {{ o4.hasUpt|vhdl_bool }}), 
        upt_upper_limits_obj1 => (X"{{ o1.uptUpperLimit|X04 }}", X"{{ o2.uptUpperLimit|X04 }}", X"{{ o3.uptUpperLimit|X04 }}", X"{{ o4.uptUpperLimit|X04 }}"),
        upt_lower_limits_obj1 => (X"{{ o1.uptLowerLimit|X04 }}", X"{{ o2.uptLowerLimit|X04 }}", X"{{ o3.uptLowerLimit|X04 }}", X"{{ o4.uptLowerLimit|X04 }}"), 
    {%- endif %}        
    {%- if (o1.hasImpactParameter) or (o2.hasImpactParameter) or (o3.hasImpactParameter) or (o4.hasImpactParameter) %}
        ip_luts_obj1 => (X"{{ o1.impactParameterLUT|X01 }}", X"{{ o2.impactParameterLUT|X01 }}", X"{{ o3.impactParameterLUT|X01 }}", X"{{ o4.impactParameterLUT|X01 }}"), 
    {%- endif %}        
    {%- if condition.chargeCorrelation  %}
        requested_charge_correlation => "{{ condition.chargeCorrelation }}",
    {%- endif %}        
  {%- block correlation_cuts %}
    {%- if condition.hasTwoBodyPt %}
-- correlation cuts
        twobody_pt_cut => true, 
        pt_width => {{ o1.type|upper }}_PT_VECTOR_WIDTH, 
        pt_sq_threshold_vector => X"{{ condition.twoBodyPt.threshold|X16 }}",
      {%- if o1.is_muon_type %}
        {%- if o1.hasTwoBodyUpt %}
        twobody_upt_cut => true, 
        upt_width => {{ o1.type|upper }}_UPT_VECTOR_WIDTH, 
        upt_sq_threshold_vector => X"{{ condition.twoBodyUpt.threshold|X16 }}",
        sin_cos_width => MUON_SIN_COS_VECTOR_WIDTH, 
        {%- endif %} 
      {%- elif o1.is_calo_type %}        
        sin_cos_width => CALO_SIN_COS_VECTOR_WIDTH, 
      {%- endif %} 
        pt_sq_sin_cos_precision => {{ o1.type|upper }}_{{ o1.type|upper }}_SIN_COS_PRECISION,
    {%- endif %}
  {%- endblock correlation_cuts %}
  {%- block generic_end %}
--
    {%- if o1.is_calo_type %}        
        type_obj1 => {{ o1.type|upper }}_TYPE, 
    {%- endif %} 
        nr_templates => {{ condition.nr_objects }}
  {%- endblock generic_end %}
    )
    port map(
  {%- block port %}
  {%- endblock port %}
    );
{%- endblock condition_base %}
{# eof #}
