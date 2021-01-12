{%- block object_cuts_comb %}
  {%- for i in range(0,condition.nr_objects) %}
    {%- if condition.nr_objects > i and condition.objects[i].slice  %}
        object_slice_{{ i+1 }}_low => {{ condition.objects[i].slice.lower }},
        object_slice_{{ i+1 }}_high => {{ condition.objects[i].slice.upper }},
    {%- endif %}
  {%- endfor %}
        -- object cuts
  {%- if not condition.objects[0].operator %}
        pt_ge_mode => {{ condition.objects[0].operator | vhdl_bool }},
  {%- endif %}
  {%- if condition.objects[0].is_calo_type %}
        obj_type => {{ condition.objects[0].type }}_TYPE,
  {%- endif %}
        pt_thresholds => (X"{{ condition.objects[0].threshold | X04 }}", X"{{ condition.objects[1].threshold | X04 }}", X"{{ condition.objects[2].threshold | X04 }}", X"{{ condition.objects[3].threshold | X04 }}"),
  {%- set max_eta_cuts = [condition.objects[0].etaNrCuts, condition.objects[1].etaNrCuts, condition.objects[2].etaNrCuts, condition.objects[3].etaNrCuts]|max %}
  {%- if o1.etaNrCuts > 0 or o2.etaNrCuts > 0 or o3.etaNrCuts > 0 or o4.etaNrCuts > 0 %}
        nr_eta_windows => ({{ o1.etaNrCuts }}, {{ o2.etaNrCuts }}, {{ o3.etaNrCuts }}, {{ o4.etaNrCuts }}),
  {%- endif %}
  {%- for i in range(0,max_eta_cuts) %}
    {%- if o1.etaNrCuts > i or o2.etaNrCuts > i or o3.etaNrCuts > i or o4.etaNrCuts > i %}
        eta_w{{ i+1 }}_upper_limits => (X"{{ o1.etaUpperLimit[i] | X04 }}", X"{{ o2.etaUpperLimit[i] | X04 }}", X"{{ o3.etaUpperLimit[i] | X04 }}", X"{{ o4.etaUpperLimit[i] | X04 }}"),
        eta_w{{ i+1 }}_lower_limits => (X"{{ o1.etaLowerLimit[i] | X04 }}", X"{{ o2.etaLowerLimit[i] | X04 }}", X"{{ o3.etaLowerLimit[i] | X04 }}", X"{{ o4.etaLowerLimit[i] | X04 }}"),
    {%- endif %}
  {%- endfor %}
  {%- if o1.phiNrCuts > 0 or o2.phiNrCuts > 0 or o3.phiNrCuts > 0 or o4.phiNrCuts > 0 %}
        phi_full_range => ({{ o1.phiFullRange | vhdl_bool }}, {{ o2.phiFullRange | vhdl_bool }}, {{ o3.phiFullRange | vhdl_bool }}, {{ o4.phiFullRange | vhdl_bool }}),
        phi_w1_upper_limits => (X"{{ o1.phiW1.upper | X04 }}", X"{{ o2.phiW1.upper | X04 }}", X"{{ o3.phiW1.upper | X04 }}", X"{{ o4.phiW1.upper | X04 }}"),
        phi_w1_lower_limits => (X"{{ o1.phiW1.lower | X04 }}", X"{{ o2.phiW1.lower | X04 }}", X"{{ o3.phiW1.lower | X04 }}", X"{{ o4.phiW1.lower | X04 }}"),
  {%- endif %}
  {%- if o1.phiNrCuts > 1 or o2.phiNrCuts > 1 or o3.phiNrCuts > 1 or o4.phiNrCuts > 1 %}
        phi_w2_ignore => ({{ o1.phiW2Ignore | vhdl_bool }}, {{ o2.phiW2Ignore | vhdl_bool }}, {{ o3.phiW2Ignore | vhdl_bool }}, {{ o4.phiW2Ignore | vhdl_bool }}),
        phi_w2_upper_limits => (X"{{ o1.phiW2.upper | X04 }}", X"{{ o2.phiW2.upper | X04 }}", X"{{ o3.phiW2.upper | X04 }}", X"{{ o4.phiW2.upper | X04 }}"),
        phi_w2_lower_limits => (X"{{ o1.phiW2.lower | X04 }}", X"{{ o2.phiW2.lower | X04 }}", X"{{ o3.phiW2.lower | X04 }}", X"{{ o4.phiW2.lower | X04 }}"),
  {%- endif %}
  {%- if o1.charge or o2.charge or o3.charge or o4.charge %}
        requested_charges => ("{{ o1.charge.value }}", "{{ o2.charge.value }}", "{{ o3.charge.value }}", "{{ o4.charge.value }}"),
  {%- endif %}
  {%- if o1.quality or o2.quality or o3.quality or o4.quality %}
        qual_luts => (X"{{ o1.quality.value | X04 }}", X"{{ o2.quality.value | X04 }}", X"{{ o3.quality.value | X04 }}", X"{{ o4.quality.value | X04 }}"),
  {%- endif %}
  {%- if o1.isolation or o2.isolation or o3.isolation or o4.isolation %}
        iso_luts => (X"{{ o1.isolation.value | X01 }}", X"{{ o2.isolation.value | X01 }}", X"{{ o3.isolation.value | X01 }}", X"{{ o4.isolation.value | X01 }}"),
  {%- endif %}
  {%- if o1.upt or o2.upt or o3.upt or o4.upt %}
        upt_cuts => ({{ o1.upt | vhdl_bool }}, {{ o2.upt | vhdl_bool }}, {{ o3.upt | vhdl_bool }}, {{ o4.upt | vhdl_bool }}),
        upt_upper_limits => (X"{{ o1.upt.upper | X04 }}", X"{{ o2.upt.upper | X04 }}", X"{{ o3.upt.upper | X04 }}", X"{{ o4.upt.upper | X04 }}"),
        upt_lower_limits => (X"{{ o1.upt.lower | X04 }}", X"{{ o2.upt.lower | X04 }}", X"{{ o3.upt.lower | X04 }}", X"{{ o4.upt.lower | X04 }}"),
  {%- endif %}
  {%- if o1.impactParameter or o2.impactParameter or o3.impactParameter or o4.impactParameter %}
        ip_luts => (X"{{ o1.impactParameter.value | X01 }}", X"{{ o2.impactParameter.value | X01 }}", X"{{ o3.impactParameter.value | X01 }}", X"{{ o4.impactParameter.value | X01 }}"),
  {%- endif %}
{%- endblock object_cuts_comb %}
