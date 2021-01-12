{% extends "instances/comb_condition.vhd" %}

{% set o5 = condition.objects[4] %}
{% set base_objects = condition.objects[:4] %}
{% set nr_requirements = condition.nr_objects-1 %}

{% block entity %}work.calo_conditions_orm{% endblock %}

{% block generic_map %}
  {%- set thresholdList = [o.threshold for o in base_objects] %}
  {%- set etaNrCutsList = [o.etaNrCuts for o in base_objects] %}
  {%- set phiNrCutsList = [o.phiNrCuts for o in base_objects] %}
  {%- set etaUpperLimitList = [o1.etaUpperLimit, o2.etaUpperLimit, o3.etaUpperLimits, o4.etaUpperLimit] %}
  {%- set etaLowerLimitList = [o1.etaLowerLimit, o2.etaLowerLimit, o3.etaLowerLimit, o4.etaLowerLimit] %}
  {%- set phiFullRangeList = [o1.phiFullRange, o2.phiFullRange, o3.phiFullRange, o4.phiFullRange] %}
  {%- set phiW2IgnoreList = [o1.phiW2Ignore, o2.phiW2Ignore, o3.phiW2Ignore, o4.phiW2Ignore] %}
  {%- set phiUpperLimitList = [o1.phiUpperLimit, o2.phiUpperLimit, o3.phiUpperLimits, o4.phiUpperLimit] %}
  {%- set phiLowerLimitList = [o1.phiLowerLimit, o2.phiLowerLimit, o3.phiLowerLimit, o4.phiLowerLimit] %}
  {%- set hasIsolationList = [o.isolation.enabled for o in base_objects %}
  {%- set isolationLUTList = [o.isolation.value for o in base_objects %}
  {%- if condition.deltaEtaOrm %}
        deta_orm_cut => {{ condition.deltaEtaOrm | vhdl_bool }},
  {%- endif %}
  {%- if condition.deltaPhiOrm %}
        dphi_orm_cut => {{ condition.deltaPhiOrm | vhdl_bool }},
  {%- endif %}
  {%- if condition.deltaROrm %}
        dr_orm_cut => {{ condition.deltaROrm | vhdl_bool }},
  {%- endif %}
  {%- for i in range(nr_requirements,condition.ReqObjects-1)|reverse %}
    {%- set temp = thresholdList.append(0) %}
    {%- set temp = thresholdList.pop(i) %}
    {%- set temp = etaNrCutsList.append(0) %}
    {%- set temp = etaNrCutsList.pop(i) %}
    {%- set temp = phiNrCutsList.append(0) %}
    {%- set temp = phiNrCutsList.pop(i) %}
    {%- set temp = etaUpperLimitList.append(0) %}
    {%- set temp = etaUpperLimitList.pop(i) %}
    {%- set temp = etaLowerLimitList.append(0) %}
    {%- set temp = etaLowerLimitList.pop(i) %}
    {%- set temp = phiFullRangeList.append(0) %}
    {%- set temp = phiFullRangeList.pop(i) %}
    {%- set temp = phiW2IgnoreList.append(0) %}
    {%- set temp = phiW2IgnoreList.pop(i) %}
    {%- set temp = phiUpperLimitList.append(0) %}
    {%- set temp = phiUpperLimitList.pop(i) %}
    {%- set temp = phiLowerLimitList.append(0) %}
    {%- set temp = phiLowerLimitList.pop(i) %}
    {%- set temp = hasIsolationList.append(0) %}
    {%- set temp = hasIsolationList.pop(i) %}
    {%- set temp = isolationLUTList.append(0) %}
    {%- set temp = isolationLUTList.pop(i) %}
  {%- endfor %}
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
  {%- if nr_requirements == 1 %}
        nr_calo2_objects => NR_{{ o2.type | upper }}_OBJECTS,
  {%- elif nr_requirements == 2 %}
        nr_calo2_objects => NR_{{ o3.type | upper }}_OBJECTS,
  {%- elif nr_requirements == 3 %}
        nr_calo2_objects => NR_{{ o4.type | upper }}_OBJECTS,
  {%- elif nr_requirements == 4 %}
        nr_calo2_objects => NR_{{ o5.type | upper }}_OBJECTS,
  {%- endif %}
        nr_templates => {{ nr_requirements }}
{%- endblock %}

{% block port_map %}
        {{ o1.type | lower }}_bx_{{ o1.bx }},
  {%- if nr_requirements == 4 %}
        {{ o5.type | lower }}_bx_{{ o5.bx }},
        diff_{{ o1.type | lower }}_{{ o5.type | lower }}_bx_{{ o1.bx }}_bx_{{ o5.bx }}_eta_vector,
        diff_{{ o1.type | lower }}_{{ o5.type | lower }}_bx_{{ o1.bx }}_bx_{{ o5.bx }}_phi_vector,
  {%- elif nr_requirements == 3 %}
        {{ o4.type | lower }}_bx_{{ o4.bx }},
        diff_{{ o1.type | lower }}_{{ o4.type | lower }}_bx_{{ o1.bx }}_bx_{{ o4.bx }}_eta_vector,
        diff_{{ o1.type | lower }}_{{ o4.type | lower }}_bx_{{ o1.bx }}_bx_{{ o4.bx }}_phi_vector,
  {%- elif nr_requirements == 2 %}
        {{ o3.type | lower }}_bx_{{ o3.bx }},
        diff_{{ o1.type | lower }}_{{ o3.type | lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_eta_vector,
        diff_{{ o1.type | lower }}_{{ o3.type | lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_phi_vector,
  {%- elif nr_requirements == 1 %}
        {{ o2.type | lower }}_bx_{{ o2.bx }},
        diff_{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_eta_vector,
        diff_{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_phi_vector,
  {%- endif %}
  {%- if condition.twoBodyPt %}
        pt => {{ o1.type | lower }}_pt_vector_bx_{{ o1.bx }},
        cos_phi_integer => {{ o1.type | lower }}_cos_phi_bx_{{ o1.bx }},
        sin_phi_integer => {{ o1.type | lower }}_sin_phi_bx_{{ o1.bx }},
  {%- endif %}
{%- endblock %}
