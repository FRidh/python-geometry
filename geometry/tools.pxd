from .vector cimport Vector
from .quat cimport Quat, quat_from_angle_and_axis

cimport numpy as np

cpdef _rotate(double[:,:], double[:,:], double[:], double[:,:])
