diff_{ObjectType}_wsc_phi_bx_{Bx}_i: sub_phi_obj_vs_obj
    generic map(nr_{ObjectType}_objects, nr_{ObjectType}_objects, (d_s_i_{ObjectType}.phi_high-d_s_i_{ObjectType}.phi_low+1), PHI_BINS_DIV2_{ObjectType})
    port map({ObjectType}_phi_bx_{Bx}, {ObjectType}_phi_bx_{Bx}, diff_{ObjectType}_wsc_phi_bx_{Bx});      
