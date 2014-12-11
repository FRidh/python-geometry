
cdef class Polygon(object):
    """
    3D Polygon defined by points.
    """
    
    #cdef public list points
    #cdef public Point center

    def __init__(self, list points, Point center):

        self.points = points
        """
        Points is an iterable containing :class:`geometry.plane.Point` objects defining the polygon.
        """
        
        self.center = center

    def __repr__(self):
        return "Polygon({})".format(str(self))
        
    def __str__(self):
        return str(self.points)
        
    cpdef Plane plane(self):
        """
        Return the plane of this polygon.
        """
        return Plane.from_points(self.points)
        
    cpdef double area(self):
        """
        Area of a polygon.
        
        .. math:: A = \\frac{1}{2} \\sum_{i=0}^{N-1} \\left( x_{i} y_{i+1} - x_{i+1} y_{i}  \\right)
        
        """
        cdef double A
        cdef int N
        A = 0.0
        N = len(self.points)
        for i in range(0, len(self.points)):
            A += ( self.points[i].x * self.points[(i+1)%N].y  - self.points[(i+1%N)].x * self.points[i].y )
        return A/2.0
   
    def __richcmp__(self, other, op):
        
        if not(op==2 or op==3):
            raise TypeError()
        
        if not isinstance(other, Polygon):
            return False
        
        equal = True if (self.points==other.points and self.center==other.center) else False
        
        if (op==2 and equal==True) or (op==3 and equal==False): # a == b
            return True
        else:
            return False

    #cpdef Point center(self):
        #"""
        #Center of the polygon.
        #"""
        #cdef double C
        #cdef double X
        #cdef double Y  
        #cdef list points
        #points = self.points

        #"""Transform from 3D to 2D"""
        
        
        #"""Calculate center in 2D plane."""
        #C = 0.0
        #X = 0.0
        #Y = 0.0
        #for i in range(0, len(points)):
            #C = points[i].x * points[i+1].y - points[i+1].x * points[i].y
            #X += (points[i].x + points[i+1].x) * C
            #Z += (points[i].y + points[i+1].y) * C
        
        #C = 1.0 / (6.0 * self.area())
        #X *= C
        #Y *= C
        
        #"""Transform base back."""
        
        
        #return Point()
