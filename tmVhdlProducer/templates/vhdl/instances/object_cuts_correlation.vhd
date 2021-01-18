{%- if o.is_muon_type %}
  {%- set obj = "muon" %}
{%- elif o.is_calo_type %}
  {%- set obj = "calo" %}
{%- endif %}
{%- for i in range(0,condition.nr_objects) %}
  {%- set o = condition.objects[i] %}
  {%- if o.is_calo_type and i < 2 %}
        nr_calo{{ i+1 }}_objects => NR_{{ o.type | upper }}_OBJECTS,
  {%- endif %}
  {%- if o.slice %}
        {{ obj }}{{ i+1 }}_object_low => {{ o.slice.lower }},
        {{ obj }}{{ i+1 }}_object_high => {{ o.slice.upper }},
  {%- endif %}
  {%- if not o.operator %}
        pt_ge_mode_{{ obj }}{{ i+1 }} => {{ o.operator | vhdl_bool }},
  {%- endif %}
  {%- if o.is_calo_type %}
        obj_type_{{ obj }}{{ i+1 }} => {{ o.type | upper }}_TYPE,
  {%- endif %}
        pt_threshold_{{ obj }}{{ i+1 }} => X"{{ o.threshold | X04 }}",
  {%- if o.etaNrCuts > 0 %}
        nr_eta_windows_{{ obj }}{{ i+1 }} => {{ o.etaNrCuts }},
  {%- endif %}
  {%- for j in range(0,(o.etaNrCuts)) %}
    {%- if o.etaNrCuts > j %}
        eta_w{{ j+1 }}_upper_limit_{{ obj }}{{ i+1 }} => X"{{ o.etaUpperLimit[j] | X04 }}",
        eta_w{{ j+1 }}_lower_limit_{{ obj }}{{ i+1 }} => X"{{ o.etaLowerLimit[j] | X04 }}",
    {%- endif %}
  {%- endfor %}
  {%- if o.phiNrCuts > 0 %}
        phi_full_range_{{ obj }}{{ i+1 }} => {{ o.phiFullRange | vhdl_bool }},
        phi_w1_upper_limit_{{ obj }}{{ i+1 }} => X"{{ o.phiW1.upper | X04 }}",
        phi_w1_lower_limit_{{ obj }}{{ i+1 }} => X"{{ o.phiW1.lower | X04 }}",
  {%- endif %}
  {%- if o.phiNrCuts > 1 %}
        phi_w2_ignore_{{ obj }}{{ i+1 }} => {{ o.phiW2Ignore | vhdl_bool }},
        phi_w2_upper_limit_{{ obj }}{{ i+1 }} => X"{{ o.phiW2.upper | X04 }}",
        phi_w2_lower_limit_{{ obj }}{{ i+1 }} => X"{{ o.phiW2.lower | X04 }}",
  {%- endif %}
  {%- if o.charge %}
        requested_charge_{{ obj }}{{ i+1 }} => "{{ o.charge.value }}",
  {%- endif %}
  {%- if o.quality %}
        qual_lut_{{ obj }}{{ i+1 }} => X"{{ o.quality.value | X04 }}",
  {%- endif %}
  {%- if o.isolation %}
        iso_lut_{{ obj }}{{ i+1 }} => X"{{ o.isolation.value | X01 }}",
  {%- endif %}
  {%- if o.upt %}
        upt_cut_{{ obj }}{{ i+1 }} => {{ o.upt | vhdl_bool }},
        upt_upper_limit_{{ obj }}{{ i+1 }} => X"{{ o.upt.upper | X04 }}",
        upt_lower_limit_{{ obj }}{{ i+1 }} => X"{{ o.upt.lower | X04 }}",
  {%- endif %}
  {%- if o.impactParameter %}
        ip_lut_{{ obj }}{{ i+1 }} => X"{{ o.impactParameter.value | X01 }}",
  {%- endif %}
{%- endfor %}
