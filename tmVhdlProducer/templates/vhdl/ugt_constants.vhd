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

-- VHDL producer
-- version: {{ menu.info.sw_version }}
-- hash value: {{ menu.info.sw_hash }}

-- tmEventSetup
-- version: {{ menu.info.version }}

-- Algorithms
constant NR_ALGOS : positive := {{ module.algorithms | length }}; -- number of algorithmns (min. 32 for FDL registers width !!!) - written by TME

constant MODULE_ID : integer := {{ module.id | int }};
-- -- HB 2014-02-28: changed to UUID generated by TME (128 bits = 4 x 32 bits)
constant L1TM_UID : std_logic_vector(127 downto 0) := X"{{ menu.info.uuid_menu | hexuuid }}";
-- -- HB 2014-05-21: L1TM_NAME generated by TME (1024 bits = 32 x 32 bits)
-- -- has to be interpreted as 128 ASCII-characters (from right to left)
constant L1TM_NAME : std_logic_vector(128*8-1 downto 0) := X"{{ menu.info.name | hexstr(128) }}";

-- -- Unique fireware instance ID generated by the compiler, provided to keep track of multiple menu implementations.
constant L1TM_FW_UID : std_logic_vector(127 downto 0) := X"{{ menu.info.uuid_firmware | hexuuid }}";
--
-- -- VHDL Producer software version
constant L1TM_COMPILER_MAJOR_VERSION : integer range 0 to 255 := {{ menu.info.sw_version.major | int }};
constant L1TM_COMPILER_MINOR_VERSION : integer range 0 to 255 := {{ menu.info.sw_version.minor | int }};
constant L1TM_COMPILER_REV_VERSION : integer range 0 to 255 := {{ menu.info.sw_version.patch | int }};
constant L1TM_COMPILER_VERSION : std_logic_vector(31 downto 0) := X"00" &
           std_logic_vector(to_unsigned(L1TM_COMPILER_MAJOR_VERSION, 8)) &
           std_logic_vector(to_unsigned(L1TM_COMPILER_MINOR_VERSION, 8)) &
           std_logic_vector(to_unsigned(L1TM_COMPILER_REV_VERSION, 8));

constant SVN_REVISION_NUMBER : std_logic_vector(31 downto 0) := X"00000000"; -- not used anymore
constant L1TM_UID_HASH : std_logic_vector(31 downto 0) := X"{{ menu.info.name | mmhashn | X08 }}";
constant FW_UID_HASH : std_logic_vector(31 downto 0) := X"{{ menu.info.uuid_firmware | mmhashn | X08 }}";

-- ========================================================
