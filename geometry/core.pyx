"""
This module provides classes to work with 3D geometries.
"""
cimport numpy as np    
import numpy as np    

from libc.math cimport sqrt, acos
    
cdef inline int sign(double x):
    """
    Signum function for doubles.
    """
    if x > 0.0: 
        return +1
    elif x < 0.0: 
        return -1
    else:
        return 0
 
 
cdef class PointList(object):
    """
    List of Positions.
    """
 
    #cdef np.ndarray _data 
 
    def __init__(self, xyz=None):
        
        if xyz is None:
            self._data = np.empty((3,0))
        
        elif isinstance(xyz, np.ndarray):
            if xyz.shape[1]==3:
                self._data = xyz.transpose()
            
            elif xyz.shape[0]==3:
                self._data = xyz
            else:
                raise ValueError('Wrong shape.')
        elif isinstance(xyz, list):
            l = len(xyz)
            self._data = np.empty((3, l))
            
            for i in range(l):
                self._data[:, i] = (xyz[i].x, xyz[i].y, xyz[i].z)
        else:
            raise ValueError('Wrong input')
            
    
    def __len__(self):
        return self._data.shape[1]
    
    def __getitem__(self, int key):
        return Point(self._data[0, key], self._data[1, key], self._data[2, key])
    
    def __setitem__(self, int key, Point value):
        
        self._data[key] = value
        
    def __iter__(self):
        for i in range(self._data.shape[1]):
            yield self[i] #Point(self._data[i, 0], self._data[i, 1], self._data[i, 2])
        
    def __repr__(self):
        return "Points"
    
    def __richcmp__(self, other, int op):
        
        cdef int equal
        
        """Check whether the comparison method has been defined."""
        if not(op==2 or op==3):
            raise TypeError()
        
        """To possibly be true, the other object has to be a vector as well."""
        if not isinstance(other, PointList):
            return False
        
        """Determine whether the attributes are equal."""
        equal = True if np.all(self._data==other._data) else False
        
        if (op==2 and equal==True) or (op==3 and equal==False): # a == b
            return True
        else:
            return False
        
    
    
    property x:
        def __get__(self):
            return self._data[0]
       
    property y:
        def __get__(self):
            return self._data[1]
    
    property z:
        def __get__(self):
            return self._data[2]
    
    
    cpdef np.ndarray as_array(self):
        return self._data.transpose()
    
 
    
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
    
    def __sub__(Point self, Point other):
        #return Edge([self, other])
        return Vector(self.x-other.x, self.y-other.y, self.z-other.z)
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
        Cosines of this point with ``point``.
        """
        return cosines(self, point)
    
    cpdef double distance_to(self, Point point):
        """
        Distance between this point and point.
        """
        return self.to(point).norm()
    
    cpdef Point mirror_with(self, Plane plane):
        """
        Mirror point with plane.
        """
        return mirror_point(self, foot_point(self, plane))

    cpdef int on_interior_side_of(self, Plane plane):
        """
        Determine whether this point is on the interior side of ``plane``.
        """
        return is_point_on_interior_side(self, plane)

    cpdef int in_field_angle(self, Point apex, Polygon plane_A, Plane plane_W):
        """
        Determine whether this points can be seen from ``apex``.
        """
        return is_point_in_field_angle(apex, self, plane_A, plane_W)
        
    cpdef Vector to(self, Point point):
        """
        Return the vector from this point to ``point``.
        """
        return Vector(point.x-self.x, point.y-self.y, point.z-self.z)

cdef class Vector(object):
    """
    Vector in Cartesian coordinate system.
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
    
    #@staticmethod
    #def __operate__(op, self, other):
        #if isinstance(other, Point):
            #return Point(op(self.x, other.x), op(self.y, other.y), op(self.z, other.z))
        #else:
            #return Point(op(self.x, other), op(self.y, other), op(self.z, other))

    def __add__(self, other):
        
        if isinstance(self, Vector):
            if isinstance(other, Vector):
                return Vector(self.x+other.x, self.y+other.y, self.z+other.z)
            elif isinstance(other, Point):
                return Point(self.x+other.x, self.y+other.y, self.z+other.z)
        elif isinstance(other, Vector):
            if isinstance(self, Point):
                return Point(self.x+other.x, self.y+other.y, self.z+other.z)    
        
        raise TypeError()
        #return Vector(self.x+other.x, self.y+other.y, self.z+other.z)
    
    def __sub__(self, other):
        
        if isinstance(self, Vector):
            if isinstance(other, Vector):
                return Vector(self.x-other.x, self.y-other.y, self.z-other.z)
            elif isinstance(other, Point):
                return Point(self.x-other.x, self.y-other.y, self.z-other.z)
        elif isinstance(other, Vector):
            if isinstance(self, Point):
                return Point(self.x-other.x, self.y-other.y, self.z-other.z)    
        raise TypeError()
        #return Vector(self.x-other.x, self.y-other.y, self.z-other.z)
        
    def __mul__(self, other):
        if type(other) in [int, float, long]:
            return Vector(self.x*other, self.y*other, self.z*other)
        elif type(self) in [int, float, long]:
            return Vector(self*other.x, self*other.y, self*other.z)  
        elif isinstance(other, Vector):
            return self.x*other.x + self.y*other.y + self.z*other.z
        else:
            raise TypeError()
        
    def __div__(self, other):
        if type(other) in [int, float, long]:
            return Vector(self.x/other, self.y/other, self.z/other)
        elif type(self) in [int, float, long]:
            return Vector(self/other.x, self/other.y, self/other.z) 
        else:
            raise TypeError()
    
    __truediv__ = __div__
    
    def __mod__(self, other):
        if type(other) in [int, float, long]:
            return Vector(self.x%other, self.y%other, self.z%other)
        elif type(self) in [int, float, long]:
            return Vector(self%other.x, self%other.y, self%other.z) 
        elif isinstance(other, Vector):
            return Vector(self.x%other.x, self.y%other.y, self.z%other.z)
        else:
            raise TypeError()#"unsupported operand type(s) for {}: '{}' and '{}'").format(
        
    def __iadd__(self, Vector other):
        self.x+=other.x
        self.y+=other.y
        self.z+=other.z
        return self
        
    def __isub__(self, Vector other):
        self.x-=other.x
        self.y-=other.y
        self.z-=other.z
        return self
    
    def __imul__(self, double other):
        self.x*=other
        self.y*=other
        self.z*=other
        return self
    
    def __itruediv__(self, double other):
        self.x/=other
        self.y/=other
        self.z/=other
        return self

    __idiv__ = __itruediv__
    
    def __imod__(self, other):
        if type(other) in [int, float, long]:
            self.x%=other
            self.y%=other
            self.z%=other
            return self
        elif isinstance(other, Vector):
            self.x%=other.x
            self.y%=other.y
            self.z%=other.z
            return self
        else:
            raise TypeError()

    def __pos__(self):
        return Vector(+self.x, +self.y, +self.z)
    
    def __neg__(self):
        return Vector(-self.x, -self.y, -self.z)
    
    def __abs__(self):
        return sqrt(self*self)
    
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
        return "Vector({}, {}, {})".format(self.x, self.y, self.z)
    
    def __str__(self):
        return "({}, {}, {})".format(self.x, self.y, self.z)
    
    __hash__ = None
    
    def __iter__(self):
        yield self.x
        yield self.y
        yield self.z
    
    #def __ne__(self, other):   # must use richcmp
        #return not (self==other)
    
    def __richcmp__(self, other, int op):
        """
        Comparison methods.
        """
        cdef int equal
        
        """Check whether the comparison method has been defined."""
        if not(op==2 or op==3):
            raise TypeError()
        
        """To possibly be true, the other object has to be a vector as well."""
        if not isinstance(other, Vector):
            return False
        
        """Determine whether the attributes are equal."""
        equal = True if (self.x == other.x and self.y == other.y and self.z == other.z) else False
        
        if (op==2 and equal==True) or (op==3 and equal==False): # a == b
            return True
        else:
            return False
        
        ###if int == 0: # a < b
            
            ###pass
        ###elif int == 1: # a <= b
            ###pass
        
        ###elif int == 2: # a == b
            ###pass
        
        ###elif int == 3: # a != b
            ###pass
        
        ###elif int == 4: # a > b
            ###pass
        
        ###elif int == 5: # a >= b
            ###pass

    cpdef double min(self):
        """
        Minimum value of the components.
        """
        return min(self.x, self.y, self.z)
    
    cpdef double max(self):
        """
        Minimum value of the components.
        """
        return max(self.x, self.y, self.z)

    cpdef int argmin(self):
        """
        Index of minimum value of the components.
        """
        if self.x<=self.y<=self.z:
            return 0
        elif self.y<=self.z:
            return 1
        else:
            return 2
    
    cpdef int argmax(self):
        """
        Index of maximum value of the components.
        """
        if self.x>=self.y>=self.z:
            return 0
        elif self.y>=self.z:
            return 1
        else:
            return 2
    
    cpdef double norm(self):
        """
        Return the norm/length of the vector.
        
        .. math:: |\\mathbf{x}| = \\sqrt{\\mathbf{x}\\mathbf{x}}
        
        """
        return sqrt(self*self)
        
    cpdef Vector normalize(self):
        """
        Return a normalized vector.
        """
        return self/self.norm()
    
    cpdef double angle(self, Vector other):
        """
        Return angle between self and other.
        """
        return acos((self*other)/(abs(self)*abs(other)))
    
    cpdef double cosines_with(self, Vector vector):
        """
        Cosine between this vector and another vector.
        """
        return cosine_between_vectors(self, vector)
    
    #cpdef double inner(self, Vector vector):
        #"""
        #See dot product.
        #"""
        #return self.dot(vector)
    
    cpdef double dot(self, Vector vector):
        """
        Dot product of this vector with vector.
        """
        return self.x*vector.x + self.y*vector.y + self.z*vector.z
    
    cpdef Vector cross(self, Vector vector):
        """
        Cross product of this vector with vector.
        """
        return cross(self, vector)
    
    @classmethod
    def from_points(cls, point_a, point_b):
        """
        Create a vector from point a to point b.
        """
        return cls(*(point_b - point_a))
        

cpdef double dot(Vector a, Vector b):
    """
    Dot product of vectors a and b.
    
    The dot product is given by
    
    .. math:: c = \\sum_{i=0}^{n-1} a_i b_i
    
    """
    return a.x*b.x + a.y*b.y + a.z*b.z

cpdef Vector cross(Vector a, Vector b):
    """
    Cross product of vectors a and b.
    
    The cross product is given by
    
    .. math:: \\mathbf{c} = \\mathbf{a} \\times \\mathbf{b}
    
    and is calculated as
    
    .. math:: c_x = a_y b_z - a_z b_y
    .. math:: c_y = a_z b_x - a_x b_z
    .. math:: c_z = a_x b_y - a_y b_x
    
    """
    return Vector(a.y*b.z - a.z*b.y, 
                  a.z*b.x - a.x*b.z, 
                  a.x*b.y - a.y*b.x)

cdef double distance(Point a, Point b):
    """
    Eucledian distance between points a and b.
    
    Subtask 1: Distance between two points.
    """
    return ( (a.x-b.x)**2.0 + (a.y-b.y)**2.0 + (a.z-b.z)**2.0 )**0.5


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
        

cdef class Plane(object):
    """
    Plane specified by reduced normal form
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
        Normal vector of plane.
        """
        return Vector(self.a, self.b, self.c)
    
    cpdef Point intersection(self, Point a, Point b):
        """
        Determine the point where a line specified by the points ``a`` and ``b`` intersect this plane.
        """
        return intersection_point(self, a, b)
    
    cpdef int intersects(self, Point a, Point b):
        """
        Test whether the line given by the points intersects this plane.
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
        Create a plane objeect using a normal vector.
        """
        return cls(normal.x, normal.y, normal.z, 0.0)
    
    @classmethod
    def from_normal_and_point(cls, normal, point):
        """
        Create a plane object given a normal vector and a point in the plane.
        """
        return cls(normal.x, normal.y, normal.z, -(normal.x*point.x + normal.y*point.y + normal.z*point.z))
    
    @classmethod
    def from_points(cls, points):
        """
        Create a Plane object using three points.
        """
        return cls(*reduced_normal_form(*normal_form(*tuple(points[0:3]))))

cdef class Polygon(object):
    """
    3D Polygon defined by points.
    """
    
    #cdef public list points
    #cdef public Point center

    def __init__(self, list points, Point center):

        self.points = points
        """
        Points is an iterable containing :class:`Point` objects defining the polygon.
        """
        
        self.center = center

    def __repr__(self):
        return "Polygon({})".format(str(self.plane()))
        #return "Polygon({}, {}, {}, {})".format(self.plane().a, self.points[1], self.points[2])
    
    def __str__(self):
        return str(self.plane())
    
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
 
def normal_form(Point a, Point b, Point c):
    """
    Normal form of plane.
    
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
    Reduced normal form of a plane.
    
    See ((5))
    """
    a = A / (A**2.0 + B**2.0 + C**2.0)**(0.5)
    b = B / (A**2.0 + B**2.0 + C**2.0)**(0.5)
    c = C / (A**2.0 + B**2.0 + C**2.0)**(0.5)
    d = D / (A**2.0 + B**2.0 + C**2.0)**(0.5)
    
    return a, b, c, d

cpdef Point foot_point(Point point, Plane plane):
    """
    Foot point of point on plane.
    
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
    Mirror point of a point at a plane.
    
    See ((7))
    """
    return Point(2.0*foot_point.x-point.x, 2.0*foot_point.y-point.y, 2.0*foot_point.z-point.z)
    #2.0 * foot_point - point

cpdef Vector cosines(Point a, Point b):
    """
    Cosines of point a with point b.
    
    Returns cos(alpha), cos(beta), cos(gamma)
    
    See ((2))
    """
    return a.to(b)/a.distance_to(b)
    
cpdef double cosine_between_vectors(Vector a, Vector b):
    """
    Cosine of angle between lines or more general vectors.
    
    Returns cos(phi)
    
    See ((3))
    """
    return a.x*b.x + a.y*b.y + a.z*b.z

cpdef Point intersection_point(Plane plane, Point a, Point b):
    """
    Intersection point of a straight line through two points with a plane.
    
    :param plane: Plane
    :param a: Point a
    :param b: Point b
    
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
    Test whether the plane is intersected by the line given by the points.
    
    Returns +1 for a points intersection.
    Returns 0 when there is no intersection.
    Returns -1 for a line intersection.
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

cpdef int is_point_on_interior_side(Point point, Plane plane):
    """
    Test whether ``point`` is on the interior side of ``plane``.
    
    
    Returns +1 when point is on interior side.
    Returns 0 when point lies on the plane.
    Returns -1 when point is on the exterior side.
    
    See ((15))
    """
    return sign(plane.a * point.x + plane.b * point.y + plane.c * point.z + plane.d)


cpdef int is_point_in_field_angle(Point apex, Point point, Polygon polygon_A, Plane plane_W):
    """
    Test whether the ``point`` P on the surface of plane W lies within the projection of the plane A by ``apex`` on the plane W.
    
    :param apex: Point q
    :param point: Point P
    :param polygon_A: Polygon A
    :param plane_W: Plane W
    
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