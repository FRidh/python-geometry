import pytest
import numpy as np
import pickle
import tempfile
from geometry import Quat, Vector

def test_arithmetics():

    # Addition
    a = Quat(5., 6., 7., 8.)
    b = Quat(8., 7., 6., 5.)
    assert(a+b == Quat(13., 13., 13., 13.))

    # Subtraction
    assert(a-b == Quat(-3., -1., +1., +3.))

    # Multiplication
    assert(a*2.0 == Quat(10., 12., 14., 16.))
    assert(b*3.0 == Quat(24., 21., 18., 15.))
    assert(a*b != b*a)

    c = Quat(2., 3., 2., 3.)
    d = Quat(3., 2., 3., 2.)
    assert(c*d == Quat(-12., 8., 12., 18.))


def test_rotate():

    axis = Vector(0.0, 0.0, 1.0)
    angle = np.deg2rad(-90.0)
    quat = Quat.from_angle_and_axis(angle, axis)
    vector = Vector(0.0, 5.0, 0.0)

    rotated = Vector(5.0, 0.0, 0.0)

    assert(quat.rotate(vector) == rotated)
    assert(vector.rotate(quat) == rotated)


def test_pickle():
    a = Quat(5., 6., 7., 8.)

    with tempfile.TemporaryDirectory() as tmpdirname:
        with open('obj.pickle', mode='w+b') as f:
            pickle.dump(a, f)

        with open('obj.pickle', mode='r+b') as f:
            a2 = pickle.load(f)

        assert a2 == a
