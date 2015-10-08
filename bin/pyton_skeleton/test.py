import sys
import os

CUR_DIR = os.path.abspath(os.path.dirname(__file__))
PAR_DIR = os.path.abspath(os.path.join(CUR_DIR, os.path.pardir))

sys.path.append(os.path.abspath(PAR_DIR))
sys.path.append(os.path.abspath(CUR_DIR))

from unittest import TestCase


class simpleTest(TestCase):
    def setUp(self):
        pass

    def tearDown(self):
        pass

    def testExample(self):
        self.assertEqual(1, 1)

    def testOther(self):
        self.assertNotEqual(0, 1)

if '__main__' == __name__:
    import unittest
    unittest.main()
