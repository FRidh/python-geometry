import math
import numbers

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
        
        if isinstance(self, Vector) and isinstance(other, Vector):
            return Vector(self.x+other.x, self.y+other.y, self.z+other.z)
        elif isinstance(self, Vector) and isinstance(other, numbers.Real):
            return Vector(self.x+other, self.y+other, self.z+other)
        elif isinstance(self, numbers.Real) and isinstance(self, Vector):
            return Vector(other.x+self, other.y+self, other.z+self)
        else:
            return NotImplemented
        
    def __sub__(self, other):
        
        if isinstance(self, Vector) and isinstance(other, Vector):
            return Vector(self.x-other.x, self.y-other.y, self.z-other.z)
        elif isinstance(self, Vector) and isinstance(other, numbers.Real):
            return Vector(self.x-other, self.y-other, self.z-other)
        elif isinstance(self, numbers.Real) and isinstance(self, Vector):
            return Vector(other.x-self, other.y-self, other.z-self)
        else:
            return NotImplemented
        
        
    def __mul__(self, other):
        if isinstance(self, Vector) and isinstance(other, Vector):
            return self.x*other.x + self.y*other.y + self.z*other.z
        elif isinstance(self, Vector) and isinstance(other, numbers.Real):
            return Vector(self.x-other, self.y-other, self.z-other)
        elif isinstance(self, numbers.Real) and isinstance(self, Vector):
            return Vector(other.x-self, other.y-self, other.z-self)
        else:
            return NotImplemented
        
    def __div__(self, other):
        if isinstance(self, Vector) and isinstance(other, numbers.Real):
            return Vector(self.x/other, self.y/other, self.z/other)
        elif isinstance(self, numbers.Real) and isinstance(self, Vector):
            return Vector(other.x/self, other.y/self, other.z/self)
        else:
            return NotImplemented
    
    #__truediv__ = __div__
    
    def __mod__(self, other):
        if isinstance(self, Vector) and isinstance(other, numbers.Real):
            return Vector(self.x%other, self.y%other, self.z%other)
        elif isinstance(self, numbers.Real) and isinstance(self, Vector):
            return Vector(other.x%self, other.y%self, other.z%self)
        else:
            return NotImplemented
                
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
    
    def __bool__(self):
        return (self.x==0.0 and self.y==0.0 and self.z==0.0)
    
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
        min()
        
        Minimum value of the components.
        
        :returns: Minimum value.
        :rtype: :class:`double`
        
        """
        return min(self.x, self.y, self.z)
    
    cpdef double max(self):
        """
        max()
        
        Maximum value of the components.
        
        :returns: Maximum value.
        :rtype: :class:`double`
        
        """
        return max(self.x, self.y, self.z)

    cpdef int argmin(self):
        """
        argmin()
        
        Index of minimum value of the components.
        
        :returns: Index
        :rtype: :class:`int`
        
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
        
        :returns: Index
        :rtype: :class:`int`
        
        """
        if self.x>=self.y>=self.z:
            return 0
        elif self.y>=self.z:
            return 1
        else:
            return 2
    
    cpdef bint unit(self):
        """
        unit()
        
        Return whether this vector is a unit vector or not.
        """
        return self.norm()==1.0
    
    
    cpdef double norm(self):
        """
        norm()
        
        Return the norm/length of the vector.
        
        :returns: Norm
        :rtype: :class:`double`
        
        .. math:: |\\mathbf{x}| = \\sqrt{\\mathbf{x}\\mathbf{x}}
        
        """
        return sqrt(self*self)
        
    cpdef Vector normalize(self):
        """
        normalize()
        
        Return a normalized vector.
        
        :returns: Normalized copy of this vector.
        :rtype: :class:`geometry.vector.Vector`
        
        """
        return self/self.norm()
    
    cpdef double angle(self, Vector other):
        """
        angle(other)
        
        Return angle between this vector and another vector.
        
        :param other: Other vector
        :type other: :class:`geometry.vector.Vector`
        :returns: Angle
        :rtype: :class:`double`
        
        """
        return acos((self*other)/(abs(self)*abs(other)))
    
    cpdef double cosines_with(self, Vector vector):
        """
        cosines_with(vector)
        
        Cosine between this vector and another vector.
        
        :param vector: Other vector
        :type vector: :class:`geometry.vector.Vector`
        :returns: Cosine
        :rtype: :class:`double`
        
        """
        return cosine_between_vectors(self, vector)
    
    #cpdef double inner(self, Vector vector):
        #"""
        #See dot product.
        #"""
        #return self.dot(vector)
    
    cpdef double dot(self, Vector vector):
        """
        dot(vector)
        
        Dot product of this vector with another vector.
        
        :param vector: Other vector
        :type vector: :class:`geometry.vector.Vector`
        :returns: Dot product
        :rtype: :class:`double`
        """
        return self.x*vector.x + self.y*vector.y + self.z*vector.z
    
    cpdef Vector cross(self, Vector vector):
        """
        cross(vector)
        
        Cross product of this vector with another vector.
        
        :param vector: Other vector
        :type vector: :class:`geometry.vector.Vector`
        :returns: Cross product
        :rtype: :class:`geometry.vector.Vector`
        """
        return cross(self, vector)
    
    cpdef Vector rotate(self, Quat quat):
        """
        rotate(quat)
        
        Return a copy of this vector but rotated using the given quaternion.
        
        :param quat: Rotation quaternion
        :type quat: :class:`geometry.quat.Quaterion`
        :returns: Rotated Vector
        :rtype: :class:`geometry.vector.Vector`
        
        """
        return quat.rotate(self) 
        
    cpdef Vector rotate_inplace(self, Quat quat):
        """
        rotate_inplace(quat)
        
        Returns this vector rotated inplace using the given quaternion.
        
        :param quat: Rotation quaternion
        :type quat: :class:`geometry.quat.Quaterion`
        :returns: Rotated Vector
        :rtype: :class:`geometry.vector.Vector`
        
        """
        return quat.rotate_inplace(self)
    
    @classmethod
    def from_points(cls, point_a, point_b):
        """
        Create a vector from point a to point b.
        
        :param point_a: Point :math:`a`
        :param point_b: Point :math:`b`
        
        """
        return cls(*(point_b - point_a))
        

cpdef double dot(Vector a, Vector b):
    """
    dot(a, b)
    
    Dot product of vectors a and b.
    
    :param a: Vector :math:`a`.
    :type a: :class:`geometry.vector.Vector`
    :param b: Vector :math:`b`.
    :type b: :class:`geometry.vector.Vector`
    :returns: Dot product
    :rtype: :class:`double`
    
    The dot product is given by
    
    .. math:: c = \\sum_{i=0}^{n-1} a_i b_i
    
    """
    return a.x*b.x + a.y*b.y + a.z*b.z

cpdef Vector cross(Vector a, Vector b):
    """
    cross(a, b)
    
    :param a: Vector :math:`a`.
    :type a: :class:`geometry.vector.Vector`
    :param b: Vector :math:`b`.
    :type b: :class:`geometry.vector.Vector`
    :returns: Cross product
    :rtype: :class:`geometry.vector.Vector`
    
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
           
           
cpdef double cosine_between_vectors(Vector a, Vector b):
    """
    cosine_between_vectors(a, b)
    
    Cosine of angle between lines or more general vectors.
    
    .. math:: \\cos{\\phi} = \\mathbf{a} \\mathbf{b}
    
    :param a: Vector ``a``.
    :type a: :class:`geometry.vector.Vector`
    :param b: Vector ``b``.
    :type b: :class:`geometry.vector.Vector`
    :returns: ``cos(phi)``
    :type: :class:`float`
    
    See ((3))
    """
    return a.x*b.x + a.y*b.y + a.z*b.z
