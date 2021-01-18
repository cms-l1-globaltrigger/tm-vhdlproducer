{%- if o.is_muon_type %}
  {%- set obj = "muon" %}
{%- elif o.is_calo_type %}
  {%- set obj = "calo" %}
{%- endif %}
  {%- if o.slice %}
        {{ obj }}_object_low => {{ o.slice.lower }},
        {{ obj }}_object_high => {{ o.slice.upper }},
  {%- endif %}
  {%- if not o.operator %}
        pt_ge_mode_{{ obj }} => {{ o.operator | vhdl_bool }},
  {%- endif %}
  {%- if o.is_calo_type %}
        obj_type_{{ obj }} => {{ o.type | upper }}_TYPE,
  {%- endif %}
        pt_threshold_{{ obj }} => X"{{ o.threshold | X04 }}",
  {%- if o.etaNrCuts > 0 %}
        nr_eta_windows_{{ obj }} => {{ o.etaNrCuts }},
  {%- endif %}
  {%- for j in range(0, o.etaNrCuts) %}
    {%- if o.etaNrCuts > j %}
        eta_w{{ j+1 }}_upper_limit_{{ obj }} => X"{{ o.etaUpperLimit[j] | X04 }}",
        eta_w{{ j+1 }}_lower_limit_{{ obj }} => X"{{ o.etaLowerLimit[j] | X04 }}",
    {%- endif %}
  {%- endfor %}
  {%- if o.phiNrCuts > 0 %}
        phi_full_range_{{ obj }} => {{ o.phiFullRange | vhdl_bool }},
        phi_w1_upper_limit_{{ obj }} => X"{{ o.phiW1.upper | X04 }}",
        phi_w1_lower_limit_{{ obj }} => X"{{ o.phiW1.lower | X04 }}",
  {%- endif %}
  {%- if o.phiNrCuts > 1 %}
        phi_w2_ignore_{{ obj }} => {{ o.phiW2Ignore | vhdl_bool }},
        phi_w2_upper_limit_{{ obj }} => X"{{ o.phiW2.upper | X04 }}",
        phi_w2_lower_limit_{{ obj }} => X"{{ o.phiW2.lower | X04 }}",
  {%- endif %}
  {%- if o.charge %}
        requested_charge_{{ obj }} => "{{ o.charge.value }}",
  {%- endif %}
  {%- if o.quality %}
        qual_lut_{{ obj }} => X"{{ o.quality.value | X04 }}",
  {%- endif %}
  {%- if o.isolation %}
        iso_lut_{{ obj }} => X"{{ o.isolation.value | X01 }}",
  {%- endif %}
  {%- if o.upt %}
        upt_cut_{{ obj }} => {{ o.upt | vhdl_bool }},
        upt_upper_limit_{{ obj }} => X"{{ o.upt.upper | X04 }}",
        upt_lower_limit_{{ obj }} => X"{{ o.upt.lower | X04 }}",
  {%- endif %}
  {%- if o.impactParameter %}
        ip_lut_{{ obj }} => X"{{ o.impactParameter.value | X01 }}",
  {%- endif %}
