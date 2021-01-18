{% extends "instances/comb_condition.vhd" %}

{% set o5 = condition.objects[4] %}
{% set base_objects = condition.objects[:4] %}
{% set nr_requirements = condition.nr_objects - 1 %}
{% set orm_obj = condition.objects[nr_requirements] %}

{% block entity %}work.calo_conditions_orm{% endblock %}

{% block generic_map %}
  {%- if condition.deltaEtaOrm %}
        deta_orm_cut => {{ condition.deltaEtaOrm | vhdl_bool }},
  {%- endif %}
  {%- if condition.deltaPhiOrm %}
        dphi_orm_cut => {{ condition.deltaPhiOrm | vhdl_bool }},
  {%- endif %}
  {%- if condition.deltaROrm %}
        dr_orm_cut => {{ condition.deltaROrm | vhdl_bool }},
  {%- endif %}
  {%- include "instances/object_cuts_calo_orm.vhd" %}
  {%- include "instances/correlation_cuts_orm.vhd" %}
  {%- if condition.twoBodyPt %}
        -- correlation cuts
        twobody_pt_cut => true,
        pt_width => {{ o1.type | upper }}_PT_VECTOR_WIDTH,
        pt_sq_threshold_vector => X"{{ condition.twoBodyPt.threshold | X16 }}",
        sin_cos_width => CALO_SIN_COS_VECTOR_WIDTH,
        pt_sq_sin_cos_precision => {{ o1.type | upper }}_{{ o1.type | upper }}_SIN_COS_PRECISION,
  {%- endif %}
        -- number of objects
        nr_calo1_objects => NR_{{ o1.type | upper }}_OBJECTS,
        nr_calo2_objects => NR_{{ orm_obj.type | upper }}_OBJECTS,
        nr_templates => {{ nr_requirements }}
{%- endblock %}

{% block port_map %}
        {{ o1.type | lower }}_bx_{{ o1.bx }},
        {{ orm_obj.type | lower }}_bx_{{ orm_obj.bx }},
        diff_{{ o1.type | lower }}_{{ orm_obj.type | lower }}_bx_{{ o1.bx }}_bx_{{ orm_obj.bx }}_eta_vector,
        diff_{{ o1.type | lower }}_{{ orm_obj.type | lower }}_bx_{{ o1.bx }}_bx_{{ orm_obj.bx }}_phi_vector,
  {%- if condition.twoBodyPt %}
        pt => {{ o1.type | lower }}_pt_vector_bx_{{ o1.bx }},
        cos_phi_integer => {{ o1.type | lower }}_cos_phi_bx_{{ o1.bx }},
        sin_phi_integer => {{ o1.type | lower }}_sin_phi_bx_{{ o1.bx }},
  {%- endif %}
{%- endblock %}
