import pytest
from geometry import Polygon, Point, Plane, Vector


@pytest.fixture
def polygon():
    points = [Point(0.0, 0.0, 0.0), Point(1.0, 0.0, 0.0), Point(0.0, 1.0, 0.0)]
    return Polygon(points, Point(0.25, 0.25, 0.0))

def test_plane(polygon):

    assert isinstance(polygon.plane(), Plane)
    assert isinstance(polygon.plane().normal(), Vector)
    assert polygon.plane().normal() == Vector(0.0, 0.0, 1.0)

def test_intersection():

    corners = [ Point(0.0, 0.0, 0.0), Point(1.0, 0.0, 0.0), Point(1.0, 1.0, 0.0), Point(0.0, 1.0, 0.0) ]
    polygon = Polygon(corners, Point(0.5, 0.5, 0.0))

    a = Point(0.5, 0.5, 1.0)
    b = Point(0.5, 0.5, -1.0)

    intersection = polygon.plane().intersection(a, b)

    assert intersection == Point(0.5, 0.5, 0.0)
