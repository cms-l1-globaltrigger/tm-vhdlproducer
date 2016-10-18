-- Description:
-- Global Trigger Logic module.

-- ========================================================
-- from VHDL producer:

-- Module ID: {{ module.id }}

-- Name of L1 Trigger Menu:
-- {{ menu.info.name }}

-- Unique ID of L1 Trigger Menu:
-- {{ menu.info.uuid_menu }}

-- Unique ID of firmware implementation:
-- {{ menu.info.uuid_firmware }}

-- Scale set:
-- {{ menu.info.scale_set }}

-- VHDL producer version
-- v{{ menu.info.sw_version }}

-- ========================================================

-- Version-history:
-- HB 2016-09-16: v1.1.0: Implemented new esums with ETTEM, "TOWERCNT" (ECAL sum), ETMHF and HTMHF.
-- HB 2016-08-31: v1.0.0: Same version as v0.0.10
-- HB 2016-04-22: v0.0.10: Implemented min_bias_hf_conditions.vhd for minimum bias trigger conditions for low-pileup-run in May 2016.
--                         Updated gtl_fdl_wrapper.vhd and p_m_2_bx_pipeline.vhd for minimum bias trigger objects.
-- HB 2016-04-07: v0.0.9: Cleaned-up typing in muon_muon_correlation_condition.vhd (D_S_I_MUON_V2 instead of D_S_I_MUON in some lines).

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

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
-- ****************************************************************************************
-- HB 2016-04-18: updates for "min bias trigger" objects (quantities) for Low-pileup-run May 2016
        mbt1hfp_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt1hfm_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt0hfp_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt0hfm_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
-- HB 2016-06-07: inserted new esums quantities (ETTEM and ETMHF).
        ettem_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        etmhf_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
-- HB 2016-09-16: inserted HTMHF and TOWERCNT
        htmhf_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        towercount_data : in std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0);
-- ****************************************************************************************
        muon_data : in muon_objects_array(0 to NR_MUON_OBJECTS-1);
        external_conditions : in std_logic_vector(NR_EXTERNAL_CONDITIONS-1 downto 0);
        algo_o : out std_logic_vector(NR_ALGOS-1 downto 0));
end gtl_module;

architecture rtl of gtl_module is
    constant external_conditions_pipeline_stages: natural := 2; -- pipeline stages for "External conditions" to get same pipeline to algos as conditions

-- HB 2016-03-08: "workaraound" for VHDL-Producer output
    constant NR_MU_OBJECTS: positive := NR_MUON_OBJECTS;

--     signal muon_bx_p2, muon_bx_p1, muon_bx_0, muon_bx_m1, muon_bx_m2 : muon_objects_array(0 to NR_MUON_OBJECTS-1);
    signal mu_bx_p2, mu_bx_p1, mu_bx_0, mu_bx_m1, mu_bx_m2 : muon_objects_array(0 to NR_MUON_OBJECTS-1);
    signal eg_bx_p2, eg_bx_p1, eg_bx_0, eg_bx_m1, eg_bx_m2 : calo_objects_array(0 to NR_EG_OBJECTS-1);
    signal jet_bx_p2, jet_bx_p1, jet_bx_0, jet_bx_m1, jet_bx_m2 : calo_objects_array(0 to NR_JET_OBJECTS-1);
    signal tau_bx_p2, tau_bx_p1, tau_bx_0, tau_bx_m1, tau_bx_m2 : calo_objects_array(0 to NR_TAU_OBJECTS-1);
    signal ett_bx_p2, ett_bx_p1, ett_bx_0, ett_bx_m1, ett_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
-- HB 2015-04-28: changed for "htt" - object type from TME [string(1 to 3)] in esums_conditions.vhd
    signal htt_bx_p2, htt_bx_p1, htt_bx_0, htt_bx_m1, htt_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal etm_bx_p2, etm_bx_p1, etm_bx_0, etm_bx_m1, etm_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal htm_bx_p2, htm_bx_p1, htm_bx_0, htm_bx_m1, htm_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
-- ****************************************************************************************
-- HB 2016-04-18: updates for "min bias trigger" objects (quantities) for Low-pileup-run May 2016
    signal mbt1hfp_bx_p2, mbt1hfp_bx_p1, mbt1hfp_bx_0, mbt1hfp_bx_m1, mbt1hfp_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal mbt1hfm_bx_p2, mbt1hfm_bx_p1, mbt1hfm_bx_0, mbt1hfm_bx_m1, mbt1hfm_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal mbt0hfp_bx_p2, mbt0hfp_bx_p1, mbt0hfp_bx_0, mbt0hfp_bx_m1, mbt0hfp_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal mbt0hfm_bx_p2, mbt0hfm_bx_p1, mbt0hfm_bx_0, mbt0hfm_bx_m1, mbt0hfm_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
-- HB 2016-06-07: inserted new esums quantities (ETTEM and ETMHF).
    signal ettem_bx_p2, ettem_bx_p1, ettem_bx_0, ettem_bx_m1, ettem_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal etmhf_bx_p2, etmhf_bx_p1, etmhf_bx_0, etmhf_bx_m1, etmhf_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
-- HB 2016-09-16: inserted HTMHF and TOWERCNT
    signal htmhf_bx_p2, htmhf_bx_p1, htmhf_bx_0, htmhf_bx_m1, htmhf_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal towercount_bx_p2, towercount_bx_p1, towercount_bx_0, towercount_bx_m1, towercount_bx_m2 : std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0);
-- ****************************************************************************************
-- HB 2016-01-08: renamed ext_cond after +/-2bx to ext_cond_bx_p2_int, etc., because ext_cond_bx_p2, etc. used in algos (names coming from TME grammar).
    signal ext_cond_bx_p2_int, ext_cond_bx_p1_int, ext_cond_bx_0_int, ext_cond_bx_m1_int, ext_cond_bx_m2_int : std_logic_vector(NR_EXTERNAL_CONDITIONS-1 downto 0);
    signal ext_cond_bx_p2, ext_cond_bx_p1, ext_cond_bx_0, ext_cond_bx_m1, ext_cond_bx_m2 : std_logic_vector(NR_EXTERNAL_CONDITIONS-1 downto 0);

    signal algo : std_logic_vector(NR_ALGOS-1 downto 0) := (others => '0');

-- ==== Inserted by TME - begin =============================================================================================================

-- Signal definition of pt, eta and phi for correlation conditions.
-- Insert "signal_correlation_conditions_pt_eta_phi.vhd.j2" as often as an ObjectType at a certain Bx is used in a correlation condition.
{%- include  "subTemplates/signal_correlation_conditions_pt_eta_phi.vhd.j2" %}

-- Signal definition of differences for correlation conditions.
-- Insert "signal_correlation_conditions_differences.vhd.j2" once for correlation conditions of different ObjectTypes and Bx combinations.
{%- include  "subTemplates/signal_correlation_conditions_differences.vhd.j2" %}

-- Signal definition for muon charge correlations.
-- Insert "signal_muon_charge_correlations.vhd.j2" only once for a certain Bx combination,
-- if there is at least one muon condition or one muon-muon correlation condition.
{%- include  "subTemplates/signal_muon_charge_correlations.vhd.j2" %}

-- Signal definition for conditions names
{%- for condition in module.conditions %}
    signal {{ condition.vhdl_signal }} : std_logic;
{%- endfor %}

-- Signal definition for algorithms names
{%- for algorithm in module.algorithms|sort_by_attribute('index') %}
    signal {{ algorithm.vhdl_signal }} : std_logic;
{%- endfor %}

-- ==== Inserted by TME - end ===============================================================================================================

begin

p_m_2_bx_pipeline_i: entity work.p_m_2_bx_pipeline
    port map(
        lhc_clk,
--         muon_data, muon_bx_p2, muon_bx_p1, muon_bx_0, muon_bx_m1, muon_bx_m2,
        muon_data, mu_bx_p2, mu_bx_p1, mu_bx_0, mu_bx_m1, mu_bx_m2,
        eg_data, eg_bx_p2, eg_bx_p1, eg_bx_0, eg_bx_m1, eg_bx_m2,
        jet_data, jet_bx_p2, jet_bx_p1, jet_bx_0, jet_bx_m1, jet_bx_m2,
        tau_data, tau_bx_p2, tau_bx_p1, tau_bx_0, tau_bx_m1, tau_bx_m2,
        ett_data, ett_bx_p2, ett_bx_p1, ett_bx_0, ett_bx_m1, ett_bx_m2,
        ht_data, htt_bx_p2, htt_bx_p1, htt_bx_0, htt_bx_m1, htt_bx_m2,
        etm_data, etm_bx_p2, etm_bx_p1, etm_bx_0, etm_bx_m1, etm_bx_m2,
        htm_data, htm_bx_p2, htm_bx_p1, htm_bx_0, htm_bx_m1, htm_bx_m2,
-- ****************************************************************************************
-- HB 2016-04-18: updates for "min bias trigger" objects (quantities) for Low-pileup-run May 2016
	mbt1hfp_data, mbt1hfp_bx_p2, mbt1hfp_bx_p1, mbt1hfp_bx_0, mbt1hfp_bx_m1, mbt1hfp_bx_m2,
	mbt1hfm_data, mbt1hfm_bx_p2, mbt1hfm_bx_p1, mbt1hfm_bx_0, mbt1hfm_bx_m1, mbt1hfm_bx_m2,
	mbt0hfp_data, mbt0hfp_bx_p2, mbt0hfp_bx_p1, mbt0hfp_bx_0, mbt0hfp_bx_m1, mbt0hfp_bx_m2,
	mbt0hfm_data, mbt0hfm_bx_p2, mbt0hfm_bx_p1, mbt0hfm_bx_0, mbt0hfm_bx_m1, mbt0hfm_bx_m2,
-- HB 2016-06-07: inserted new esums quantities (ETTEM and ETMHF).
        ettem_data, ettem_bx_p2, ettem_bx_p1, ettem_bx_0, ettem_bx_m1, ettem_bx_m2,
        etmhf_data, etmhf_bx_p2, etmhf_bx_p1, etmhf_bx_0, etmhf_bx_m1, etmhf_bx_m2,
-- HB 2016-09-16: inserted HTMHF and TOWERCNT
        htmhf_data, htmhf_bx_p2, htmhf_bx_p1, htmhf_bx_0, htmhf_bx_m1, htmhf_bx_m2,
        towercount_data, towercount_bx_p2, towercount_bx_p1, towercount_bx_0, towercount_bx_m1, towercount_bx_m2,
-- ****************************************************************************************
-- HB 2016-01-08: renamed ext_cond after +/-2bx to ext_cond_bx_p2_int, etc., because ext_cond_bx_p2, etc. used in algos (names coming from TME grammar).
        external_conditions, ext_cond_bx_p2_int, ext_cond_bx_p1_int, ext_cond_bx_0_int, ext_cond_bx_m1_int, ext_cond_bx_m2_int
    );

-- Parameterized pipeline stages for External conditions, actually 2 stages (fixed) in conditions, see "constant external_conditions_pipeline_stages ..."
-- HB 2016-01-08: renamed ext_cond after +/-2bx to ext_cond_bx_p2_int, etc., because ext_cond_bx_p2, etc. used in algos (names coming from TME grammar).
ext_cond_pipe_p: process(lhc_clk, ext_cond_bx_p2_int, ext_cond_bx_p1_int, ext_cond_bx_0_int, ext_cond_bx_m1_int, ext_cond_bx_m2_int)
    type ext_cond_pipe_array is array (0 to external_conditions_pipeline_stages+1) of std_logic_vector(NR_EXTERNAL_CONDITIONS-1 downto 0);
    variable ext_cond_bx_p2_pipe_temp : ext_cond_pipe_array := (others => (others => '0'));
    variable ext_cond_bx_p1_pipe_temp : ext_cond_pipe_array := (others => (others => '0'));
    variable ext_cond_bx_0_pipe_temp : ext_cond_pipe_array := (others => (others => '0'));
    variable ext_cond_bx_m1_pipe_temp : ext_cond_pipe_array := (others => (others => '0'));
    variable ext_cond_bx_m2_pipe_temp : ext_cond_pipe_array := (others => (others => '0'));
    begin
        ext_cond_bx_p2_pipe_temp(external_conditions_pipeline_stages+1) := ext_cond_bx_p2_int;
        ext_cond_bx_p1_pipe_temp(external_conditions_pipeline_stages+1) := ext_cond_bx_p1_int;
        ext_cond_bx_0_pipe_temp(external_conditions_pipeline_stages+1) := ext_cond_bx_0_int;
        ext_cond_bx_m1_pipe_temp(external_conditions_pipeline_stages+1) := ext_cond_bx_m1_int;
        ext_cond_bx_m2_pipe_temp(external_conditions_pipeline_stages+1) := ext_cond_bx_m2_int;
        if (external_conditions_pipeline_stages > 0) then 
            if (lhc_clk'event and (lhc_clk = '1') ) then
                ext_cond_bx_p2_pipe_temp(0 to external_conditions_pipeline_stages) := ext_cond_bx_p2_pipe_temp(1 to external_conditions_pipeline_stages+1);
                ext_cond_bx_p1_pipe_temp(0 to external_conditions_pipeline_stages) := ext_cond_bx_p1_pipe_temp(1 to external_conditions_pipeline_stages+1);
                ext_cond_bx_0_pipe_temp(0 to external_conditions_pipeline_stages) := ext_cond_bx_0_pipe_temp(1 to external_conditions_pipeline_stages+1);
                ext_cond_bx_m1_pipe_temp(0 to external_conditions_pipeline_stages) := ext_cond_bx_m1_pipe_temp(1 to external_conditions_pipeline_stages+1);
                ext_cond_bx_m2_pipe_temp(0 to external_conditions_pipeline_stages) := ext_cond_bx_m2_pipe_temp(1 to external_conditions_pipeline_stages+1);
            end if;
        end if;
        ext_cond_bx_p2 <= ext_cond_bx_p2_pipe_temp(1); -- used pipe_temp(1) instead of pipe_temp(0), to prevent warnings in compilation
        ext_cond_bx_p1 <= ext_cond_bx_p1_pipe_temp(1);
        ext_cond_bx_0 <= ext_cond_bx_0_pipe_temp(1);
        ext_cond_bx_m1 <= ext_cond_bx_m1_pipe_temp(1);
        ext_cond_bx_m2 <= ext_cond_bx_m2_pipe_temp(1);
end process;

-- ==== Inserted by TME - begin =============================================================================================================

-- External condition assignment
{%- for condition in module.externalConditions %}
    {{ condition.vhdl_signal }} <= ext_cond_bx_{{ condition.objects[0].bx }}({{ condition.objects[0].externalChannelId }}); -- {{ condition.vhdl_signal }}
{%- endfor %}

-- Instantiations of muon charge correlations - only once for a certain Bx combination, if there is at least one DoubleMuon, TripleMuon, QuadMuon condition
-- or muon-muon correlation condition.
{%- include  "subTemplates/muon_charge_correlations.vhd.j2" %}

-- Instantiations of pt, eta and phi for correlation conditions (used for DETA, DPHI and DR) - once for every ObjectType in certain Bx used in correlation conditions
{%- include  "subTemplates/correlation_conditions_pt_eta_phi.vhd.j2" %}

-- Instantiations of eta and phi conversion to muon scale for calo-muon and muon-esums correlation conditions (used for DETA, DPHI and DR) - once for every calo ObjectType in certain Bx used in correlation conditions
{%- include  "subTemplates/correlation_conditions_eta_phi_conversion.vhd.j2" %}

-- Instantiations of differences for correlation conditions (used for DETA, DPHI and DR) - once for correlation conditions with two ObjectTypes in certain Bxs
{%- include  "subTemplates/correlation_conditions_differences.vhd.j2" %}

-- Instantiations of cosh-deta and cos-dphi LUTs for correlation conditions (used for invariant mass) - once for correlation conditions with two ObjectTypes in certain Bxs
{%- include  "subTemplates/correlation_conditions_inv_mass.vhd.j2" %}

-- Instantiations of conditions
{%- for condition in module.caloConditions %}
{%- include  "subTemplates/calo_condition_v3.vhd.j2" %}
{%- endfor %}

{%- for condition in module.muonConditions %}
{%- include  "subTemplates/muon_condition_v3.vhd.j2" %}
{%- endfor %}

{%- for condition in module.esumsConditions %}
{%- include  "subTemplates/esums_condition.vhd.j2" %}
{%- endfor %}

{%- for condition in module.caloCaloCorrConditions %}
{%- include  "subTemplates/calo_calo_correlation_condition.vhd.j2" %}
{%- endfor %}

{%- for condition in module.caloMuonCorrConditions %}
{%- include  "subTemplates/calo_muon_correlation_condition.vhd.j2" %}
{%- endfor %}

{%- for condition in module.muonMuonCorrConditions %}
{%- include  "subTemplates/muon_muon_correlation_condition.vhd.j2" %}
{%- endfor %}

{%- for condition in module.caloEsumCorrConditions %}
{%- include  "subTemplates/calo_esums_correlation_condition.vhd.j2" %}
{%- endfor %}

{%- for condition in module.muonEsumCorrConditions %}
{%- include  "subTemplates/muon_esums_correlation_condition.vhd.j2" %}
{%- endfor %}

{%- for condition in module.minBiasConditions %}
{%- include  "subTemplates/min_bias_hf_condition.vhd.j2" %}
{%- endfor %}

{%- for condition in module.towerCountConditions %}
{%- include  "subTemplates/towercount_condition.vhd.j2" %}
{%- endfor %}

-- Instantiations of algorithms
{% for algorithm in module.algorithms|sort_by_attribute('index') %}
-- {{ algorithm.index }} {{ algorithm.name }} : {{ algorithm.expression }}
{{ algorithm.vhdl_signal }} <= {{ algorithm.vhdl_expression }};
algo({{ algorithm.module_index | d}}) <= {{ algorithm.vhdl_signal }};
{% endfor %}

-- ==== Inserted by TME - end ===============================================================================================================

-- One pipeline stages for algorithms
algo_pipeline_p: process(lhc_clk, algo)
    begin
    if (lhc_clk'event and lhc_clk = '1') then
        algo_o <= algo;
    end if;
end process;

end architecture rtl;
