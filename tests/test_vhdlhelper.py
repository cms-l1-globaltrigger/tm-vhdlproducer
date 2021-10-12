import unittest

from tmVhdlProducer import vhdlhelper

class VhdlHelperTest(unittest.TestCase):

    def test_snakecase(self):
        r = vhdlhelper.snakecase('CamelCaseLabel')
        self.assertEqual(r, 'camel_case_label')

        r = vhdlhelper.snakecase('CamelCaseLabel', separator='-')
        self.assertEqual(r, 'camel-case-label')

    def test_unique_name(self):
        r = vhdlhelper.unique_name('foo', [])
        self.assertEqual(r, 'foo')

        r = vhdlhelper.unique_name('foo', ['foo', 'foo_1'])
        self.assertEqual(r, 'foo_2')

        r = vhdlhelper.unique_name('foo', ['foo_1', 'foo_2'])
        self.assertEqual(r, 'foo')

    def test_vhdl_bool(self):
        ref = {
            0: 'false',
            1: 'true',
            42: 'true',
            -42: 'true'
        }
        for key, value in ref.items():
            r = vhdlhelper.vhdl_bool(key)
            self.assertEqual(r, value)

    def test_vhdl_label(self):
        r = vhdlhelper.vhdl_label('001FooBar.value__@2_$')
        self.assertEqual(r, 'd001_foo_bar_value_2')

    def test_vhdl_expression(self):
        r = vhdlhelper.vhdl_expression('(singleMu_1 and doubleMu_2)')
        self.assertEqual(r, '( single_mu_1 and double_mu_2 )')

    def test_charge_encode(self):
        ref = {
            'positive': 'pos',
            'pos': 'pos',
            '1': 'pos',
            'negative': 'neg',
            'neg': 'neg',
            '-1': 'neg',
            'ign': 'ign',
            'positron': 'ign',
            '': 'ign',
        }
        for key, value in ref.items():
            r = vhdlhelper.charge_encode(key)
            self.assertEqual(r, value)

    def test_charge_correlation_encode(self):
        ref = {
            'like': 'ls',
            'ls': 'ls',
            '0': 'ls',
            'opposite': 'os',
            'os': 'os',
            '1': 'os',
            'ign': 'ig',
            'positron': 'ig',
            '': 'ig',
        }
        for key, value in ref.items():
            r = vhdlhelper.charge_correlation_encode(key)
            self.assertEqual(r, value)

    def test_bx_encode(self):
        ref = {
            2: 'p2',
            1: 'p1',
            0: '0',
            -1: 'm1',
            -2: 'm2',
        }
        for key, value in ref.items():
            r = vhdlhelper.bx_encode(key)
            self.assertEqual(r, value)

    def test_bx_encode_4_array(self):
        ref = {
            2: '0',
            1: '1',
            0: '2',
            -1: '3',
            -2: '4',
        }
        for key, value in ref.items():
            r = vhdlhelper.bx_encode_4_array(key)
            self.assertEqual(r, value)

if __name__ == '__main__':
    unittest.main()
