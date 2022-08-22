{% set thres = condition.objects[0].name.split('_')[2] %}
cond_{{ condition.objects[0].name | lower}}_i: entity work.adt
    generic map({{ thres }})
    port map(
        lhc_clk,
--         clk240: in std_logic;
        bx_data.mu,
        bx_data.eg,
        bx_data.jet,
        bx_data.tau,
        bx_data.ett,
        bx_data.htt,
        bx_data.etm,
        bx_data.htm,
        bx_data.ettem,
        bx_data.etmhf,
        {{ condition.vhdl_signal }}
    );
Footer
