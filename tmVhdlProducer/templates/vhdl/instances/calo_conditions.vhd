{%- extends "instances/comb_conditions_base.vhd" %}
{%- block instantiate_calo_conditions %}
  {%- block entity %}
{{ condition.vhdl_signal }}_i: entity work.calo_conditions
  {%- endblock entity %}
  {%- block port %}
        lhc_clk, 
        {{ condition.objects[0].type|lower }}_bx_{{ condition.objects[0].bx }},
    {%- if condition.hasTwoBodyPt %}
         pt => {{ condition.objects[0].type|lower }}_pt_vector_bx_{{ condition.objects[0].bx }}, 
         cos_phi_integer => {{ condition.objects[0].type|lower }}_cos_phi_bx_{{ condition.objects[0].bx }}, 
         sin_phi_integer => {{ condition.objects[0].type|lower }}_sin_phi_bx_{{ condition.objects[0].bx }});
    {%- endif %}
        condition_o => {{ condition.vhdl_signal }}
  {%- endblock port %}
{%- endblock instantiate_calo_conditions %}
{# eof #}
