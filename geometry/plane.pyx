
cdef class Plane(object):
    """
    Plane specified by reduced normal form.
    
    A plane is a flat, two-dimensional surface.
    """
    
    #cdef public double a
    #cdef public double b
    #cdef public double c
    #cdef public double d
    
    def __init__(self, double a, double b, double c, double d):

        self.a = a
        self.b = b
        self.c = c
        self.d = d

    cpdef Vector normal(self):
        """
        normal()
        
        Normal vector of plane.
        
        :returns: Vector
        :rtype: :class:`geometry.vector.Vector`
        
        """
        return Vector(self.a, self.b, self.c)
    
    cpdef Point intersection(self, Point a, Point b):
        """
        intersection(a, b)
        
        Determine the point where a line specified by the points ``a`` and ``b`` intersect this plane.
        
        :param a: Point :math:`a`.
        :type a: :class:`geometry.plane.Point`
        :param b: Point :math:`b`.
        :type b: :class:`geometry.plane.Point`
        :returns: Point
        :rtype: :class:`geometry.plane.Point`
        
        See :func:`intersection_point`.
        
        """
        return intersection_point(self, a, b)
    
    cpdef int intersects(self, Point a, Point b):
        """
        intersects(a, b)
        
        Test whether the line given by the points intersects this plane.
        
        :param a: Point :math:`a`.
        :type a: :class:`geometry.plane.Point`
        :param b: Point :math:`b`
        :type b: :class:`geometry.plane.Point`
        :returns: +1 when...
        :rtype: :class:`int`
        
        See :func:`intersects`
        
        """
        return intersects(self, a, b)
    
    
    def __repr__(self):
        return "{}({}, {}, {}, {})".format(type(self), self.a, self.b, self.c, self.d)
    
    def __str__(self):
        return "({}, {}, {}, {})".format(self.a, self.b, self.c, self.d)
    
    def __richcmp__(self, other, op):
        
        cdef int equal
        
        """Check whether the comparison method has been defined."""
        if not(op==2 or op==3):
            raise TypeError()
        
        """To possibly be true, the other object has to be a Plane as well."""
        if not isinstance(other, Plane):
            return False
        
        """Determine whether the attributes are equal."""
        equal = True if (self.a == other.a and self.b == other.b and self.c == other.c and self.d == other.d) else False
        
        if (op==2 and equal==True) or (op==3 and equal==False): # a == b
            return True
        else:
            return False
        
    @classmethod
    def from_normal(cls, normal):
        """
        from_normal(normal)
        
        Create a plane object using a normal vector.
        
        :param normal: Normal vector
        :type normal :class:`geometry.vector.Vector`
        :returns: Plane
        :rtype: :class:`geometry.plane.Plane`
        
        """
        return cls(normal.x, normal.y, normal.z, 0.0)
    
    @classmethod
    def from_normal_and_point(cls, normal, point):
        """
        from_normal_and_point(normal, point)
        
        Create a plane object given a normal vector and a point in the plane.
        """
        return cls(normal.x, normal.y, normal.z, -(normal.x*point.x + normal.y*point.y + normal.z*point.z))
    
    @classmethod
    def from_points(cls, points):
        """
        from_points(points)
        
        Create a Plane object using three points.
        """
        return cls(*reduced_normal_form(*normal_form(*tuple(points[0:3]))))
        
        
def normal_form(Point a, Point b, Point c):
    """
    normal_form(a, b, c)
    
    Normal form of plane.
    
    :param a: Point a
    :type a: :class:`geometry.plane.Point`
    :param b: Point b
    :type b: :class:`geometry.plane.Point`
    :param c: Point c
    :type c: :class:`geometry.plane.Point`
    :returns: Normal form of plane.
    :rtype: :class:`tuple`
    
    
    The plane is defined by three points.
    
    :param points: Iterable of of xyz tuples.
    
    See ((4))
    """
    A = a.y * (b.z - c.z) + b.y * (c.z - a.z) + c.y * (a.z - b.z)
    B = - a.x * (b.z - c.z) - b.x * (c.z - a.z) - c.x * (a.z - b.z)
    C = a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y)
    D = a.x * (c.y*b.z - b.y*c.z) + a.y * (b.x*c.z - c.x*b.z) + a.z * (c.x*b.y - b.x*c.y)


    return A, B, C, D

def reduced_normal_form(double A, double B, double C, double D):
    """
    reduced_normal_form(A, B, C, D)
    
    Reduced normal form of a plane.
    
    :param A: Value :math:`A`
    :type A: :class:`double`
    :param B: Value :math:`B`
    :type B: :class:`double`
    :param C: Value :math:`C`
    :type C: :class:`double`
    :param D: Value :math:`D`
    :type D: :class:`double`
    :returns: Reduced normal form ``(a, b, c, d)``
    :rtype: :class:`tuple`
    
    .. math: a = A / \\sqrt{ A^2 + B^2 + C^2}
    .. math: b = B / \\sqrt{ A^2 + B^2 + C^2}
    .. math: c = C / \\sqrt{ A^2 + B^2 + C^2}
    .. math: d = D / \\sqrt{ A^2 + B^2 + C^2}
    
    See ((5))
    """
    a = A / (A**2.0 + B**2.0 + C**2.0)**(0.5)
    b = B / (A**2.0 + B**2.0 + C**2.0)**(0.5)
    c = C / (A**2.0 + B**2.0 + C**2.0)**(0.5)
    d = D / (A**2.0 + B**2.0 + C**2.0)**(0.5)
    
    return a, b, c, d
    
    
    
cpdef Point intersection_point(Plane plane, Point a, Point b):
    """
    intersection_point(plane, a, b)
    
    Intersection point of a straight line through two points with a plane.
    
    :param plane: Plane
    :type plane: :class:`geometry.plane.Plane`
    :param a: Point a
    :type a: :class:`geometry.plane.Point`
    :param b: Point b
    :type b: :class:`geometry.plane.Point`
    :returns: Intersection point.
    :rtype: :class:`geometry.plane.Point`
    
    
    See ((9))
    """
    #cdef double xx
    #cdef double x
    #cdef double y
    #cdef double z
   
    #xx = plane.a * (a.x - b.x) + plane.b * (a.y - b.y) + plane.c * (a.z - b.z)

    #x = (- plane.d * (a.x - b.x) + plane.b * (b.x*a.y - a.x*b.y) + plane.c * (b.x*a.z - a.x*b.z) ) / xx
    #y = (- plane.d * (a.y - b.y) + plane.a * (a.x*b.y - b.x*a.y) + plane.c * (b.y*a.z - a.y*b.z) ) / xx
    #z = (- plane.d * (a.z - b.z) + plane.a * (a.x*b.z - b.x-a.z) + plane.b * (a.y*b.z - b.y*a.z) ) / xx
    #return Point(x, y, z)

    cdef Point plane_point
    cdef double d

    plane_point = Point(*(-plane.d * plane.normal()))
    #line_vector = (b-a).vector()
    d = (plane_point - a) * plane.normal() / ((b-a)*plane.normal())
    
    #print type(a)
    #print type(b)
    #print type(d)
    return d*(b-a)+a

cpdef int intersects(Plane plane, Point a, Point b):
    """
    intersects(plane, a, b)
    
    Test whether the plane ``plane`` is intersected by the line given by the points ``a`` and ``b``.
    
    :param plane: Plane
    :type plane: :class:`geometry.plane.Plane`
    :param a: Point a
    :type a: :class:`geometry.plane.Point`
    :param b: Point b
    :type b: :class:`geometry.plane.Point`
    :returns: +1 for a point intersection, 0 when there is no intersection and -1 for a line intersection.
    :rtype: :class:`int`

    """
    cdef Point plane_point
    plane_point = Point(*(-plane.d * plane.normal()))
    
    num = (plane_point - a) * plane.normal()
    den = (b-a)*plane.normal()
    
    if den == 0.0:
        if num==0.0:
            return -1
        else:
            return 0
    else:
        return +1
