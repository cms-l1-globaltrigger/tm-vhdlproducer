{ConditionName}_i: calo_calo_correlation
    generic map(nr_{Calo1ObjectType}_objects, {Calo1EtGeMode}, d_s_i_{Calo1ObjectType},
        X"{Calo1EtThreshold:04X}", 
        {Calo1EtaFullRange}, X"{Calo1EtaW1UpperLimit:04X}", X"{Calo1EtaW1LowerLimit:04X}",
        {ECalo1taW2Ignore}, X"{Calo1EtaW2UpperLimit:04X}", X"{Calo1EtaW2LowerLimit:04X}",
        {Calo1PhiFullRange}, X"{Calo1PhiW1UpperLimit:04X}", X"{Calo1PhiW1LowerLimit:04X}",
        {Calo1PhiW2Ignore}, X"{Calo1PhiW2UpperLimit:04X}", X"{Calo1PhiW2LowerLimit:04X}",
        nr_{Calo2ObjectType}_objects, {Calo2EtGeMode}, d_s_i_{Calo2ObjectType},
        X"{Calo2EtThreshold:04X}", 
        {Calo2EtaFullRange}, X"{Calo2EtaW1UpperLimit:04X}", X"{Calo2EtaW1LowerLimit:04X}",
        {ECalo1taW2Ignore}, X"{Calo2EtaW2UpperLimit:04X}", X"{Calo2EtaW2LowerLimit:04X}",
        {Calo2PhiFullRange}, X"{Calo2PhiW1UpperLimit:04X}", X"{Calo2PhiW1LowerLimit:04X}",
        {Calo2PhiW2Ignore}, X"{Calo2PhiW2UpperLimit:04X}", X"{Calo2PhiW2LowerLimit:04X}",
        {DiffEtaUpperLimit:d}, {DiffEtaLowerLimit:d}, {DiffPhiUpperLimit:d}, {DiffPhiLowerLimit:d})
    port map(lhc_clk, {Calo1ObjectType}_bx_{Bx1}, {Calo2ObjectType}_bx_{Bx2},
        diff_{Calo1ObjectType}_{Calo2ObjectType}_eta_bx_{Bx1}_bx_{Bx2}, diff_{Calo1ObjectType}_{Calo2ObjectType}_phi_bx_{Bx1}_bx_{Bx2},
        {ConditionName});
