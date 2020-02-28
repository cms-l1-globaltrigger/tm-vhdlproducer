{%- block instantiate_mass_3_obj_conditions %}
  {%- set o1 = condition.objects[0] %}
  {%- set o2 = condition.objects[1] %}
  {%- set o3 = condition.objects[2] %}
    cond_{{ condition.vhdl_signal }}_i: entity work.mass_3_obj_condition
        generic map(
            N_{{ o1.type|upper }}_OBJECTS,
            (({{ o1.sliceLow }},{{ o1.sliceHigh }}), ({{ o2.sliceLow }},{{ o2.sliceHigh }}), ({{ o3.sliceLow }},{{ o3.sliceHigh }}), (0,0)),
  {%- if condition.chargeCorrelation in ('os', 'ls') %}
            true
  {%- else %}
            false
  {%- endif %}
        )
        port map(
            lhc_clk,           
  {%- if o1.type == 'EG' or o1.type == 'JET' or o1.type == 'TAU' %}
    {%- with obj = o1 %}
            in_1 => {% include "helper/helper_comb_and_calos_signals_names.txt" %},
    {%- endwith %}
  {%- elif o1.type == 'MU' %}
    {%- with obj = o1 %}
            in_1 => {% include "helper/helper_comb_and_muons_signals_names.txt" %},
    {%- endwith %}
  {%- endif %}
  {%- if o2.type == 'EG' or o2.type == 'JET' or o2.type == 'TAU' %}
    {%- with obj = o2 %}
            in_2 => {% include "helper/helper_comb_and_calos_signals_names.txt" %},
    {%- endwith %}
  {%- elif o2.type == 'MU' %}
    {%- with obj = o2 %}
            in_2 => {% include "helper/helper_comb_and_muons_signals_names.txt" %},
    {%- endwith %}
  {%- endif %}
  {%- if o3.type == 'EG' or o3.type == 'JET' or o3.type == 'TAU' %}
    {%- with obj = o3 %}
            in_3 => {% include "helper/helper_comb_and_calos_signals_names.txt" %},
    {%- endwith %}
  {%- elif o3.type == 'MU' %}
    {%- with obj = o3 %}
            in_3 => {% include "helper/helper_comb_and_muons_signals_names.txt" %},
    {%- endwith %}
  {%- endif %}
            inv_mass => comp_invmass3obj_{{ o1.type|lower }}_bx_{{ o1.bx }}_0x{{ condition.mass.lower|X14|lower }}_0x{{ condition.mass.upper|X14|lower }},
  {%- if condition.chargeCorrelation in ('os', 'ls') %}
            charge_corr_triple => comp_cc_triple_bx_{{ o1.bx }}_bx_{{ o1.bx }}_cc_{{ condition.chargeCorrelation }},
  {%- endif %}
            cond_o => {{ condition.vhdl_signal }}
        );
{% endblock instantiate_mass_3_obj_conditions %}
