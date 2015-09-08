
-- ==== Inserted by TME - begin =============================================================================================================

-- Signal definition for eta, phi and common (inputs of subtractors) for wsc and correlation conditions - written by TME on the base of templates
{%- include  "signal_eta_phi.ja.vhd"%}

-- Signal definition for differences (outputs of subtractors) for wsc conditions - written by TME on the base of templates
{#%- include  "SignalDifferencesWsc"%#}

-- Signal definition for differences (outputs of subtractors) for correlation conditions (and delta-R) - written by TME on the base of templates
{#%- include  "SignalDifferencesCorrelation"%#}

-- Signal definition for muon charge correlation (only once for all muon conditions) - written by TME on the base of templates
{#%- include  "SignalMuonChargeCorrelation"%#}

-- Signal definition for conditions names - written by TME on the base of templates
{#%- include  "SignalConditionNames"%#}

-- Signal definition for algorithms names - written by TME on the base of templates
{#%- include  "SignalAlgoNames"%#}

-- ==== Inserted by TME - end ===============================================================================================================




-- ==== Inserted by TME - begin =============================================================================================================

-- Instantiations of eta and phi conversions, only instantiated for correlation conditions with unequal eta/phi resolutions - written by TME on the base of templates
{#%- include  "EtaPhiConversions"%#}

-- Instantiations of differences calculation for wsc conditions - written by TME on the base of templates
{#%- include  "DifferenceWscInstances"%#}

-- Instantiations of differences calculation for correlation conditions - written by TME on the base of templates
{#%- include  "DifferenceCorrInstances"%#}

-- Instantiations of muon charge correlations (only once for all muon conditions) - written by TME on the base of templates
{#%- include  "MuonChargeCorrelationInstances"%#}

-- Instantiations of conditions - written by TME on the base of templates
{#%- include  "ConditionInstances"%#}
{%- include  "instance_calo_condition_v2.ja.vhd"%}
{%- include  "instance_muon_condition.ja.vhd"%}


-- Instantiations of algorithms - written by TME on the base of templates
{#%- include  "AlgoEquations"%#}

-- ==== Inserted by TME - end ===============================================================================================================

