{%- block instantiate_muon_charge_correlations_calc %}
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
    calc_muon_charge_correlations_bx_{{ bx1 }}_bx_{{ bx2 }}_i: entity work.muon_charge_correlations
        port map(
            data.mu(bx({{ bx1_raw }})).charge,
            data.mu(bx({{ bx2_raw }})).charge,
            cc_double(bx({{ bx1_raw }}),bx({{ bx2_raw }})),
            cc_triple(bx({{ bx1_raw }}),bx({{ bx2_raw }})),
            cc_quad(bx({{ bx1_raw }}),bx({{ bx2_raw }}))
        );
{%- endblock instantiate_muon_charge_correlations_calc %}
