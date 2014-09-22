import unittest
import numpy as np
        
from geometry import Point, Vector, Plane, Polygon

class PointCase(unittest.TestCase):
    
    def setUp(self):
    
        self.a = Point(1.0, 1.0, 1.0)
        self.b = Point(1.0, 0.0, 0.0)
        self.c = Point(0.0, 0.0, 1.0)
        self.d = Point(-1.0, 0.0, 0.0)
        
    
    def tearDown(self):
        
        del self.a
        del self.b
        del self.c
    
    def test_arithmetics(self):
        
        import operator
        
        self.assertRaises(TypeError, operator.add, self.a, self.b)
        self.assertRaises(TypeError, operator.sub, self.a, 3.0)
    
        self.assertIsInstance(self.a-self.b, Vector)
    
    def test_to(self):
        
        self.assertIsInstance(self.a.to(self.b), Vector)
        self.assertEqual(self.a.to(self.b), Vector(0.0, -1.0, -1.0))
    
    def test_distance_to(self):
        
        self.assertEqual(self.a.distance_to(self.a), 0.0)
        self.assertEqual(self.b.distance_to(-self.b), 2.0)
        self.assertEqual(self.a.distance_to(self.c), 2.0**0.5)
        
    def test_cosines_with(self):
        
        from math import sqrt
        
        self.assertIsInstance(self.a.cosines_with(self.b), Vector)
        
        self.assertEqual(self.a.cosines_with(self.b), Vector(0.0, -1.0/sqrt(2.0), -1.0/sqrt(2.0)))
    
    
    def test_on_interior_side(self):
        
        plane = Plane.from_normal(Vector(1.0, 0.0, 0.0))
        
        self.assertEqual(self.b.on_interior_side_of(plane), 1)   # Interior side
        self.assertEqual(self.c.on_interior_side_of(plane), 0)   # In plane
        self.assertEqual(self.d.on_interior_side_of(plane), -1)  # Exterior side
        
        points = [ Point(0.0, 0.0, -1.0), Point(0.0, 1.0, -1.0), Point(0.0, 1.0, 0.0), Point(0.0, 0.0, 0.0) ]
        plane = Plane.from_points(points)
        
        self.assertEqual(self.b.on_interior_side_of(plane), 1)   # Interior side
        self.assertEqual(self.c.on_interior_side_of(plane), 0)   # In plane
        self.assertEqual(self.d.on_interior_side_of(plane), -1)  # Exterior side


class PointInFieldAngleCase(unittest.TestCase):
    
    def runTest(self):
        
        corners = [ Point(0.0, 0.0, 0.0), Point(1.0, 0.0, 0.0), Point(1.0, 1.0, 0.0), Point(0.0, 1.0, 0.0) ]
        wall = Polygon(corners, Point(0.5, 0.5, 0.0))
    
        source = Point(0.5, 0.5, 10.0)
    
        receiver = Point(0.5, 0.5, -10.0)
        
        #receiver_plane = Plane()
        
        #receiver.in_field_angle(source, wall, receiver_plane)
    
    #A = Polygon([Point(5.0, 10.0, 10.0), Point(5.0, 10.0, -10.0), Point(5.0, -10.0, -10.0)
    
    
if __name__ == '__main__':
    unittest.main()
    
    
