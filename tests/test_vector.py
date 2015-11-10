import pytest
import numpy as np
import operator
from geometry import Vector

@pytest.fixture
def a():
    return Vector(1.0, 1.0, 1.0)

@pytest.fixture
def b():
    return Vector(1.0, 0.0, 0.0)

@pytest.fixture
def c():
    return Vector(0.0, 0.0, 1.0)

def test_richmap(a, b):

    assert a == a       # Test equality
    assert not (a == b) # Test equality

    assert a != b       # Test unequality

    with pytest.raises(TypeError):
        a > b

    assert not a == 3.0 # Test other type
    assert not 3.0 == a # Test other type

def test_arithmetics(a):

    """add and mul"""
    assert a+a == 2.0*a

    """sub"""
    assert a-a == Vector(0.0, 0.0, 0.0)

    """div and truediv"""
    assert a/2.0 == Vector(0.5, 0.5, 0.5)

    """pow"""

    """neg"""
    assert -a == Vector(-1.0, -1.0, -1.0)

def test_dot(a, b):
    assert a.dot(b) == 1.0
    assert b.dot(a) == 1.0

def test_cross(a, b, c):

    assert a.cross(b) == Vector(0.0, +1.0, -1.0)
    assert b.cross(a) == Vector(0.0, -1.0, +1.0)

    assert b.cross(c) == Vector(0.0, -1.0, 0.0)
    assert c.cross(b) == Vector(0.0, +1.0, 0.0)

    assert a.cross(c) == Vector(+1.0, -1.0, 0.0)
    assert c.cross(a) == Vector(-1.0, +1.0, 0.0)

def test_norm(a, b, c):

    # Comparing floating point numbers.
    assert a.norm() == 3.0**(0.5)
    assert b.norm() == 1.0
    assert c.norm() == 1.0

def test_normal(a, b):

    assert isinstance(a.normalize(), Vector) # Check that we get a vector back.
    assert b == b.normalize()
    assert a.normalize(), a/a.norm()

def test_cosines_with(b, c):

    assert b.cosines_with(c) == 0.0 # Vectors are orthogonal, so cos(90)=0
    assert b.cosines_with(b) == 1.0 # Vectors are parallel
