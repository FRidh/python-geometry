
import numbers
import math

PRECISION = 1.0e-12

cdef class Quat(object):
    """Quaternion.
    
    
    """
    
    def __cinit__(self, double w, double x, double y, double z):
        
        self.w, self.x, self.y, self.z = w, x, y, z
        
    
    def __add__(self, other):
        if isinstance(self, Quat) and isinstance(other, Quat):
            return Quat(self.w+other.w, self.x+other.x, self.y+other.y, self.z+other.z)
        else:
            return NotImplemented
    
    def __sub__(self, other):
        if isinstance(self, Quat) and isinstance(other, Quat):
            return Quat(self.w-other.w, self.x-other.x, self.y-other.y, self.z-other.z)
        else:
            return NotImplemented
        
    def __mul__(self, other):
        if isinstance(self, Quat) and isinstance(other, Quat):
            w1, x1, y1, z1 = self.w, self.x, self.y, self.z
            w2, x2, y2, z2 = other.w, other.x, other.y, other.z
            return Quat(w1*w2-x1*x2-y1*y2-z1*z2,
                        w1*x2+x1*w2+y1*z2-z1*y2,
                        w1*y2+y1*w2-x1*z2+z1*x2,
                        w1*z2+z1*w2+x1*y2-y1*x2)
        
        elif isinstance(self, Quat) and isinstance(other, numbers.Real):
            return Quat(self.w*other, self.x*other, self.y*other, self.z*other)
        elif isinstance(self, numbers.Real) and isinstance(other, Quat):
            return Quat(other.w*self, other.x*self, other.y*self, other.z*self)
        else:
            return NotImplemented
    
    def __truediv__(self, other):
        if isinstance(self, Quat) and isinstance(other, numbers.Real):
            return Quat(self.w/other, self.x/other, self.y/other, self.z/other)
        else:
            return NotImplemented
        
    def __pos__(self):
        return Quat(+self.w, +self.x, +self.y, +self.z)
    
    def __neg__(self):
        return Quat(-self.w, -self.x, -self.y, -self.z)
    
    def __abs__(self):
        return sqrt(self.w*self.w + self.x*self.x + self.y*self.y + self.z*self.z)

    def __len__(self):
        return 4
    
    def __iter__(self):
        yield self.w
        yield self.x
        yield self.y
        yield self.z
        
    def __getitem__(self, int key):
        if key==0:
            return self.w
        elif key==1:
            return self.x
        elif key==2:
            return self.y
        elif key==3:
            return self.z
        else:
            raise IndexError

    def __setitem__(self, int key, double value):
        if key==0:
            self.w = value
        elif key==1:
            self.x = value
        elif key==2:
            self.y = value
        elif key==3:
            self.z = value
        else:
            raise IndexError

    def __bool__(self):
        return (self.w==0.0 and self.x==0.0 and self.y==0.0 and self.z==0.0)
    
    def __repr__(self):
        return "Quat({}, {}, {}, {})".format(self.w, self.x, self.y, self.z)
    
    def __str__(self):
        return "({}, {}, {}, {})".format(self.w, self.x, self.y, self.z)
    
    
    def __richcmp__(self, other, int op):
        """
        Comparison methods.
        """
        cdef int equal
        
        # Check whether the comparison method has been defined.
        if op==2 or op==3:
            if not isinstance(other, Quat):
                return False
            else:
                # Determine whether the attributes are equal.
                equal = True if (self.w==other.w and self.x==other.x and self.y==other.y and self.z==other.z) else False
                if (op==2 and equal==True) or (op==3 and equal==False): # a == b
                    return True
                else:
                    return False
        else:
            return NotImplemented

    def __getnewargs__(self):
        return (self.w, self.x, self.y, self.z)

    cpdef bint unit(self):
        """
        unit()

        Whether this is a unit quaternion or not.
        """
        return abs(self.norm() - 1.0) < PRECISION

    cpdef double norm(self):
        """
        norm()
        
        Norm.
        
        :returns: Norm.
        :rtype: :class:`double`
        
        """
        return abs(self)
    
    cpdef Quat normalize(self):
        """
        normalize()
        
        Normalize this quaternion in-place.
        
        :returns: This quaternion normalized.
        :rtype: :class:`geometry.quat.Quat`
        """
        self.w, self.x, self.y, self.z = self.normalized()
        
    
    cpdef Quat normalized(self):
        """
        normalize()
        
        Normalized copy of this quaternion.
        
        :returns: Normalized copy.
        :rtype: :class:`geometry.quat.Quat`
        
        """
        return self / self.norm()
    
    
    cpdef Quat conjugate(self):
        """
        conjugate()
        
        Conjugate.
        
        :returns: Conjugate
        :rtype: :class:`geometry.quat.Quat`
        
        """
        return Quat(self.w, -self.x, -self.y, -self.z)
        
    
    cpdef Quat inverse(self):
        """
        inverse()
        
        Inverse.
        
        :returns: Inverse
        :rtype: :class:`geometry.quat.Quat`
        
        """
        return self.conjugate() / self.dot(self)
    
    cpdef double dot(self, Quat other):
        """
        dot()
        
        Dot product.
        
        :param other: Other quaternion.
        :type other: :class:`geometry.quat.Quat`
        :returns: Conjugate
        :rtype: :class:`geometry.quat.Quat`
        
        """
        return self.w*other.w + self.x*other.x + self.y+other.y +self.z*other.z
        
    cpdef tuple to_angle_and_axis(self):
        """
        to_angle_and_axis()
        
        :returns: A tuple consisting of a float and a vector, representing respectively the angle and axis.
        :rtype: tuple
        
        """
        cdef double angle
        cdef Vector axis
        if not self.unit():
            raise ValueError("Quaternion is not a unit quaternion.")
        else:
            #n = self.normalized()
            n = self
            axis = Vector(n.x, n.y, n.z)
            angle = 2.0*atan2(axis.norm(), n.w)
            return angle, axis
        
    cpdef Vector rotate(self, Vector v):
        """
        rotate()
        
        Rotate vector using this quaternion.
        
        :param v: Vector
        :type v: :class:`geometry.vector.Vector`
        :returns: Rotated vector.
        :rtype: :class:`geometry.vector.Vector`
        
        """
        cdef double ww = self.w*self.w
        cdef double xx = self.x*self.x
        cdef double yy = self.y*self.y
        cdef double zz = self.z*self.z
        cdef double wx = self.w*self.x
        cdef double wy = self.w*self.y
        cdef double wz = self.w*self.z
        cdef double xy = self.x*self.y
        cdef double xz = self.x*self.z
        cdef double yz = self.y*self.z
        cdef Vector vector
        if not self.unit():
            raise ValueError("Quaternion is not a unit quaternion.")
        else:
            vector = Vector(ww*v.x + xx*v.x - yy*v.x - zz*v.x + 2.0*((xy-wz)*v.y + (xz+wy)*v.z),
                            ww*v.y - xx*v.y + yy*v.y - zz*v.y + 2.0*((xy+wz)*v.x + (yz-wx)*v.z),
                            ww*v.z - xx*v.z - yy*v.z + zz*v.z + 2.0*((xz-wy)*v.x + (yz+wx)*v.y))
            vector.x = 0.0 if abs(vector.x) < PRECISION else vector.x
            vector.y = 0.0 if abs(vector.y) < PRECISION else vector.y
            vector.z = 0.0 if abs(vector.z) < PRECISION else vector.z
            return vector
        
    cpdef Vector rotate_inplace(self, Vector v):
        """
        rotate_inplace(v)
        
        Rotate vector inplace using this quaternion.
        
        :param v: Vector
        :type v: :class:`geometry.vector.Vector`
        :returns: Rotated vector.
        :rtype: :class:`geometry.vector.Vector`
        
        """
        v.x, v.y, v.z = self.rotate(v)
        return v

    @classmethod
    def from_angle_and_axis(cls, angle, axis):
        """
        from_angle_and_axis()
        
        Construct quaternion given an angle and axis.
        """
        return quat_from_angle_and_axis(angle, axis) # Troublesome when subclassing
        #if not axis:
            #return cls(1.0, 0.0, 0.0, 0.0)
        #else:
            #axis = axis.normalized()
            #angle /= 2.0
            #w = math.cos(angle)
            #s = math.sin(angle) / axis.norm()
            #x, y, z = axis * s
            #return cls(w, x, y, z).normalized()
            
        
        
cpdef Quat quat_from_angle_and_axis(double angle, Vector axis):
    """
    from_angle_and_axis()
    
    Construct quaternion given an angle and axis.
    
    .. note:: While this function does the same as the classmethod :meth:`Quat.from_angle_and_axis` this function is implemented as a cpdef function.
    """
    cdef double w
    cdef double s
    cdef double x
    cdef double y
    cdef double z
    if not axis:
        return Quat(1.0, 0.0, 0.0, 0.0)
    else:
        axis = axis.normalized()
        angle /= 2.0
        w = math.cos(angle)
        s = math.sin(angle) / axis.norm()
        x, y, z = axis * s
        return Quat(w, x, y, z).normalized()
            
