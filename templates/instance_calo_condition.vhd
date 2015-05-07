{ConditionName}_i: calo_conditions
    generic map(nr_{ObjectType}_objects, {NrTemplates:d}, {DoubleWsc}, {EtGeMode}, d_s_i_{ObjectType},
        (X"{EtThresholds[0]:04X}", X"{EtThresholds[1]:04X}", X"{EtThresholds[2]:04X}", X"{EtThresholds[3]:04X}"), 
        ({EtaFullRange[0]}, {EtaFullRange[1]}, {EtaFullRange[2]}, {EtaFullRange[3]}),
        (X"{EtaW1UpperLimits[0]:04X}", X"{EtaW1UpperLimits[1]:04X}", X"{EtaW1UpperLimits[2]:04X}", X"{EtaW1UpperLimits[3]:04X}"), (X"{EtaW1LowerLimits[0]:04X}", X"{EtaW1LowerLimits[1]:04X}", X"{EtaW1LowerLimits[2]:04X}", X"{EtaW1LowerLimits[3]:04X}"),
        ({EtaW2Ignore[0]}, {EtaW2Ignore[1]}, {EtaW2Ignore[2]}, {EtaW2Ignore[3]}),
        (X"{EtaW2UpperLimits[0]:04X}", X"{EtaW2UpperLimits[1]:04X}", X"{EtaW2UpperLimits[2]:04X}", X"{EtaW2UpperLimits[3]:04X}"), (X"{EtaW2LowerLimits[0]:04X}", X"{EtaW2LowerLimits[1]:04X}", X"{EtaW2LowerLimits[2]:04X}", X"{EtaW2LowerLimits[3]:04X}"),
        ({PhiFullRange[0]}, {PhiFullRange[1]}, {PhiFullRange[2]}, {PhiFullRange[3]}),
        (X"{PhiW1UpperLimits[0]:04X}", X"{PhiW1UpperLimits[1]:04X}", X"{PhiW1UpperLimits[2]:04X}", X"{PhiW1UpperLimits[3]:04X}"), (X"{PhiW1LowerLimits[0]:04X}", X"{PhiW1LowerLimits[1]:04X}", X"{PhiW1LowerLimits[2]:04X}", X"{PhiW1LowerLimits[3]:04X}"),
        ({PhiW2Ignore[0]}, {PhiW2Ignore[1]}, {PhiW2Ignore[2]}, {PhiW2Ignore[3]}),
        (X"{PhiW2UpperLimits[0]:04X}", X"{PhiW2UpperLimits[1]:04X}", X"{PhiW2UpperLimits[2]:04X}", X"{PhiW2UpperLimits[3]:04X}"), (X"{PhiW2LowerLimits[0]:04X}", X"{PhiW2LowerLimits[1]:04X}", X"{PhiW2LowerLimits[2]:04X}", X"{PhiW2LowerLimits[3]:04X}"),
        {DiffEtaUpperLimit:d}, {DiffEtaLowerLimit:d}, {DiffPhiUpperLimit:d}, {DiffPhiLowerLimit:d})
    port map(lhc_clk, {ObjectType}_bx_{Bx}, diff_{ObjectType}_wsc_eta_bx_{Bx}, diff_{ObjectType}_wsc_phi_bx_{Bx},
        {ConditionName});
