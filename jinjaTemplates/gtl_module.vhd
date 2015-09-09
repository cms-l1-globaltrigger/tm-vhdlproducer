
-- ==== Inserted by TME - begin =============================================================================================================

-- Signal definition for eta, phi and common (inputs of subtractors) for wsc and correlation conditions - written by TME on the base of templates
{%- include  "subTemplates/signal_eta_phi.ja.vhd"%}

-- Signal definition for differences (outputs of subtractors) for wsc conditions - written by TME on the base of templates
{#%- include  "subTemplates/SignalDifferencesWsc"%#}

-- Signal definition for differences (outputs of subtractors) for correlation conditions (and delta-R) - written by TME on the base of templates
{#%- include  "subTemplates/SignalDifferencesCorrelation"%#}

-- Signal definition for muon charge correlation (only once for all muon conditions) - written by TME on the base of templates
{#%- include  "subTemplates/SignalMuonChargeCorrelation"%#}

-- Signal definition for conditions names - written by TME on the base of templates
{#%- include  "subTemplates/SignalConditionNames"%#}

-- Signal definition for algorithms names - written by TME on the base of templates
{%- include  "subTemplates/signal_algorithm.ja.vhd"%}

-- ==== Inserted by TME - end ===============================================================================================================




-- ==== Inserted by TME - begin =============================================================================================================

-- Instantiations of eta and phi conversions, only instantiated for correlation conditions with unequal eta/phi resolutions - written by TME on the base of templates
{#%- include  "subTemplates/EtaPhiConversions"%#}

-- Instantiations of differences calculation for wsc conditions - written by TME on the base of templates
{#%- include  "subTemplates/DifferenceWscInstances"%#}

-- Instantiations of differences calculation for correlation conditions - written by TME on the base of templates
{#%- include  "subTemplates/DifferenceCorrInstances"%#}

-- Instantiations of muon charge correlations (only once for all muon conditions) - written by TME on the base of templates
{#%- include  "subTemplates/MuonChargeCorrelationInstances"%#}

-- Instantiations of conditions - written by TME on the base of templates
{%- include  "subTemplates/instance_calo_condition_v2.ja.vhd"%}
{%- include  "subTemplates/instance_muon_condition.ja.vhd"%}
{%- include  "subTemplates/instance_esums_condition.ja.vhd"%}


-- Instantiations of algorithms - written by TME on the base of templates
{#%- include  "subTemplates/AlgoEquations"%#}

-- ==== Inserted by TME - end ===============================================================================================================

