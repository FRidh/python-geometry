
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
    
 
    
