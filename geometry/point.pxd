
from .vector cimport Vector
from .plane cimport Plane
from .polygon cimport Polygon


cdef class Point(object):
    
    cdef public double x
    cdef public double y
    cdef public double z
    
    cpdef Vector cosines_with(Point, Point)
    cpdef double distance_to(Point, Point)
    cpdef Vector to(Point, Point)
    
    cpdef Point mirror_with(Point, Plane)
    cpdef int on_interior_side_of(Point, Plane)
    cpdef int in_field_angle(Point, Point, Polygon, Plane)
    
cpdef Point foot_point(Point, Plane)
cpdef Point mirror_point(Point, Point)
cpdef Vector cosines(Point, Point)

cpdef int is_point_on_interior_side(Point, Plane)
cpdef int is_point_in_field_angle(Point, Point, Polygon, Plane)
