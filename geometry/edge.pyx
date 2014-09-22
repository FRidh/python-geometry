
cdef class Edge(object):
    """
    The edge represents a line segment.
    """

    #cdef public list points
    
    def __init__(self, list points):
        
        self.points = points
    
    #cpdef double length(self):
        #return distance(self.points[1], self.points[0])
        
    cpdef Vector vector(self):
        """
        Return vector of this line.
        """
        return Vector(
            self.points[1].x-self.points[0].x, 
            self.points[1].y-self.points[0].y,
            self.points[1].z-self.points[0].z
            )
    
    #@classmethod
    #def from_vector(cls, Vector vector):
