
from .vector cimport Vector

cdef class Edge(object):

    cdef public list points
    cpdef Vector vector(Edge)
