
from .vector cimport Vector
from .point cimport Point

cdef class Plane(object):
    
    cdef public double a
    cdef public double b
    cdef public double c
    cdef public double d
    
    cpdef Vector normal(Plane)
    cpdef Point intersection(Plane, Point, Point)
    cpdef int intersects(Plane, Point, Point)
    
    
cpdef Point intersection_point(Plane, Point, Point)

#cdef normal_form(Point, Point, Point)
#cdef reduced_normal_form(double, double, double, double)

