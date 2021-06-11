{%- block signal_correlation_conditions_parameter %}
  {%- for o in module.correlationObjects %}
    {%- if o.is_calo_type %}
    signal {{ o.type|lower }}_bx_{{ o.bx }}_pt_vector: diff_inputs_array(0 to NR_{{ o.type|upper }}_OBJECTS-1) := (others => (others => '0'));
    signal {{ o.type|lower }}_bx_{{ o.bx }}_eta_integer: integer_array(0 to NR_{{ o.type|upper }}_OBJECTS-1) := (others => 0);
    signal {{ o.type|lower }}_bx_{{ o.bx }}_phi_integer: integer_array(0 to NR_{{ o.type|upper }}_OBJECTS-1) := (others => 0);
    signal {{ o.type|lower }}_bx_{{ o.bx }}_cos_phi: integer_array(0 to NR_{{ o.type|upper }}_OBJECTS-1) := (others => 0);
    signal {{ o.type|lower }}_bx_{{ o.bx }}_sin_phi: integer_array(0 to NR_{{ o.type|upper }}_OBJECTS-1) := (others => 0);
    signal {{ o.type|lower }}_bx_{{ o.bx }}_conv_cos_phi: integer_array(0 to NR_{{ o.type|upper }}_OBJECTS-1) := (others => 0);
    signal {{ o.type|lower }}_bx_{{ o.bx }}_conv_sin_phi: integer_array(0 to NR_{{ o.type|upper }}_OBJECTS-1) := (others => 0);
    signal {{ o.type|lower }}_bx_{{ o.bx }}_eta_conv_2_muon_eta_integer: integer_array(0 to NR_{{ o.type|upper }}_OBJECTS-1) := (others => 0);
    signal {{ o.type|lower }}_bx_{{ o.bx }}_phi_conv_2_muon_phi_integer: integer_array(0 to NR_{{ o.type|upper }}_OBJECTS-1) := (others => 0);
    {%- elif o.is_muon_type %}
    signal {{ o.type|lower }}_bx_{{ o.bx }}_pt_vector: diff_inputs_array(0 to NR_{{ o.type|upper }}_OBJECTS-1) := (others => (others => '0'));
    signal {{ o.type|lower }}_bx_{{ o.bx }}_upt_vector: diff_inputs_array(0 to NR_{{ o.type|upper }}_OBJECTS-1) := (others => (others => '0'));
    signal {{ o.type|lower }}_bx_{{ o.bx }}_eta_integer: integer_array(0 to NR_{{ o.type|upper }}_OBJECTS-1) := (others => 0);
    signal {{ o.type|lower }}_bx_{{ o.bx }}_phi_integer: integer_array(0 to NR_{{ o.type|upper }}_OBJECTS-1) := (others => 0);
    signal {{ o.type|lower }}_bx_{{ o.bx }}_cos_phi: integer_array(0 to NR_{{ o.type|upper }}_OBJECTS-1) := (others => 0);
    signal {{ o.type|lower }}_bx_{{ o.bx }}_sin_phi: integer_array(0 to NR_{{ o.type|upper }}_OBJECTS-1) := (others => 0);
    {%- elif o.is_esums_type %}
    signal {{ o.type|lower }}_bx_{{ o.bx }}_pt_vector: diff_inputs_array(0 to NR_{{ o.type|upper }}_OBJECTS-1) := (others => (others => '0'));
    signal {{ o.type|lower }}_bx_{{ o.bx }}_phi_integer: integer_array(0 to NR_{{ o.type|upper }}_OBJECTS-1) := (others => 0);
    signal {{ o.type|lower }}_bx_{{ o.bx }}_cos_phi: integer_array(0 to NR_{{ o.type|upper }}_OBJECTS-1) := (others => 0);
    signal {{ o.type|lower }}_bx_{{ o.bx }}_sin_phi: integer_array(0 to NR_{{ o.type|upper }}_OBJECTS-1) := (others => 0);
    signal {{ o.type|lower }}_bx_{{ o.bx }}_conv_cos_phi: integer_array(0 to NR_{{ o.type|upper }}_OBJECTS-1) := (others => 0);
    signal {{ o.type|lower }}_bx_{{ o.bx }}_conv_sin_phi: integer_array(0 to NR_{{ o.type|upper }}_OBJECTS-1) := (others => 0);
    signal {{ o.type|lower }}_bx_{{ o.bx }}_phi_conv_2_muon_phi_integer: integer_array(0 to NR_{{ o.type|upper }}_OBJECTS-1) := (others => 0);
    {%- endif %}
  {%- endfor %}
{%- endblock signal_correlation_conditions_parameter %}
{# eof #}
