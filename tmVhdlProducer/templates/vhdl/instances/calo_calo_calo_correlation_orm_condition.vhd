{% extends "instances/correlation_condition.vhd" %}

{% block entity %}work.calo_calo_calo_correlation_orm_condition{% endblock %}

{%- block generic_map_beg %}
    {%- if condition.deltaEtaOrm %}
        deta_orm_cut => {{ condition.deltaEtaOrm | vhdl_bool }},
    {%- endif %}
    {%- if condition.deltaPhiOrm %}
        dphi_orm_cut => {{ condition.deltaPhiOrm | vhdl_bool }},
    {%- endif %}
    {%- if condition.deltaROrm %}
        dr_orm_cut => {{ condition.deltaROrm | vhdl_bool }},
    {%- endif %}
    {%- if condition.deltaEta %}
        deta_cut => {{ condition.deltaEta | vhdl_bool }},
    {%- endif %}
    {%- if condition.deltaPhi %}
        dphi_cut => {{ condition.deltaPhi | vhdl_bool }},
    {%- endif %}
    {%- if condition.deltaR %}
        dr_cut => {{ condition.deltaR | vhdl_bool }},
    {%- endif %}
    {%- if condition.mass %}
        mass_cut => {{ condition.mass | vhdl_bool }},
        mass_type => {{ condition.mass.InvariantMassType }},
    {%- endif %}
    {%- if condition.twoBodyPt %}
        twobody_pt_cut => {{ condition.twoBodyPt | vhdl_bool }},
    {%- endif %}
{% endblock %}

{%- block correlation_orm %}
  {%- include "instances/correlation_cuts_orm.vhd" %}
{% endblock %}

{%- block generic_map_end %}
        -- selector one or two objects with orm
    {%- if condition.nr_objects == 3 %}
        obj_2plus1 => true
    {%- else %}
        obj_2plus1 => false
    {%- endif %}
{%- endblock %}

{%- block port_map %}
  {%- set o1 = condition.objects[0] %}
  {%- set o2 = condition.objects[1] %}
  {%- if condition.nr_objects == 3 %}
    {%- set o3 = condition.objects[2] %}
  {%- endif %}
        {{ o1.type | lower }}_bx_{{ o1.bx }},
        {{ o2.type | lower }}_bx_{{ o2.bx }},
        {{ o3.type | lower }}_bx_{{ o3.bx }},
  {%- if condition.nr_objects == 3 %}
        diff_eta_orm => diff_{{ o1.type | lower }}_{{ o3.type | lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_eta_vector,
        diff_phi_orm => diff_{{ o1.type | lower }}_{{ o3.type | lower }}_bx_{{ o1.bx }}_bx_{{ o3.bx }}_phi_vector,
  {%- else %}
        diff_eta_orm => diff_{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_eta_vector,
        diff_phi_orm => diff_{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_phi_vector,
  {%- endif %}
        diff_eta => diff_{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_eta_vector,
        diff_phi => diff_{{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_phi_vector,
  {%- if (condition.mass) or (condition.twoBodyPt) %}
        pt1 => {{ o1.type | lower }}_pt_vector_bx_{{ o1.bx }},
        pt2 => {{ o2.type | lower }}_pt_vector_bx_{{ o2.bx }},
  {%- endif %}
  {%- if condition.mass %}
        cosh_deta => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cosh_deta_vector,
        cos_dphi => {{ o1.type | lower }}_{{ o2.type | lower }}_bx_{{ o1.bx }}_bx_{{ o2.bx }}_cos_dphi_vector,
  {%- endif %}
  {%- if condition.twoBodyPt %}
        cos_phi_1_integer => {{ o1.type | lower }}_cos_phi_bx_{{ o1.bx }},
        cos_phi_2_integer => {{ o2.type | lower }}_cos_phi_bx_{{ o2.bx }},
        sin_phi_1_integer => {{ o1.type | lower }}_sin_phi_bx_{{ o1.bx }},
        sin_phi_2_integer => {{ o2.type | lower }}_sin_phi_bx_{{ o2.bx }},
  {%- endif %}
{%- endblock %}
