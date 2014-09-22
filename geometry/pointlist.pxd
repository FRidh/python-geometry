from .point cimport Point
cimport numpy as np

cdef class PointList(object):
    
    cdef np.ndarray _data
    
    cpdef np.ndarray as_array(PointList)


