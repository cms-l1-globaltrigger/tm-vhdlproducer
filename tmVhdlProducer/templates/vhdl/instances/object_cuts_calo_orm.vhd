{%- block object_cuts_calo_orm %}
  {%- for i in range(1, nr_requirements) %}
    {%- set o = condition.objects[i] %}
    {%- if nr_requirements > i and o.slice %}
        object_slice_{{ i }}_low => {{ o.slice.lower }},
        object_slice_{{ i }}_high => {{ o.slice.upper }},
    {%- endif %}
  {%- endfor %}
        -- object cuts
  {%- if not o1.operator %}
        pt_ge_mode_calo1 => {{ o1.operator | vhdl_bool }},
  {%- endif %}
        obj_type_calo1 => {{ o1.type }}_TYPE,
        pt_thresholds_calo1 => ({% for o in base_objects %}{% if loop.index0 %}, {% endif %}X"{{ o.threshold | X04 }}"{% endfor %}),
  {%- set max_eta_cuts = [o1.etaNrCuts, o2.etaNrCuts, o3.etaNrCuts, o4.etaNrCuts] | max %}
  {%- if o1.etaNrCuts > 0 or o2.etaNrCuts > 0 or o3.etaNrCuts > 0 or o4.etaNrCuts > 0 %}
        nr_eta_windows => ({% for o in base_objects %}{% if loop.index0 %}, {% endif %}X"{{ o.etaNrCuts | X04 }}"{% endfor %}),
  {%- endif %}
  {%- for i in range(0, max_eta_cuts) %}
    {%- if o1.etaNrCuts > i or o2.etaNrCuts > i or o3.etaNrCuts > i or o4.etaNrCuts > i %}
        eta_w{{ i+1 }}_upper_limits => ({% for o in base_objects %}{% if loop.index0 %}, {% endif %}X"{{ o.etaUpperLimit[i] | X04 }}"{% endfor %}),
        eta_w{{ i+1 }}_lower_limits => ({% for o in base_objects %}{% if loop.index0 %}, {% endif %}X"{{ o.etaLowerLimit[i] | X04 }}"{% endfor %}),
    {%- endif %}
  {%- endfor %}
  {%- if o1.phiNrCuts > 0 or o2.phiNrCuts > 0 or o3.phiNrCuts > 0 or o4.phiNrCuts > 0 %}
        phi_full_range_calo1 => ({% for o in base_objects %}{% if loop.index0 %}, {% endif %}{{ o.phiFullRange | vhdl_bool }}{% endfor %}),
        phi_w1_upper_limits_calo1 => ({% for o in base_objects %}{% if loop.index0 %}, {% endif %}X"{{ o.phiW1.upper | X04 }}"{% endfor %}),
        phi_w1_lower_limits_calo1 => ({% for o in base_objects %}{% if loop.index0 %}, {% endif %}X"{{ o.phiW1.lower | X04 }}"{% endfor %})
  {%- endif %}
  {%- if o1.phiNrCuts > 1 or o2.phiNrCuts > 1 or o3.phiNrCuts > 1 or o4.phiNrCuts > 1 %}
        phi_w2_ignore_calo1 => ({% for o in base_objects %}{% if loop.index0 %}, {% endif %}{{ o.phiW2Ignore | vhdl_bool }}{% endfor %}),
        phi_w2_upper_limits_calo1 => ({% for o in base_objects %}{% if loop.index0 %}, {% endif %}X"{{ o.phiW2.upper | X04 }}"{% endfor %}),
        phi_w2_lower_limits_calo1 => ({% for o in base_objects %}{% if loop.index0 %}, {% endif %}X"{{ o.phiW2.lower | X04 }}"{% endfor %})
  {%- endif %}
  {%- if o1.isolation or o2.isolation or o3.isolation or o4.isolation %}
        iso_luts => ({% for o in base_objects %}{% if loop.index0 %}, {% endif %}X"{{ o.isolation | X01 }}"{% endfor %}),
  {%- endif %}
        -- orm object cuts
  {%- if not orm_obj.operator %}
        pt_ge_mode_calo2 => false,
  {%- endif %}
        obj_type_calo2 => {{ orm_obj.type | upper }}_TYPE,
        pt_threshold_calo2 => X"{{ orm_obj.threshold | X04 }}",
  {%- if orm_obj.etaNrCuts > 0 %}
        nr_eta_windows_calo2 => {{ orm_obj.etaNrCuts }},
  {%- endif %}
  {%- for j in range(0,(orm_obj.etaNrCuts)) %}
    {%- if orm_obj.etaNrCuts > j %}
        eta_w{{ j+1 }}_upper_limit_calo => X"{{ orm_obj.etaUpperLimit[j] | X04 }}",
        eta_w{{ j+1 }}_lower_limit_calo => X"{{ orm_obj.etaLowerLimit[j] | X04 }}",
    {%- endif %}
  {%- endfor %}
  {%- if orm_obj.phiNrCuts > 0 %}
        phi_full_range_calo2 => {{ orm_obj.phiFullRange | vhdl_bool }},
        phi_w1_upper_limit_calo2 => X"{{ orm_obj.phiW1.upper | X04 }}",
        phi_w1_lower_limit_calo2 => X"{{ orm_obj.phiW1.lower | X04 }}",
  {%- endif %}
  {%- if orm_obj.phiNrCuts > 1 %}
        phi_w2_ignore_calo2 => {{ orm_obj.phiW2Ignore | vhdl_bool }},
        phi_w2_upper_limit_calo2 => X"{{ orm_obj.phiW2.upper | X04 }}",
        phi_w2_lower_limit_calo2 => X"{{ orm_obj.phiW2.lower | X04 }}",
  {%- endif %}
  {%- if orm_obj.isolation %}
        iso_lut_calo2 => X"{{ orm_obj.isolation.value | X01 }}",
  {%- endif %}
{%- endblock object_cuts_calo_orm %}
