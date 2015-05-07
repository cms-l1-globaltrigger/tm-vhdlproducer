{ConditionName}_i: muon_esums_correlation
    generic map(nr_muon_objects, {MuonPtGeMode}, d_s_i_muon,
        X"{PtHighThreshold:04X}", X"{PtLowThreshold:04X}", 
        {EtaFullRange}, X"{EtaW1UpperLimit:04X}", X"{EtaW1LowerLimit:04X}",
        {EtaW2Ignore}, X"{EtaW2UpperLimit:04X}", X"{EtaW2LowerLimit:04X}",
        {PhiFullRange}, X"{PhiW1UpperLimit:04X}", X"{PhiW1LowerLimit:04X}",
        {PhiW2Ignore}, X"{PhiW2UpperLimit:04X}", X"{PhiW2LowerLimit:04X}",
        {RequstedCharge},
        {EsumsEtGeMode}, d_s_i_{EsumsObjectType},
        X"{EsumsEtThreshold:04X}",
        {EsumsPhiCompMode}, {EsumsPhiFullRange}, X"{EsumsPhiW1UpperLimit:04X}", X"{EsumsPhiW1LowerLimit:04X}",
        {EsumsPhiW2Ignore}, X"{EsumsPhiW2UpperLimit:04X}", X"{EsumsPhiW2LowerLimit:04X}",
        {DiffPhiUpperLimit:d}, {DiffPhiLowerLimit:d})
    port map(lhc_clk, muon_bx_{Bx1}, 
        pos_charge_single_bx_{Bx1}, neg_charge_singlebx__{Bx1},
        {EsumsObjectType}_bx_{Bx2},
        diff_muon_{EsumsObjectType}_eta_bx_{Bx1}_bx_{Bx2}, diff_muon_{EsumsObjectType}_phi_bx_{Bx1}_bx_{Bx2},
        {ConditionName});
