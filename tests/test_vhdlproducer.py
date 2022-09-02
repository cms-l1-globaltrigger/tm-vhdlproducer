from tmVhdlProducer import vhdlproducer


class TestVhdlProducer:

    def test_hexstr_filter(self):
        r = vhdlproducer.hexstr_filter("Monty Python's Flying Circus", 32)
        assert r == "0000000073756372694320676e69796c462073276e6f687479502079746e6f4d"

    def test_uuid2hex_filter(self):
        r = vhdlproducer.uuid2hex_filter("1d69f777-ade0-4fb7-82f7-2b9afbba4078")
        assert r == "1d69f777ade04fb782f72b9afbba4078"

    def test_bx_encode(self):
        r = vhdlproducer.bx_encode(0)
        assert r == "0"
        r = vhdlproducer.bx_encode(-1)
        assert r == "m1"
        r = vhdlproducer.bx_encode(2)
        assert r == "p2"
