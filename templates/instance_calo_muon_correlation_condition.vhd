{ConditionName}_i: entity work.calo_muon_correlation
    generic map(
        {Deta}, {Dphi}, {Dr},
	NR_{CaloObjectType}_OBJECTS, {CaloEtGeMode}, {CaloObjectType}_TYPE,
        X"{CaloEtThreshold:04X}", 
        {CaloEtaFullRange}, X"{CaloEtaW1UpperLimit:04X}", X"{CaloEtaW1LowerLimit:04X}",
        {CalotaW2Ignore}, X"{CaloEtaW2UpperLimit:04X}", X"{CaloEtaW2LowerLimit:04X}",
        {CaloPhiFullRange}, X"{CaloPhiW1UpperLimit:04X}", X"{CaloPhiW1LowerLimit:04X}",
        {CaloPhiW2Ignore}, X"{CaloPhiW2UpperLimit:04X}", X"{CaloPhiW2LowerLimit:04X}",
        NR_MUON_OBJECTS, {MuonPtGeMode},
        X"{MuonPtThreshold:04X}", 
        {MuonEtaFullRange}, X"{MuonEtaW1UpperLimit:04X}", X"{MuonEtaW1LowerLimit:04X}",
        {MuonEtaW2Ignore}, X"{MuonEtaW2UpperLimit:04X}", X"{MuonEtaW2LowerLimit:04X}",
        {MuonPhiFullRange}, X"{MuonPhiW1UpperLimit:04X}", X"{MuonPhiW1LowerLimit:04X}",
        {MuonPhiW2Ignore}, X"{MuonPhiW2UpperLimit:04X}", X"{MuonPhiW2LowerLimit:04X}",
        "{MuonRequstedCharge}", (X"{MuonQualityLut:04X}", (X"{MuonIsolationLut:01X}",
        {DiffEtaUpperLimit:3f}, {DiffEtaLowerLimit:3f}, {DiffPhiUpperLimit:3f}, {DiffPhiLowerLimit:3f}), {DiffPhiUpperLimit:3f}, {DiffPhiLowerLimit:3f}
    port map(lhc_clk, {CaloObjectType}_bx_{Bx1}, muon_bx_{Bx2},
        diff_{CaloObjectType}_muon_eta_integer_value_bx_{Bx1}_bx_{Bx2}, diff_{CaloObjectType}_muon_phi_integer_value_bx_{Bx1}_bx_{Bx2},
        {ConditionName});
