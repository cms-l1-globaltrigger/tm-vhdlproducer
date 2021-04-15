{%- if o1.is_muon_type and o2.is_muon_type %}
  {%- if condition.chargeCorrelation %}
-- charge correlation cut
        requested_charge_correlation => "{{ condition.chargeCorrelation.value }}",
  {%- endif %}
{%- endif %}
-- correlation cuts
{%- if condition.deltaEta %}
        deta_cut => {{ condition.deltaEta | vhdl_bool }},
        deta_upper_limit_vector => X"{{ condition.deltaEta.upper | X08 }}",
        deta_lower_limit_vector => X"{{ condition.deltaEta.lower | X08 }}",
{%- endif %}
{%- if condition.deltaPhi %}
        dphi_cut => {{ condition.deltaPhi | vhdl_bool }},
        dphi_upper_limit_vector => X"{{ condition.deltaPhi.upper | X08 }}",
        dphi_lower_limit_vector => X"{{ condition.deltaPhi.lower | X08 }}",
{%- endif %}
{%- if condition.deltaR %}
        dr_cut => {{ condition.deltaR | vhdl_bool }},
        dr_upper_limit_vector => X"{{ condition.deltaR.upper | X16 }}",
        dr_lower_limit_vector => X"{{ condition.deltaR.lower | X16 }}",
{%- endif %}
{%- if condition.mass %}
        mass_cut => {{ condition.mass | vhdl_bool }},
        mass_type => {{ condition.mass.type }},
  {%- if condition.mass.type == condition.mass.InvariantMassDeltaRType %}
        mass_div_dr_vector_width => {{ o1.type | upper }}_{{ o2.type | upper }}_MASS_DIV_DR_VECTOR_WIDTH,
        mass_div_dr_threshold => X"{{ condition.mass.lower | X21 }}",
  {%- else %}
        mass_vector_width => {{ o1.type | upper }}_PT_VECTOR_WIDTH+{{ o2.type | upper }}_PT_VECTOR_WIDTH+{{ o1.type | upper }}_{{ o2.type | upper }}_COSH_COS_VECTOR_WIDTH,
        mass_upper_limit_vector => X"{{ condition.mass.upper | X16 }}",
        mass_lower_limit_vector => X"{{ condition.mass.lower | X16 }}",
  {%- endif %}
{%- endif %}
{%- if condition.twoBodyPt %}
        tbpt_cut => {{ condition.twoBodyPt | vhdl_bool }},
  {%- if o1.is_calo_type and (o2.is_calo_type or o2.is_esum_type) %}
        tbpt_vector_width => 2+{{ o1.type | upper }}_PT_VECTOR_WIDTH+{{ o2.type | upper }}_PT_VECTOR_WIDTH+CALO_SIN_COS_VECTOR_WIDTH+CALO_SIN_COS_VECTOR_WIDTH,
  {%- elif o1.is_muon_type or o2.is_muon_type %}
        tbpt_vector_width => 2+{{ o1.type | upper }}_PT_VECTOR_WIDTH+{{ o2.type | upper }}_PT_VECTOR_WIDTH+MUON_SIN_COS_VECTOR_WIDTH+MUON_SIN_COS_VECTOR_WIDTH,
  {%- endif %}
        tbpt_threshold_vector => X"{{ condition.twoBodyPt.threshold | X16 }}",
{%- endif %}
