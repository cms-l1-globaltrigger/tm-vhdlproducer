{ConditionName}_i: esums_conditions
    generic map({EtGeMode}, {ObjectType}_type,
        X"{EtThreshold:04X}",
        {PhiFullRange}, X"{PhiW1UpperLimit:04X}", X"{PhiW1LowerLimit:04X}",
        {PhiW2Ignore}, X"{PhiW2UpperLimit:04X}", X"{PhiW2LowerLimit:04X}"
        )
    port map(lhc_clk, {ObjectType}_bx_{Bx}, {ConditionName});