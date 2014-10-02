
from libc.math cimport atan2, sqrt
from .vector cimport Vector

cdef class Quat(object):

    cdef public double w
    cdef public double x
    cdef public double y
    cdef public double z
    
    cpdef bint unit(Quat)
    cpdef double norm(Quat)
    cpdef Quat normalize(Quat)
    cpdef Quat normalized(Quat)
    cpdef Quat conjugate(Quat)
    cpdef Quat inverse(Quat)
    cpdef double dot(Quat, Quat)
    cpdef tuple to_angle_and_axis(Quat)
    cpdef Vector rotate(Quat, Vector)
    cpdef Vector rotate_inplace(Quat, Vector)
    

cpdef Quat quat_from_angle_and_axis(double, Vector)
