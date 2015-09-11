--------------------------------------------------------------------------------
-- Synthesizer : ISE 14.6
-- Platform    : Linux Ubuntu 10.04
-- Targets     : Synthese
--------------------------------------------------------------------------------
-- This work is held in copyright as an unpublished work by HEPHY (Institute
-- of High Energy Physics) All rights reserved.  This work may not be used
-- except by authorized licensees of HEPHY. This work is the
-- confidential information of HEPHY.
--------------------------------------------------------------------------------
-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/l1tm/L1Menu_CaloMuonCorrelation_2015_hb_test/vhdl/module_0/src/gtl_module.vhd $
-- $Date: 2015-08-24 11:49:40 +0200 (Mon, 24 Aug 2015) $
-- $Author: bergauer $
-- $Revision: 4173 $
--------------------------------------------------------------------------------

-- HB 2015-08-10: generated without TME for calo-muon-correlation tests

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; -- for function "CONV_INTEGER"

-- use work.l1tm_pkg.all;
use work.gtl_pkg.all;

entity gtl_module is
    port(
        lhc_clk : in std_logic;
        eg_data : in calo_objects_array(0 to NR_EG_OBJECTS-1);
        jet_data : in calo_objects_array(0 to NR_JET_OBJECTS-1);
        tau_data : in calo_objects_array(0 to NR_TAU_OBJECTS-1);
        ett_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        ht_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        etm_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htm_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        muon_data : in muon_objects_array(0 to NR_MUON_OBJECTS-1);
        external_conditions : in std_logic_vector(NR_EXTERNAL_CONDITIONS-1 downto 0);
        algo_o : out std_logic_vector(NR_ALGOS-1 downto 0));
end gtl_module;

architecture rtl of gtl_module is
    constant calo_data_inputs_ff: boolean := false; -- used for tests of gtl_module_example.vhd
    constant external_conditions_pipeline_stages: natural := 2; -- pipeline stages for "External conditions" to get same pipeline to algos as conditions

    signal muon_data_int, muon_bx_p2, muon_bx_p1, muon_bx_0, muon_bx_m1, muon_bx_m2 : muon_objects_array(0 to NR_MUON_OBJECTS-1);
    signal eg_data_int, eg_bx_p2, eg_bx_p1, eg_bx_0, eg_bx_m1, eg_bx_m2 : calo_objects_array(0 to NR_EG_OBJECTS-1);
    signal jet_data_int, jet_bx_p2, jet_bx_p1, jet_bx_0, jet_bx_m1, jet_bx_m2 : calo_objects_array(0 to NR_JET_OBJECTS-1);
    signal tau_data_int, tau_bx_p2, tau_bx_p1, tau_bx_0, tau_bx_m1, tau_bx_m2 : calo_objects_array(0 to NR_TAU_OBJECTS-1);
    signal ett_data_int, ett_bx_p2, ett_bx_p1, ett_bx_0, ett_bx_m1, ett_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
-- HB 2015-04-28: changed for "htt" - object type from TME [string(1 to 3)] in esums_conditions.vhd
--     signal ht_data_int, ht_bx_p2, ht_bx_p1, ht_bx_0, ht_bx_m1, ht_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal htt_data_int, htt_bx_p2, htt_bx_p1, htt_bx_0, htt_bx_m1, htt_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal etm_data_int, etm_bx_p2, etm_bx_p1, etm_bx_0, etm_bx_m1, etm_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal htm_data_int, htm_bx_p2, htm_bx_p1, htm_bx_0, htm_bx_m1, htm_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal external_conditions_int, ext_cond_bx_p2, ext_cond_bx_p1, ext_cond_bx_0, ext_cond_bx_m1, ext_cond_bx_m2 : std_logic_vector(NR_EXTERNAL_CONDITIONS-1 downto 0);

    signal ext_cond_bx_p2_temp, ext_cond_bx_p1_temp, ext_cond_bx_0_temp, ext_cond_bx_m1_temp, ext_cond_bx_m2_temp : std_logic_vector(NR_EXTERNAL_CONDITIONS-1 downto 0);
    signal ext_cond_bx_p2_pipe, ext_cond_bx_p1_pipe, ext_cond_bx_0_pipe, ext_cond_bx_m1_pipe, ext_cond_bx_m2_pipe : std_logic_vector(NR_EXTERNAL_CONDITIONS-1 downto 0);

    signal algo : std_logic_vector(NR_ALGOS-1 downto 0) := (others => '0');

-- ==== Inserted by TME - begin =============================================================================================================

-- Signal definition for eta, phi and common (inputs of subtractors) for wsc and correlation conditions.
{%- include  "subTemplates/signal_eta_phi.ja.vhd"%}

-- Signal definition for differences (outputs of subtractors) for wsc conditions.
-- Insert signal_differences_wsc.ja.vhd for at least one occurance of a DoubleWsc condition. Insert as often as different ObjectTypes of DoubleWsc condition occure.
{#%- include  "subTemplates/signal_differences_wsc.ja.vhd"%#}

-- Signal definition for eta and phi (inputs of subtractors) for correlation conditions.
-- Insert signal_differences_correlation_conditions.ja.vhd for at least one occurance of a correlation condition of the two ObjectTypes used in the correlation condition.
-- Insert as often as correlation conditions of different ObjectTypes occure.
{#%- include  "subTemplates/signal_differences_correlation_conditions.ja.vhd"%#}

-- Signal definition for muon charge correlation (only once for all muon conditions, except SingleMuon conditions)
-- Insert signal_muon_charge_correlations.ja.vhd for at least one occurance of a DoubleMuon, TripleMuon or QuadMuon condition.
{#%- include  "subTemplates/signal_muon_charge_correlations.ja.vhd"%#}

-- Signal definition for conditions names
{#%- include  "subTemplates/signal_condition.ja.vhd"%#}

-- Signal definition for algorithms names
{%- include  "subTemplates/signal_algorithm.ja.vhd"%}

-- ==== Inserted by TME - end ===============================================================================================================

begin

-- Input register for calorimeter data (used for timing analysis of gtl_fdl_wrapper)
calo_data_in_ff_p: process(lhc_clk, muon_data, eg_data, jet_data, tau_data, ett_data, ht_data, etm_data, htm_data, external_conditions)
    begin
    if (calo_data_inputs_ff = false) then
        muon_data_int <= muon_data;
        eg_data_int <= eg_data;
        jet_data_int <= jet_data;
        tau_data_int <= tau_data;
        ett_data_int <= ett_data;
        htt_data_int <= ht_data;
        etm_data_int <= etm_data;
        htm_data_int <= htm_data;
        external_conditions_int <= external_conditions;
    else
        if (lhc_clk'event and lhc_clk = '1') then
           muon_data_int <= muon_data;
           eg_data_int <= eg_data;
           jet_data_int <= jet_data;
           tau_data_int <= tau_data;
           ett_data_int <= ett_data;
           htt_data_int <= ht_data;
           etm_data_int <= etm_data;
           htm_data_int <= htm_data;
           external_conditions_int <= external_conditions;
        end if;
    end if;
end process;

p_m_2_bx_pipeline_i: entity work.p_m_2_bx_pipeline
    port map(
        lhc_clk,
        muon_data_int, muon_bx_p2, muon_bx_p1, muon_bx_0, muon_bx_m1, muon_bx_m2,
        eg_data_int, eg_bx_p2, eg_bx_p1, eg_bx_0, eg_bx_m1, eg_bx_m2,
        jet_data_int, jet_bx_p2, jet_bx_p1, jet_bx_0, jet_bx_m1, jet_bx_m2,
        tau_data_int, tau_bx_p2, tau_bx_p1, tau_bx_0, tau_bx_m1, tau_bx_m2,
        ett_data_int, ett_bx_p2, ett_bx_p1, ett_bx_0, ett_bx_m1, ett_bx_m2,
        htt_data_int, htt_bx_p2, htt_bx_p1, htt_bx_0, htt_bx_m1, htt_bx_m2,
        etm_data_int, etm_bx_p2, etm_bx_p1, etm_bx_0, etm_bx_m1, etm_bx_m2,
        htm_data_int, htm_bx_p2, htm_bx_p1, htm_bx_0, htm_bx_m1, htm_bx_m2,
        external_conditions_int, ext_cond_bx_p2, ext_cond_bx_p1, ext_cond_bx_0, ext_cond_bx_m1, ext_cond_bx_m2
    );

-- Two pipeline stages for External conditions, because of 2 stages (fixed) in conditions
ext_cond_pipe_p: process(lhc_clk, ext_cond_bx_p2, ext_cond_bx_p1, ext_cond_bx_0, ext_cond_bx_m1, ext_cond_bx_m2)
    begin
    if (lhc_clk'event and lhc_clk = '1') then
        ext_cond_bx_p2_temp <= ext_cond_bx_p2;
        ext_cond_bx_p2_pipe <= ext_cond_bx_p2_temp;
        ext_cond_bx_p1_temp <= ext_cond_bx_p1;
        ext_cond_bx_p1_pipe <= ext_cond_bx_p1_temp;
        ext_cond_bx_0_temp <= ext_cond_bx_0;
        ext_cond_bx_0_pipe <= ext_cond_bx_0_temp;
        ext_cond_bx_m1_temp <= ext_cond_bx_m1;
        ext_cond_bx_m1_pipe <= ext_cond_bx_m1_temp;
        ext_cond_bx_m2_temp <= ext_cond_bx_m2;
        ext_cond_bx_m2_pipe <= ext_cond_bx_m2_temp;
    end if;
end process;

-- ==== Inserted by TME - begin =============================================================================================================

-- Instantiations of eta and phi conversion to integer values - once for every ObjectType in a certain Bx, which is used for correlation conditions
{#%- include  "subTemplates/instance_eta_phi_integer_values.ja.vhd"%#}

-- Instantiations of muon charge correlations - only once in a certain Bx, if there is at least one DoubleMuon, TripleMuon or QuadMuon condition
{#%- include  "subTemplates/instance_muon_charge_correlation.ja.vhd"%#}

-- Instantiations of differences calculation for wsc conditions - once for every ObjectType in a certain Bx with at least one DoubleWsc condition
{#%- include  "subTemplates/instance_difference_eta_wsc.ja.vhd"%#}
{#%- include  "subTemplates/instance_difference_phi_wsc.ja.vhd"%#}

-- Instantiations of differences calculation for calo muon correlation conditions (used for DETA, DPHI and DR) - once for correlation conditions with two ObjectTypes in certain Bxs
{#%- include  "subTemplates/instance_differences_correlation_conditions.ja.vhd"%#}

-- Instantiations of conditions
{%- include  "subTemplates/instance_calo_condition_v2.ja.vhd"%}
{%- include  "subTemplates/instance_muon_condition.ja.vhd"%}
{%- include  "subTemplates/instance_esums_condition.ja.vhd"%}
{#%- include  "subTemplates/instance_calo_muon_correlation_condition.ja.vhd"%#}

-- Instantiations of algorithms 
{#%- include  "subTemplates/instance_algorithm.ja.vhd"%#}

-- ==== Inserted by TME - end ===============================================================================================================

-- One pipeline stages for algorithms
algo_pipeline_p: process(lhc_clk, algo)
    begin
    if (lhc_clk'event and lhc_clk = '1') then
        algo_o <= algo;
    end if;
end process;

end architecture rtl;
