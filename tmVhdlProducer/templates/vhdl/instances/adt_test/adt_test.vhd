cond_{{ condition.objects[0].name | lower}}_i: entity work.anomaly_detection
    port map(
        open, open,
        lhc_clk, '0', '1',
        open, open, open,
        bx_data(2).mu(0),bx_data(2).mu(1),bx_data(2).mu(2),bx_data(2).mu(3),
        bx_data(2).mu(4),bx_data(2).mu(5),bx_data(2).mu(6),bx_data(2).mu(7),
        bx_data(2).jet(0),bx_data(2).jet(1),bx_data(2).jet(2),bx_data(2).jet(3),
        bx_data(2).jet(4),bx_data(2).jet(5),bx_data(2).jet(6),bx_data(2).jet(7),
        bx_data(2).jet(8),bx_data(2).jet(9),bx_data(2).jet(10),bx_data(2).jet(11),
        bx_data(2).eg(0),bx_data(2).eg(1),bx_data(2).eg(2),bx_data(2).eg(3),
        bx_data(2).eg(4),bx_data(2).eg(5),bx_data(2).eg(6),bx_data(2).eg(7),
        bx_data(2).eg(8),bx_data(2).eg(9),bx_data(2).eg(10),bx_data(2).eg(11),
        bx_data(2).tau(0),bx_data(2).tau(1),bx_data(2).tau(2),bx_data(2).tau(3),
        bx_data(2).tau(4),bx_data(2).tau(5),bx_data(2).tau(6),bx_data(2).tau(7),
        bx_data(2).tau(8),bx_data(2).tau(9),bx_data(2).tau(10),bx_data(2).tau(11),
        bx_data(2).ett,bx_data(2).htt,bx_data(2).etm,bx_data(2).etmhf,"00000000",
        open,
        {{ condition.vhdl_signal }}
    );
