{ObjectType}_data_bx_{Bx}_l: for i in 0 to NR_{ObjectType}_OBJECTS-1 generate
    {ObjectType}_eta_bx_{Bx}(i)(d_s_i_{ObjectType}.eta_high-d_s_i_{ObjectType}.eta_low downto 0) <= {ObjectType}_bx_{Bx}(i)(d_s_i_{ObjectType}.eta_high downto d_s_i_{ObjectType}.eta_low);
    {ObjectType}_eta_common_bx_{Bx}(i)(d_s_i_{ObjectType}.eta_high-d_s_i_{ObjectType}.eta_low+3 downto 0) <= {ObjectType}_eta_bx_{Bx}(i)(d_s_i_{ObjectType}.eta_high-d_s_i_{ObjectType}.eta_low downto 0) & "100";
    {ObjectType}_phi_bx_{Bx}(i)(d_s_i_{ObjectType}.phi_high-d_s_i_{ObjectType}.phi_low downto 0) <= {ObjectType}_bx_{Bx}(i)(d_s_i_{ObjectType}.phi_high downto d_s_i_{ObjectType}.phi_low);
    {ObjectType}_phi_common_bx_{Bx}(i)(d_s_i_{ObjectType}.phi_high-d_s_i_{ObjectType}.phi_low+3 downto 0) <= {ObjectType}_bx_{Bx}(i)(d_s_i_{ObjectType}.phi_high downto d_s_i_{ObjectType}.phi_low) & "100";
end generate;
