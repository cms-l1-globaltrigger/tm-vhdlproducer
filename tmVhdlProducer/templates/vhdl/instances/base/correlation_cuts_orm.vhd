{%- if condition.deltaEtaOrm %}
        deta_orm_cut => {{ condition.deltaEtaOrm | vhdl_bool }},
        deta_orm_upper_limit_vector => X"{{ condition.deltaEtaOrm.upper | X08 }}",
        deta_orm_lower_limit_vector => X"{{ condition.deltaEtaOrm.lower | X08 }}",
{%- endif %}
{%- if condition.deltaPhiOrm %}
        dphi_orm_cut => {{ condition.deltaPhiOrm | vhdl_bool }},
        dphi_orm_upper_limit_vector => X"{{ condition.deltaPhiOrm.upper | X08 }}",
        dphi_orm_lower_limit_vector => X"{{ condition.deltaPhiOrm.lower | X08 }}",
{%- endif %}
{%- if condition.deltaROrm %}
        dr_orm_cut => {{ condition.deltaROrm | vhdl_bool }},
        dr_orm_upper_limit_vector => X"{{ condition.deltaROrm.upper | X16 }}",
        dr_orm_lower_limit_vector => X"{{ condition.deltaROrm.lower | X16 }}",
{%- endif %}
