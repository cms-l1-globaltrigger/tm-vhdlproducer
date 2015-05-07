{ConditionName}_i: calo_esums_correlation
    generic map(nr_{CaloObjectType}_objects, {CaloEtGeMode}, d_s_i_{CaloObjectType},
        X"{CaloEtThreshold:04X}", 
        {CaloEtaFullRange}, X"{CaloEtaW1UpperLimit:04X}", X"{CaloEtaW1LowerLimit:04X}",
        {ECalotaW2Ignore}, X"{CaloEtaW2UpperLimit:04X}", X"{CaloEtaW2LowerLimit:04X}",
        {CaloPhiFullRange}, X"{CaloPhiW1UpperLimit:04X}", X"{CaloPhiW1LowerLimit:04X}",
        {CaloPhiW2Ignore}, X"{CaloPhiW2UpperLimit:04X}", X"{CaloPhiW2LowerLimit:04X}",
        {EsumsEtGeMode}, d_s_i_{EsumsObjectType},
        X"{EsumsEtThreshold:04X}",
        {EsumsPhiCompMode}, {EsumsPhiFullRange}, X"{EsumsPhiW1UpperLimit:04X}", X"{EsumsPhiW1LowerLimit:04X}",
        {EsumsPhiW2Ignore}, X"{EsumsPhiW2UpperLimit:04X}", X"{EsumsPhiW2LowerLimit:04X}",
        {DiffPhiUpperLimit:d}, {DiffPhiLowerLimit:d})
    port map(lhc_clk, {CaloObjectType}_bx_{Bx1}, {EsumsObjectType}_bx_{Bx2},
        diff_{CaloObjectType}_{EsumsObjectType}_phi_bx_{Bx1}_bx_{Bx2},
        {ConditionName});
