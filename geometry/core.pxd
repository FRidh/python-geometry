cimport numpy as np    
import numpy as np    

cdef class Vector(object)
cdef class Point(object)
cdef class Plane(object)
cdef class Polygon(object)

    
cdef class Vector(object):
    
    cdef public double x
    cdef public double y
    cdef public double z
    
    cpdef double min(Vector)
    cpdef double max(Vector)
    
    cpdef int argmin(Vector)
    cpdef int argmax(Vector)
    
    cpdef double norm(Vector)
    cpdef Vector normalize(Vector)
    
    cpdef double angle(Vector, Vector)
    
    cpdef double dot(Vector, Vector)
    cpdef Vector cross(Vector, Vector)
    
    cpdef double cosines_with(Vector, Vector)
    

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
    

cdef class PointList(object):
    
    cdef np.ndarray _data
    
    cpdef np.ndarray as_array(PointList)


cdef class Edge(object):

    cdef public list points
    cpdef Vector vector(Edge)
    
    
cdef class Plane(object):
    
    cdef public double a
    cdef public double b
    cdef public double c
    cdef public double d
    
    cpdef Vector normal(Plane)
    cpdef Point intersection(Plane, Point, Point)
    cpdef int intersects(Plane, Point, Point)

cdef class Polygon(object):
    cdef public Point center
    cdef public list points
    cpdef Plane plane(Polygon)
    cpdef double area(Polygon)

    

cpdef double dot(Vector a, Vector b)
cpdef Vector cross(Vector a, Vector b)

cpdef Vector cosines(Point, Point)
cpdef double cosine_between_vectors(Vector a, Vector b)
#cdef normal_form(Point, Point, Point)
#cdef reduced_normal_form(double, double, double, double)
cpdef Point foot_point(Point, Plane)
cpdef Point mirror_point(Point, Point)
cpdef Point intersection_point(Plane, Point, Point)
cpdef int is_point_on_interior_side(Point, Plane)
cpdef int is_point_in_field_angle(Point, Point, Polygon, Plane)