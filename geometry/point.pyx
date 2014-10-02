
cdef inline int sign(double x):
    """
    sign(x)
    
    :param x:
    :type x: :class:`double`
    :returns: +1 for x > 0, -1 for x < 0 and 0 when x==0
    :rtype: :class:`int`
    
    Signum function for doubles.
    """
    if x > 0.0: 
        return +1
    elif x < 0.0: 
        return -1
    else:
        return 0
 

cdef class Point(object):  # Iterable, so you can unpack it like a tuple. Just specifying __iter__ would do as well.
    """
    Point defined using Cartesian coordinates.
    """
    
    #cdef public double x
    """
    X-direction
    """
    #cdef public double y
    """
    Y-direction
    """
    #cdef public double z
    """
    Z-direction
    """
    
    def __init__(self, double x, double y, double z):
        
        self.x = x
        self.y = y
        self.z = z

    #def __add__(self, other):
        #if type(other) in [int, float, long]:
            #return Point(self.x+other, self.y+other, self.z+other)
        #elif type(self) in [int, float, long]:
            #return Point(self+other.x, self+other.y, self.+other.z)
        #else:
            #raise TypeError()
    
    def __add__(self, other):
        if isinstance(self, Point) and isinstance(other, Vector):
            return Point(self.x+other.x, self.y+other.y, self.z+other.z)
        elif isinstance(self, Vector) and isinstance(other, Point):
            return Point(self.x+other.x, self.y+other.y, self.z+other.z)
        else:
            return NotImplemented
        
    def __sub__(self, other):
        if isinstance(self, Point) and isinstance(other, Point):
            return Vector(self.x-other.x, self.y-other.y, self.z-other.z)
        elif isinstance(self, Point) and isinstance(other, Vector):
            return Point(self.x-other.x, self.y-other.y, self.z-other.z)
        elif isinstance(self, Vector) and isinstance(other, Point):
            return Point(other.x-self.x, other.y-self.y, other.z-self.z)
        else:
            return NotImplemented
        
        #return Edge([self, other])
        #return Vector(self.x-other.x, self.y-other.y, self.z-other.z)
        #if type(other) in [int, float, long]:
            #return Point(self.x-other, self.y-other, self.z-other)
        #elif type(self) in [int, float, long]:
            #return Point(self-other.x, self-other.y, self.-other.z)
        #elif isinstance(self, Point) and isinstance(other, Point):
            #return Vector(self.x-other.x, self.y-other.y, self.z-other.z)
        #else:
            #raise TypeError()
        
        #return Point(self.x-other, self.y-other, self.z-other)
        #if isinstance(other, float):
            #return Point(self.x-other, self.y-other, self.z-other)
        #elif isinstance(self, float):
            #return Point(other.x-self, other.y-self, other.z-self)
        #else:
            #return Point(self.x-other.x, self.y-other.y, self.z-other.z)
        
    #def __mul__(self, other):
        #if type(other) in [int, float, long]:
            #return Point(self.x*other, self.y*other, self.z*other)
        #elif type(self) in [int, float, long]:
            #return Point(self*other.x, self*other.x, self*other.x)
        #else:
            #raise TypeError()

    #def __truediv__(self, other):
        #if type(other) in [int, float, long]:
            #return Point(self.x/other, self.y/other, self.z/other)
        #elif type(self) in [int, float, long]:
            #return Point(self/other.x, self/other.x, self/other.x)
        #else:
            #raise TypeError()
    
    #__div__ = __truediv__

    #def __mod__(self, other):
        #if type(other) in [int, float, long]:
            #return Point(self.x%other, self.y%other, self.z%other)
        #elif type(self) in [int, float, long]:
            #return Point(self%other.x, self%other.x, self%other.x)
        #else:
            #raise TypeError()
    
    #def __iadd__(self, other):
        #self.x+=other
        #self.y+=other
        #self.z+=other
        #return self
    
    #def __isub__(self, other):
        #self.x-=other
        #self.y-=other
        #self.z-=other
        #return self
    
    #def __imul__(self, other):
        #self.x*=other
        #self.y*=other
        #self.z*=other
        #return self
        
    #def __itruediv__(self, other):
        #self.x/=other
        #self.y/=other
        #self.z/=other
        #return self
    
    #__idiv__ = __itruediv__
    
    #def __imod__(self, other):
        #self.x%=other
        #self.y%=other
        #self.z%=other
        #return self
    
    def __pos__(self):
        return Point(+self.x, +self.y, +self.z)
    
    def __neg__(self):
        return Point(-self.x, -self.y, -self.z)
    
    def __len__(self):
        return 3
    
    def __getitem__(self, int key):
        
        if   key==0: return self.x
        elif key==1: return self.y
        elif key==2: return self.z
        else:
            raise IndexError()
        
    def __setitem__(self, int key, double value):
        
        if   key==0: self.x = value
        elif key==1: self.y = value
        elif key==2: self.z = value
        else:
            raise IndexError()

    def __repr__(self):
        return "Point({}, {}, {})".format(self.x, self.y, self.z)
    
    def __str__(self):
        return "({}, {}, {})".format(self.x, self.y, self.z)
    
    __hash__ = None
    
    def __iter__(self):
        yield self.x
        yield self.y
        yield self.z
    
    
    def __richcmp__(self, other, int op):
        """
        Comparison methods.
        """
        cdef int equal
        
        """Check whether the comparison method has been defined."""
        if not(op==2 or op==3):
            raise TypeError()
        
        """To possibly be true, the other object has to be a vector as well."""
        if not isinstance(other, Point):
            return False
        
        """Determine whether the attributes are equal."""
        equal = True if (self.x == other.x and self.y == other.y and self.z == other.z) else False
        
        if (op==2 and equal==True) or (op==3 and equal==False): # a == b
            return True
        else:
            return False
        
    cpdef Vector cosines_with(self, Point point):
        """
        cosines_with(point)
        
        Cosines of this point with ``point``.
        
        :param point: Point
        :type point: :class:`geometry.point.Point`
        :returns: Vector representing the cosines.
        :rtype: :class:`geometry.vector.Vector`
        
        See :func:`cosines`.
        """
        return cosines(self, point)
    
    cpdef double distance_to(self, Point point):
        """
        distance_to(point)
        
        Distance between this point and ``point``.
        
        :param point: Other point.
        :type point: :class:`geometry.point.Point`
        :returns: Distance
        :rtype: :class:`double`
        
        The distance to ``point`` is calculated by calling :meth:`Point.to()` and then :meth:`Vector.norm()`.
        
        """
        return self.to(point).norm()
    
    cpdef Point mirror_with(self, Plane plane):
        """
        mirror_with(plane)
        
        Mirror point with plane.
        
        :param plane: Plane
        :type plane: :class:`geometry.plane.Plane`
        :returns: Mirror point
        :rtype: :class:`geometry.point.Point`
        
        See :func:`mirror_point()`.
        """
        return mirror_point(self, foot_point(self, plane))

    cpdef int on_interior_side_of(self, Plane plane):
        """
        on_interior_side_of(plane)
        
        Determine whether this point is on the interior side of ``plane``.
        
        :param plane: Plane
        :type plane: :class:`geometry.plane.Plane`
        :returns: +1 when on inside, ...
        :rtype: :class:`int`
        
        See :func:`is_point_on_interior_side`.
        
        """
        return is_point_on_interior_side(self, plane)

    cpdef int in_field_angle(self, Point apex, Polygon plane_A, Plane plane_W):
        """
        in_field_angle(apex, plane_A, plane_W)
        
        Determine whether this points can be seen from ``apex``.
        
        :param apex: Apex point
        :type apex: :class:`geometry.point.Point`
        :param plane_A: Plane :math:`A`.
        :type plane_A: :class:`geometry.plane.Plane`
        :param plane_W: Plane :math:`W`.
        :type plane_W: :class:`geometry.plane.Plane`
        :returns: +1...
        :rtype: :class:`int`
        
        See :func:`is_point_in_field_angle()`.
        """
        return is_point_in_field_angle(apex, self, plane_A, plane_W)
        
    cpdef Vector to(self, Point point):
        """
        to(point)
        
        Return the vector from this point to ``point``.
        This is the same as subtracting this point from another point.
        
        :param point: Point
        :type point: :class:`geometry.point.Point`
        :returns: Vector from this point to ``point``.
        :rtype: :class:`geometry.vector.Vector`
        """
        return point - self #Vector(point.x-self.x, point.y-self.y, point.z-self.z)
        
        

cpdef Point foot_point(Point point, Plane plane):
    """
    foot_point(point, plane)
    
    Foot point of point on plane.
    
    :param point: Point
    :type point: :class:`geometry.point.Point`
    :param plane: Plane
    :type plane: :class:`geometry.plane.Plane`
    :returns: Foot point
    :rtype: :class:`geometry.point.Point`
    
    
    See ((6))
    """
    cdef double x
    cdef double y
    cdef double z
    
    x = (plane.b**2 + plane.c**2)*point.x - plane.a*(plane.d - plane.b*point.y + plane.c*point.z)
    y = (plane.a**2 + plane.c**2)*point.y - plane.b*(plane.d + plane.a*point.x + plane.c*point.z)
    z = (plane.a**2 + plane.b**2)*point.z - plane.c*(plane.d + plane.a*point.x + plane.b*point.y)
    
    return Point(x, y, z)

    
cpdef Point mirror_point(Point point, Point foot_point):
    """
    mirror_point(point, foot_point)
    
    Mirror point of a point at a plane.
    
    .. math:: \\mathbf{m} = 2 \\mathbf{f} - \\mathbf{p}
    
    :param point: Point :math:`p`
    :type point: :class:`geometry.point.Point`
    :param foot_point: Foot point :math:`f`
    :type foot_point: :class:`geometry.point.Point`
    :returns: Mirror point :math:`m`
    :rtype: :class:`geometry.point.Point`
    
    See ((7))
    """
    return Point(2.0*foot_point.x-point.x, 2.0*foot_point.y-point.y, 2.0*foot_point.z-point.z)
    #2.0 * foot_point - point
    
cpdef Vector cosines(Point a, Point b):
    """
    cosines(a, b)
    
    Cosines of point a with point b.
    
    :param a: Point ``a``.
    :type a: :class:`geometry.point.Point`
    :param b: Point ``b``.
    :type b: :class:`geometry.point.Point`
    :returns: ``cos(alpha), cos(beta), cos(gamma)``
    :rtype: :class:`geometry.vector.Vector`
    
    See ((2))
    """
    return a.to(b)/a.distance_to(b)
    
    
cpdef int is_point_on_interior_side(Point point, Plane plane):
    """
    is_point_on_interior_side(point, plane)
    
    Test whether ``point`` is on the interior side of ``plane``.
    
    :param point: Point
    :type point: :class:`geometry.point.Point`
    :param plane: Plane
    :type plane: :class:`geometry.plane.Plane`
    :returns: +1 when point is on interior side, 0 when point lies on the plane, and -1 when point is on the exterior side.
    :rtype: :class:`int`
    
    See ((15))
    """
    return sign(plane.a * point.x + plane.b * point.y + plane.c * point.z + plane.d)


cpdef int is_point_in_field_angle(Point apex, Point point, Polygon polygon_A, Plane plane_W):
    """
    is_point_in_field_angle(apex, point, polygon_A, plane_W
    
    Test whether the ``point`` P on the surface of plane W lies within the projection of the plane A by ``apex`` on the plane W.
    
    :param apex: Point q
    :type apex: :class:`geometry.point.Point`
    :param point: Point P
    :type point: :class:`geometry.point.Point`
    :param polygon_A: Polygon A
    :type polygon_A: :class:`geometry.polygon.Polygon`
    :param plane_W: Plane W
    :type plane_W: :class:`geometry.plane.Plane`
    :returns: +1 or -1.
    :rtype: :class:`int`
    
    
    See ((16))
    """
    cdef list points_F
    cdef Point a
    cdef Point b
    cdef Point A_point
    cdef int i
    cdef int items
    
    points_F = list()
    items = len(polygon_A.points)
    #print("Apex: {} - Point: {} - Polygon: {} - Plane: {}".format(apex, point, polygon_A, plane_W))

    points_F = [plane_W.intersection(A_point, apex) for A_point in polygon_A.points]
    #for i in range(items):
        #points_F.append( plane_W.intersection(polygon_A.points[i], apex) )
        #print polygon_A.points[i]
    
    #for i in range(0, len(points_F)):
        #a = polygon_A.points[(i)%len(polygon_A.points)]    # First point of plane F
        #b = polygon_A.points[(i+1)%len(polygon_A.points)]   # Second point of plane F
    for i in range(items):
        a = points_F[(i)%items]    # First point of plane F
        b = points_F[(i+1)%items]   # Second point of plane F
        
        #print("Triangle {} - a {} - b {} - apex {}".format(i, a, b, apex))
        if point.on_interior_side_of(Plane.from_points([a, b, apex])) == -1: # Check whether point P lies within the plane defined by two points of F and the apex.
            return -1    # If that's not the case, then our field angle test fails.
    return 1
    
 

cdef double distance(Point a, Point b):
    """
    distance(a, b)
    
    :param a: Point :math:`a`
    :type a: :class:`geometry.point.Point`
    :param b: Point :math:`b`
    :type b: :class:`geometry.point.Point`
    :returns: Distance
    :rtype: :class:`double`
    
    Eucledian distance between points a and b.
    
    Subtask 1: Distance between two points.
    """
    return ( (a.x-b.x)**2.0 + (a.y-b.y)**2.0 + (a.z-b.z)**2.0 )**0.5


        


