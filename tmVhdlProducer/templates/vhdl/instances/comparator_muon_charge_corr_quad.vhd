{%- block instantiate_comparator_muon_charge_corr_quad %}
  {%- if bx1 == 'm2' %}
    {%- set bx1_raw = -2 %} 
  {%- elif bx1 == 'm1' %}
    {%- set bx1_raw = -1 %} 
  {%- elif bx1 == 'p1' %}
    {%- set bx1_raw = 1 %} 
  {%- elif bx1 == 'p2' %}
    {%- set bx1_raw = 2 %} 
  {%- else %}
    {%- set bx1_raw = 0 %} 
  {%- endif %}  
  {%- if bx2 == 'm2' %}
    {%- set bx2_raw = -2 %} 
  {%- elif bx2 == 'm1' %}
    {%- set bx2_raw = -1 %} 
  {%- elif bx2 == 'p1' %}
    {%- set bx2_raw = 1 %} 
  {%- elif bx2 == 'p2' %}
    {%- set bx2_raw = 2 %} 
  {%- else %}
    {%- set bx2_raw = 0 %} 
  {%- endif %}  
    comp_cc_quad_bx_{{ bx1 }}_bx_{{ bx2 }}_cc_{{ cc_val|lower }}_i: entity work.comparators_muon_charge_corr
        generic map(
            quad, CC_{{ cc_val|upper }}
        )
        port map(
            lhc_clk, 
            cc_quad => cc_quad(bx({{ bx1_raw }}),bx({{ bx2_raw }})), 
            comp_o_quad => comp_cc_quad_bx_{{ bx1 }}_bx_{{ bx2 }}_cc_{{ cc_val|lower }}
        );
{%- endblock instantiate_comparator_muon_charge_corr_quad %}
