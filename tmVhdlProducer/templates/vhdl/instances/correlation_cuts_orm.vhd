-- correlation cuts orm
{%- if condition.hasDeltaEtaOrm %}
        diff_eta_orm_upper_limit_vector => X"{{ condition.deltaEtaOrm.upper|X08 }}", 
        diff_eta_orm_lower_limit_vector => X"{{ condition.deltaEtaOrm.lower|X08 }}",
{%- endif %}        
{%- if condition.hasDeltaPhiOrm %}
        diff_phi_orm_upper_limit_vector => X"{{ condition.deltaPhiOrm.upper|X08 }}", 
        diff_phi_orm_lower_limit_vector => X"{{ condition.deltaPhiOrm.lower|X08 }}",
{%- endif %}        
{%- if condition.hasDeltaROrm %}
        dr_orm_upper_limit_vector => X"{{ condition.deltaROrm.upper|X16 }}", 
        dr_orm_lower_limit_vector => X"{{ condition.deltaROrm.lower|X16 }}",
{%- endif %}        
