import unittest
from geometry import Polygon, Point, Plane, Vector


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
        
        
        
if __name__ == '__main__':
    unittest.main()
    
    
