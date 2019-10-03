import unittest

from tmVhdlProducer import vhdlproducer

class VhdlProducerTest(unittest.TestCase):

    def testFilters(self):
        r = vhdlproducer.hexstr_filter("Monty Python's Flying Circus", 32)
        self.assertEqual(r, '0000000073756372694320676e69796c462073276e6f687479502079746e6f4d')
        r = vhdlproducer.uuid2hex_filter('1d69f777-ade0-4fb7-82f7-2b9afbba4078')
        self.assertEqual(r, '1d69f777ade04fb782f72b9afbba4078')
        r = vhdlproducer.bx_encode(0)
        self.assertEqual(r, '0')
        r = vhdlproducer.bx_encode(-1)
        self.assertEqual(r, 'm1')
        r = vhdlproducer.bx_encode(2)
        self.assertEqual(r, 'p2')

if __name__ == '__main__':
    unittest.main()
