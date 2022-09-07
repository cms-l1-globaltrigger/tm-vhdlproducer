from collections import namedtuple

from tmVhdlProducer import vhdlhelper


CutHandle = namedtuple("CutHandle", "data")


class TestVhdlHelper:

    def test_snakecase(self):
        r = vhdlhelper.snakecase("CamelCaseLabel")
        assert r == "camel_case_label"

        r = vhdlhelper.snakecase("CamelCaseLabel", separator="-")
        assert r == "camel-case-label"

    def test_unique_name(self):
        r = vhdlhelper.unique_name("foo", [])
        assert r == "foo"

        r = vhdlhelper.unique_name("foo", ["foo", "foo_1"])
        assert r == "foo_2"

        r = vhdlhelper.unique_name("foo", ["foo_1", "foo_2"])
        assert r == "foo"

    def test_vhdl_bool(self):
        ref = {
            0: "false",
            1: "true",
            42: "true",
            -42: "true"
        }
        for key, value in ref.items():
            r = vhdlhelper.vhdl_bool(key)
            assert r == value

    def test_vhdl_label(self):
        r = vhdlhelper.vhdl_label("001FooBar.value__@2_$")
        assert r == "d001_foo_bar_value_2"

    def test_vhdl_expression(self):
        r = vhdlhelper.vhdl_expression("(singleMu_1 and doubleMu_2)")
        assert r == "( single_mu_1 and double_mu_2 )"

    def test_charge_encode(self):
        ref = {
            "positive": "pos",
            "pos": "pos",
            "1": "pos",
            "negative": "neg",
            "neg": "neg",
            "-1": "neg",
            "ign": "ign",
            "positron": "ign",
            "": "ign",
        }
        for key, value in ref.items():
            r = vhdlhelper.charge_encode(key)
            assert r == value

    def test_charge_correlation_encode(self):
        ref = {
            "like": "ls",
            "ls": "ls",
            "0": "ls",
            "opposite": "os",
            "os": "os",
            "1": "os",
            "ign": "ig",
            "positron": "ig",
            "": "ig",
        }
        for key, value in ref.items():
            r = vhdlhelper.charge_correlation_encode(key)
            assert r == value

    def test_bx_encode(self):
        ref = {
            2: "p2",
            1: "p1",
            0: "0",
            -1: "m1",
            -2: "m2",
        }
        for key, value in ref.items():
            r = vhdlhelper.bx_encode(key)
            assert r == value

    def test_bx_encode_4_array(self):
        ref = {
            2: "0",
            1: "1",
            0: "2",
            -1: "3",
            -2: "4",
        }
        for key, value in ref.items():
            r = vhdlhelper.bx_encode_4_array(key)
            assert r == value

    def test_cut_helper(self):
        cut = vhdlhelper.CutHelper()
        assert not cut.enabled

    def test_boolean_cut_helper(self):
        cut = vhdlhelper.BooleanCutHelper()
        assert not cut.enabled
        assert not cut.state
        cut.update(CutHandle(data="1"))
        assert cut.enabled
        assert cut.state
        cut.update(CutHandle(data="0"))
        assert cut.enabled
        assert not cut.state
