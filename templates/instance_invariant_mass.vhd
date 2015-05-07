{InvMassConditionName}_i: invariant_mass_condition
    generic map(
        obj_1 => "{ObjType1}",
        nr_obj_1 => nr_{ObjType1}_objects,
        eta_1_upper => d_s_i_{ObjType1}.eta_high,
        eta_1_lower => d_s_i_{ObjType1}.eta_low,
        et_pt_1_upper => d_s_i_{ObjType1}.et_high,
        et_pt_1_lower => d_s_i_{ObjType1}.et_low,
        obj_2 => "{ObjType2}",
        nr_obj_2 => nr_{ObjType2}_objects,
        eta_2_upper => d_s_i_{ObjType2}.eta_high,
        eta_2_lower => d_s_i_{ObjType2}.eta_low,
        et_pt_2_upper => d_s_i_{ObjType2}.et_high,
        et_pt_2_lower => d_s_i_{ObjType2}.et_low,
        diff_phi_width => {ObjType1}_{ObjType2}_phi_diff_width,
        threshold_high => {InvMassThresholdHigh},
        threshold_low => {InvMassThresholdLow}
    )
    port map(
        clk => clk,
        data_1 => {ObjType1}_data_common,
        data_2 => {ObjType2}_data_common,
        diff_phi => diff_{ObjType1}_{ObjType2}_phi,
        condition_o => {InvMassConditionName}
    );
