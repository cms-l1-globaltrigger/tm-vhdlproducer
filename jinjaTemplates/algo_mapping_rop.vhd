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
-- $HeadURL: svn://heros.hephy.at/GlobalTriggerUpgrade/software/l1triggermenu/compiler/trunk/templates/mp7/algo_mapping_rop.vhd $
-- $Date: 2014-09-04 17:15:46 +0200 (Thu, 04 Sep 2014) $
-- $Author: arnold $
-- $Revision: 3144 $
--------------------------------------------------------------------------------

-- Desription:
-- Mapping of algo indexes for ROP

-- ========================================================
-- from TME:

-- Unique ID of L1 Trigger Menu:
-- {L1TMenuUUID}

-- Name of L1 Trigger Menu:
-- {L1TMenuName}

-- Version of L1 Trigger Menu Compiler:
-- v{L1TMCompilerVersionMajor}.{L1TMCompilerVersionMinor}.{L1TMCompilerVersionRevision}

-- ========================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.ALL;
use work.gt_mp7_core_pkg.all;

entity algo_mapping_rop is
    port(
        lhc_clk : in std_logic;
        algo_before_prescaler : in std_logic_vector(NR_ALGOS-1 downto 0);
        algo_after_prescaler : in std_logic_vector(NR_ALGOS-1 downto 0);
        algo_after_finor_mask : in std_logic_vector(NR_ALGOS-1 downto 0);
        algo_before_prescaler_rop : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_prescaler_rop : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_finor_mask_rop : out std_logic_vector(MAX_NR_ALGOS-1 downto 0)
    );
end algo_mapping_rop;

architecture rtl of algo_mapping_rop is
    signal a_b_p: std_logic_vector(NR_ALGOS-1 downto 0);
    signal a_a_p: std_logic_vector(NR_ALGOS-1 downto 0);
    signal a_a_f: std_logic_vector(NR_ALGOS-1 downto 0);
    signal algo_before_prescaler_rop_int: std_logic_vector(MAX_NR_ALGOS-1 downto 0);
    signal algo_after_prescaler_rop_int: std_logic_vector(MAX_NR_ALGOS-1 downto 0);
    signal algo_after_finor_mask_rop_int: std_logic_vector(MAX_NR_ALGOS-1 downto 0);
begin

a_b_p <= algo_before_prescaler;
a_a_p <= algo_after_prescaler;
a_a_f <= algo_after_finor_mask;

-- ==== Inserted by TME - begin =============================================================================================================

algo_before_prescaler_rop_int <= (
{%- for algoName in menu.reporter['index_sorted'] %}
{%- set algoDict = menu.reporter['algoDict'][algoName] %}
{%- set algoIndex = algoDict["index"] %}
{%- if algoIndex in menu.reporter['m2a'][iMod]%}
{%- set localAlgoIndex = menu.reporter['a2m'][algoIndex][1] %}
{{algoIndex}} => a_b_p({{localAlgoIndex}}),
{%-endif%}
{%-endfor%}
others => '0');

algo_after_prescaler_rop_int <= (
{%- for algoName in menu.reporter['index_sorted'] %}
{%- set algoDict = menu.reporter['algoDict'][algoName] %}
{%- set algoIndex = algoDict["index"] %}
{%- if algoIndex in menu.reporter['m2a'][iMod]%}
{%- set localAlgoIndex = menu.reporter['a2m'][algoIndex][1] %}
{{algoIndex}} => a_a_p({{localAlgoIndex}}),
{%-endif%}
{%-endfor%}
others => '0');

algo_after_finor_mask_rop_int <= (
{%- for algoName in menu.reporter['index_sorted'] %}
{%- set algoDict = menu.reporter['algoDict'][algoName] %}
{%- set algoIndex = algoDict["index"] %}
{%- if algoIndex in menu.reporter['m2a'][iMod]%}
{%- set localAlgoIndex = menu.reporter['a2m'][algoIndex][1] %}
{{algoIndex}} => a_a_f({{localAlgoIndex}}),
{%-endif%}
{%-endfor%}
others => '0');

{#-{AlgoIndexRop:d} => a_a_f({AlgoIndexGtl:d}),#}
{#-      algo_before_prescaler_rop_int <= ({AssignmentAbp} others => '0');       #}
{#-      algo_after_prescaler_rop_int <= ({AssignmentAap} others => '0');       #}
-- ==== Inserted by TME - end ===============================================================================================================

algo_2_rop_p: process(lhc_clk, algo_before_prescaler_rop_int, algo_after_prescaler_rop_int, algo_after_finor_mask_rop_int)
    begin
    if lhc_clk'event and lhc_clk = '1' then
        algo_before_prescaler_rop <= algo_before_prescaler_rop_int;
        algo_after_prescaler_rop <= algo_after_prescaler_rop_int;
        algo_after_finor_mask_rop <= algo_after_finor_mask_rop_int;
    end if;
end process;

end architecture rtl;
