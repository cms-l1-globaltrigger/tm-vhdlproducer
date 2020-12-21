{%- if condition.hasDeltaEtaOrm %}
        deta_orm_cut => {{ condition.deltaEtaOrm.enabled }}, 
        deta_orm_upper_limit_vector => X"{{ condition.deltaEtaOrm.upper|X08 }}", 
        deta_orm_lower_limit_vector => X"{{ condition.deltaEtaOrm.lower|X08 }}",
{%- endif %}        
{%- if condition.hasDeltaPhiOrm %}
        dphi_orm_cut => {{ condition.deltaPhiOrm.enabled }}, 
        dphi_orm_upper_limit_vector => X"{{ condition.deltaPhiOrm.upper|X08 }}", 
        dphi_orm_lower_limit_vector => X"{{ condition.deltaPhiOrm.lower|X08 }}",
{%- endif %}        
{%- if condition.hasDeltaROrm %}
        dr_orm_cut => {{ condition.deltaROrm.enabled }}, 
        dr_orm_upper_limit_vector => X"{{ condition.deltaROrm.upper|X16 }}", 
        dr_orm_lower_limit_vector => X"{{ condition.deltaROrm.lower|X16 }}",
{%- endif %}        
