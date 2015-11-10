import pytest
import numpy as np
        
from geometry import Point, Vector, Plane, Polygon

@pytest.fixture
def a():
    return Point(1.0, 1.0, 1.0)

@pytest.fixture
def b():
    return Point(1.0, 0.0, 0.0)

@pytest.fixture
def c():
    return Point(0.0, 0.0, 1.0)

@pytest.fixture
def d():
    return Point(-1.0, 0.0, 0.0)

def test_arithmetics(a, b):

    import operator

    with pytest.raises(TypeError):
        a + b

    with pytest.raises(TypeError):
        a - 3.0


def test_to(a, b):

    assert isinstance(a-b, Vector)
    assert a.to(b) == Vector(0.0, -1.0, -1.0)

def test_distance_to(a, b, c):

    assert a.distance_to(a) == 0.0
    assert b.distance_to(-b) == 2.0
    assert a.distance_to(c) == 2.0**0.5

def test_cosines_with(a, b):

    assert isinstance(a.cosines_with(b), Vector)
    assert a.cosines_with(b) == Vector(0.0, -1.0/sqrt(2.0), -1.0/sqrt(2.0))

def test_on_interior_side(a, b, c, d):

    plane = Plane.from_normal(Vector(1.0, 0.0, 0.0))

    assert b.on_interior_side_of(plane) == +1   # Interior side
    assert c.on_interior_side_of(plane) ==  0   # In plane
    assert d.on_interior_side_of(plane) == -1   # Exterior side

    points = [ Point(0.0, 0.0, -1.0), Point(0.0, 1.0, -1.0), Point(0.0, 1.0, 0.0), Point(0.0, 0.0, 0.0) ]
    plane = Plane.from_points(points)

    assert b.on_interior_side_of(plane) == +1   # Interior side
    assert c.on_interior_side_of(plane) ==  0   # In plane
    assert d.on_interior_side_of(plane) == -1   # Exterior side

##class PointInFieldAngleCase(unittest.TestCase):
    
    ##def runTest(self):
        
        ##corners = [ Point(0.0, 0.0, 0.0), Point(1.0, 0.0, 0.0), Point(1.0, 1.0, 0.0), Point(0.0, 1.0, 0.0) ]
        ##wall = Polygon(corners, Point(0.5, 0.5, 0.0))
    
        ##source = Point(0.5, 0.5, 10.0)
    
        ##receiver = Point(0.5, 0.5, -10.0)
        
        ###receiver_plane = Plane()
        
        ###receiver.in_field_angle(source, wall, receiver_plane)
    
    ###A = Polygon([Point(5.0, 10.0, 10.0), Point(5.0, 10.0, -10.0), Point(5.0, -10.0, -10.0)
    
