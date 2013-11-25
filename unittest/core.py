
import unittest
import numpy as np
        
from geometry import Point, Edge, Vector, Plane, Polygon, PointList

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
        
        import operator
        
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
        
        
class PlaneCase(unittest.TestCase):
    
    def setUp(self):
        pass
    
    def tearDown(self):
        pass
    
    def test_from_normal_and_point(self):
        
        corners1 = [ Point(0.0, 0.0, 0.0), Point(1.0, 0.0, 0.0), Point(1.0, 1.0, 0.0), Point(0.0, 1.0, 0.0) ]
        center1 = Point(0.5, 0.5, 0.0)
        polygon1 = Polygon(corners1, center1)
        plane1 = Plane.from_normal_and_point(polygon1.plane().normal(), center1)
        self.assertEqual(polygon1.plane(), plane1)    # tests the reduced normal form coefficients.
        
        
        corners2 = [ Point(0.0, 0.0, 0.0), Point(0.0, 1.0, 0.0), Point(0.0, 1.0, 1.0), Point(0.0, 0.0, 1.0) ]
        center2 = Point(0.0, 0.5, 0.5)
        polygon2 = Polygon(corners2, center2)
        plane2 = Plane.from_normal_and_point(polygon2.plane().normal(), center2)
        self.assertEqual(polygon2.plane(), plane2)
        
        
        corners4 = [ Point(1.0, 0.0, 0.0), Point(1.0, 1.0, 0.0), Point(1.0, 1.0, 1.0), Point(1.0, 0.0, 1.0) ]
        center4 = Point(1.0, 0.5, 0.5)
        polygon4 = Polygon(corners4, center4)
        plane4 = Plane.from_normal_and_point(polygon4.plane().normal(), center4)
        self.assertEqual(polygon4.plane(), plane4)
        

    def test_intersection(self):

        plane = Plane(0.0, 0.0, 1.0, -0.9)
        a = Point(0.5, 0.5, -0.9)
        b = Point(0.0, 0.0, 0.0)
        self.assertEqual(plane.intersection(a, b), Point(-0.5, -0.5, 0.9))
        
        
        
        points = [Point(0.5, 0.0, 0.0), Point(0.5, 1.0, 0.0), Point(0.5, 1.0, 1.0), Point(0.5, 0.1, 1.0)]
        polygon = Polygon(points, Point(0.5, 0.5, 0.5))
        
        source = Point(0.5, 0.5, 0.5)
        mirror = source.mirror_with(Plane.from_normal_and_point(Vector(1.0, 0.0, 0.0), Point(1.0, 0.5, 0.5)))
        intersection = polygon.plane().intersection(mirror, Point(1.0, 0.0, 0.0))
        
        self.assertEqual(intersection, Point(0.5, -0.5, -0.5))
        
        


class PolygonCase(unittest.TestCase):
    
    
    def setUp(self):
        
        points = [Point(0.0, 0.0, 0.0), Point(1.0, 0.0, 0.0), Point(0.0, 1.0, 0.0)]
        
        self.polygon = Polygon(points, Point(0.25, 0.25, 0.0))

    def tearDown(self):
        
        del self.polygon
    
    def test_plane(self):
        
        self.assertIsInstance(self.polygon.plane(), Plane)
        
        self.assertIsInstance(self.polygon.plane().normal(), Vector)
        self.assertEqual(self.polygon.plane().normal(), Vector(0.0, 0.0, 1.0))
 
    def test_intersection(self):
        
        corners = [ Point(0.0, 0.0, 0.0), Point(1.0, 0.0, 0.0), Point(1.0, 1.0, 0.0), Point(0.0, 1.0, 0.0) ]
        polygon = Polygon(corners, Point(0.5, 0.5, 0.0))
        
        a = Point(0.5, 0.5, 1.0)
        b = Point(0.5, 0.5, -1.0)
        
        intersection = polygon.plane().intersection(a, b)
        
        self.assertEqual(intersection, Point(0.5, 0.5, 0.0))
        #print intersection
        

class PointListCase(unittest.TestCase):
    
    def test_creation(self):
        
        x =  np.ones((10,3))
        p = PointList(x)

        y = [ Point(1,2,3), Point(2,1,3) ]
        p = PointList(y)
    
        
    def test_assignment(self):
        
        p = PointList([Point(1,2,3)])
        
        
        p[0] = Point(3,2,1)
        
        print p.as_array()
        
        self.assertEqual(p[0], Point(3,2,1))
        
    def test_as_array(self):
        
        x =  np.random.randn(100,3)
        print x.shape
        p = PointList(x)

        np.testing.assert_array_equal(x, p.as_array())
        
    

#class SignCase(unittest.TestCase):
    #def runTest(self):
        #self.assertEqual(sign(+1.0), +1)
        #self.assertEqual(sign(0.0), 0)
        #self.assertEqual(sign(-1.0), -1)


        
if __name__ == '__main__':
    unittest.main()
    
    