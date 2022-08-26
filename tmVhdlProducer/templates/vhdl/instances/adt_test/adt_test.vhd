{% set thres = condition.objects[0].name.split('_')[2] %}
cond_{{ condition.objects[0].name | lower}}_i: entity work.adt
    generic map({{ thres }})
    port map(
        lhc_clk,
--         clk240: in std_logic;
        bx_data(2).mu,
        bx_data(2).eg,
        bx_data(2).jet,
        bx_data(2).tau,
--         bx_data(2).ett,
--         bx_data(2).htt,
--         bx_data(2).etm,
--         bx_data(2).htm,
--         bx_data(2).ettem,
--         bx_data(2).etmhf,
        {{ condition.vhdl_signal }}
    );

