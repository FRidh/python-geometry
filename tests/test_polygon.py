import pytest
from geometry import Polygon, Point, Plane, Vector
import tempfile
import pickle


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

def test_mirror(polygon):

    assert polygon.mirror().points == polygon.points[::-1]

def test_pickle(polygon):

    with tempfile.TemporaryDirectory() as tmpdirname:
        with open('obj.pickle', mode='w+b') as f:
            pickle.dump(polygon, f)

        with open('obj.pickle', mode='r+b') as f:
            polygon2 = pickle.load(f)

        assert polygon2 == polygon
