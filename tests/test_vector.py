import unittest
import numpy as np
import operator
from geometry import Vector

class VectorCase(unittest.TestCase):
    
    def setUp(self):
        
        self.a = Vector(1.0, 1.0, 1.0)
        self.b = Vector(1.0, 0.0, 0.0)
        self.c = Vector(0.0, 0.0, 1.0)
    
    def tearDown(self):
        
        del self.a
        del self.b
        del self.c
    
    def test_richmap(self):
        

        
        self.assertTrue(self.a==self.a)     # Test equality
        self.assertFalse(self.a==self.b)    # Test equality
        
        self.assertTrue(self.a!=self.b)     # Test unequality
        
        self.assertRaises(TypeError, operator.gt, self.a, self.b)  # Test not implemented operators.

        self.assertFalse(self.a==3.0)   # Test other type
        self.assertFalse(3.0==self.a)   # Test other type
    
    def test_arithmetics(self):
        
        """add and mul"""
        self.assertAlmostEqual( self.a + self.a, 2.0 * self.a)
        
        """sub"""
        self.assertAlmostEqual( self.a - self.a, Vector(0.0, 0.0, 0.0))
        
        """div and truediv"""
        self.assertAlmostEqual( self.a / 2.0, Vector(0.5, 0.5, 0.5))
        
        """pow"""
        
        """neg"""
        self.assertEqual( -self.a, Vector(-1.0, -1.0, -1.0))
        
    
    def test_dot(self):
        
        self.assertEqual( self.a.dot(self.b) , 1.0)
        self.assertEqual( self.b.dot(self.a) , 1.0)
    
    def test_cross(self):
        
        self.assertEqual( self.a.cross(self.b), Vector(0.0, +1.0, -1.0) )
        self.assertEqual( self.b.cross(self.a), Vector(0.0, -1.0, +1.0) )
        
        self.assertEqual( self.b.cross(self.c), Vector(0.0, -1.0, 0.0) )
        self.assertEqual( self.c.cross(self.b), Vector(0.0, +1.0, 0.0) )
        
        self.assertEqual( self.a.cross(self.c), Vector(+1.0, -1.0, 0.0) )
        self.assertEqual( self.c.cross(self.a), Vector(-1.0, +1.0, 0.0) )
        
    def test_norm(self):
        
        # Comparing floating point numbers.
        self.assertAlmostEqual(self.a.norm(), 3.0**(0.5))
        self.assertAlmostEqual(self.b.norm(), 1.0)
        self.assertAlmostEqual(self.c.norm(), 1.0)
    
    def test_normal(self):
        
        self.assertIs(type(self.a.normalize()), Vector)   # Check that we get a vector back.
        
        self.assertEqual(self.b, self.b.normalize())
        
        self.assertAlmostEqual(self.a.normalize(), self.a/self.a.norm())
    
    
    def test_cosines_with(self):
        
        self.assertAlmostEqual(self.b.cosines_with(self.c), 0.0) # Vectors are orthogonal, so cos(90)=0
        self.assertAlmostEqual(self.b.cosines_with(self.b), 1.0) # Vectors are parralel
        
if __name__ == '__main__':
    unittest.main()
    
    
