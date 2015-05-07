diff_{ObjectType}_wsc_eta_bx_{Bx}_i: sub_eta_obj_vs_obj
    generic map(nr_{ObjectType}_objects, nr_{ObjectType}_objects, (d_s_i_{ObjectType}.eta_high-d_s_i_{ObjectType}.eta_low+1))
    port map({ObjectType}_eta_bx_{Bx}, {ObjectType}_eta_bx_{Bx}, diff_{ObjectType}_wsc_eta_bx_{Bx});      
