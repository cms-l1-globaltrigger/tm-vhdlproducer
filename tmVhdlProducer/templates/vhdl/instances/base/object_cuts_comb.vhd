  {%- for i in range(0,condition.nr_objects) %}
    {%- if condition.nr_objects > i %}
      {%- if condition.objects[i].slice %}
        slice_{{i+1}}_low_obj1 => {{ condition.objects[i].slice.lower }},
        slice_{{i+1}}_high_obj1 => {{ condition.objects[i].slice.upper }},
      {%- elif not condition.objects[i].slice and condition.objects[i].is_calo_type %}
        {%- if i == 0 -%}
-- setting slice high value(s) instead of default value(s) ("NR_MU_OBJECTS-1" => 7)
        {%- endif %}
        slice_{{i+1}}_high_obj1 => {{ condition.objects[i].slice.upper }},
      {%- elif not condition.objects[i].slice and condition.objects[i].is_muon_type %}
        {%- if i == 0 -%}
-- no slice requirements
        {%- endif %}
      {%- endif %}
    {%- endif %}
  {%- endfor %}
-- object cuts
  {%- if not o1.operator %}
        pt_ge_mode_obj1 => {{ o1.operator | vhdl_bool }},
  {%- endif %}
        pt_thresholds_obj1 => (X"{{ o1.threshold | X04 }}", X"{{ o2.threshold | X04 }}", X"{{ o3.threshold | X04 }}", X"{{ o4.threshold | X04 }}"),
  {%- set max_eta_cuts = [condition.objects[0].etaNrCuts, condition.objects[1].etaNrCuts, condition.objects[2].etaNrCuts, condition.objects[3].etaNrCuts] | max %}
  {%- if o1.etaNrCuts > 0 or o2.etaNrCuts > 0 or o3.etaNrCuts > 0 or o4.etaNrCuts > 0 %}
        nr_eta_windows_obj1 => ({{ o1.etaNrCuts }}, {{ o2.etaNrCuts }}, {{ o3.etaNrCuts }}, {{ o4.etaNrCuts }}),
  {%- endif %}
  {%- for i in range(0,max_eta_cuts) %}
    {%- if o1.etaNrCuts > i or o2.etaNrCuts > i or o3.etaNrCuts > i or o4.etaNrCuts > i %}
        eta_w{{i+1}}_upper_limits_obj1 => (X"{{ o1.etaUpperLimit[i] | X04 }}", X"{{ o2.etaUpperLimit[i] | X04 }}", X"{{ o3.etaUpperLimit[i] | X04}}", X"{{ o4.etaUpperLimit[i] | X04 }}"),
        eta_w{{i+1}}_lower_limits_obj1 => (X"{{ o1.etaLowerLimit[i] | X04 }}", X"{{ o2.etaLowerLimit[i] | X04 }}", X"{{ o3.etaLowerLimit[i] | X04 }}", X"{{ o4.etaLowerLimit[i] | X04 }}"),
    {%- endif %}
  {%- endfor %}
  {%- set max_phi_cuts = [condition.objects[0].phiNrCuts, condition.objects[1].phiNrCuts, condition.objects[2].phiNrCuts, condition.objects[3].phiNrCuts] | max %}
  {%- if o1.phiNrCuts > 0 or o2.phiNrCuts > 0 or o3.phiNrCuts > 0 or o4.phiNrCuts > 0 %}
        nr_phi_windows_obj1 => ({{ o1.phiNrCuts }}, {{ o2.phiNrCuts }}, {{ o3.phiNrCuts }}, {{ o4.phiNrCuts }}),
  {%- endif %}
  {%- for i in range(0,max_phi_cuts) %}
    {%- if o1.phiNrCuts > i or o2.phiNrCuts > i or o3.phiNrCuts > i or o4.phiNrCuts > i %}
        phi_w{{i+1}}_upper_limits_obj1 => (X"{{ o1.phiUpperLimit[i] | X04 }}", X"{{ o2.phiUpperLimit[i] | X04 }}", X"{{ o3.phiUpperLimit[i] | X04}}", X"{{ o4.phiUpperLimit[i] | X04 }}"),
        phi_w{{i+1}}_lower_limits_obj1 => (X"{{ o1.phiLowerLimit[i] | X04 }}", X"{{ o2.phiLowerLimit[i] | X04 }}", X"{{ o3.phiLowerLimit[i] | X04 }}", X"{{ o4.phiLowerLimit[i] | X04 }}"),
    {%- endif %}
  {%- endfor %}
  {%- if (o1.isolation) or (o2.isolation) or (o3.isolation) or (o4.isolation) %}
        iso_luts_obj1 => (X"{{ o1.isolation.value | X01 }}", X"{{ o2.isolation.value | X01 }}", X"{{ o3.isolation.value | X01 }}", X"{{ o4.isolation.value | X01 }}"),
  {%- endif %}
  {%- if (o1.displaced) or (o2.displaced) or (o3.displaced) or (o4.displaced) %}
        disp_cuts_obj1 => ({{ o1.displaced | vhdl_bool }}, {{ o2.displaced | vhdl_bool }}, {{ o3.displaced | vhdl_bool }}, {{ o4.displaced | vhdl_bool }}),
        disp_requs_obj1 => ({{ o1.displaced.state | vhdl_bool }}, {{ o2.displaced.state | vhdl_bool}}, {{ o3.displaced.state | vhdl_bool}}, {{ o4.displaced.state | vhdl_bool}}),
  {% endif %}
  {%- if (o1.charge) or (o2.charge) or (o3.charge) or (o4.charge) %}
        requested_charges_obj1 => ("{{ o1.charge.value }}", "{{ o2.charge.value }}", "{{ o3.charge.value }}", "{{ o4.charge.value }}"),
  {%- endif %}
  {%- if (o1.quality) or (o2.quality) or (o3.quality) or (o4.quality) %}
        qual_luts_obj1 => (X"{{ o1.quality.value | X04 }}", X"{{ o2.quality.value | X04 }}", X"{{ o3.quality.value | X04 }}", X"{{ o4.quality.value | X04 }}"),
  {%- endif %}
  {%- if (o1.upt) or (o2.upt) or (o3.upt) or (o4.upt) %}
        upt_cuts_obj1 => ({{ o1.upt | vhdl_bool }}, {{ o2.upt | vhdl_bool }}, {{ o3.upt | vhdl_bool }}, {{ o4.upt | vhdl_bool }}),
        upt_upper_limits_obj1 => (X"{{ o1.upt.upper | X04 }}", X"{{ o2.upt.upper | X04 }}", X"{{ o3.upt.upper | X04 }}", X"{{ o4.upt.upper | X04 }}"),
        upt_lower_limits_obj1 => (X"{{ o1.upt.lower | X04 }}", X"{{ o2.upt.lower | X04 }}", X"{{ o3.upt.lower | X04 }}", X"{{ o4.upt.lower | X04 }}"),
  {%- endif %}
  {%- if (o1.impactParameter) or (o2.impactParameter) or (o3.impactParameter) or (o4.impactParameter) %}
        ip_luts_obj1 => (X"{{ o1.impactParameter.value | X01 }}", X"{{ o2.impactParameter.value | X01 }}", X"{{ o3.impactParameter.value | X01 }}", X"{{ o4.impactParameter.value | X01 }}"),
  {%- endif %}
