diff_{ObjectType1}_{ObjectType2}_phi_bx_{Bx1}_bx_{Bx2}_i: sub_phi_obj_vs_obj
    generic map(nr_{ObjectType1}_objects, nr_{ObjectType2}_objects, PHI_WIDTH_{ObjectType1}_{ObjectType2}, PHI_BINS_DIV2_{ObjectType1}_{ObjectType2})
    port map({ObjectType1}_phi_bx_{Bx1}, {ObjectType2}_phi_bx_{Bx2}, diff_{ObjectType1}_{ObjectType2}_phi_bx_{Bx1}_bx_{Bx2});      
