
from .point cimport Point
from .plane cimport Plane
from .polygon cimport Polygon

cdef class Polygon(object):
    cdef public Point center
    cdef public list points
    cpdef Plane plane(Polygon)
    cpdef double area(Polygon)
