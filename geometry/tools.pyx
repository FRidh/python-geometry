cimport cython

@cython.boundscheck(False)
cpdef _rotate(double[:,:] vectors, double[:,:] axes, double[:] angles, double[:,:] rotated):
    
    cdef Vector rotated_vector
    
    cdef int row
    cdef int n_vectors = len(vectors)
    cdef int n_axes = len(axes)
    cdef int n_angles = len(angles)
    
    for row in range(n_vectors):
        rotated_vector = quat_from_angle_and_axis(angles[row%n_angles], Vector(*axes[row%n_axes])).rotate(Vector(*vectors[row])) 
        rotated[row,0] = rotated_vector.x
        rotated[row,1] = rotated_vector.y
        rotated[row,2] = rotated_vector.z
        
    return rotated    
        


#cpdef rotate(double[:,:] vectors, double[:,:] axes, double[:] angles):
    #"""Rotate vectors given rotations axes and rotations angles.
    
    #:param vectors: A 2D-array with N rows and 3 columns.
    #:param axes: A 2D-array with N rows and 3 columns.
    #:param angles: A 1D-array with N items.
    
    #.. warning:: This function only works for a 2D array, i.e., a 'list' of vectors.
    
    #"""
    #cdef int N = len(vectors)

    #cdef np.ndarray[np.float64_t, ndim=2] rotated = np.zeros((N, 3), dtype=np.float64)
    #cdef int row
    #cdef int column
    ##cdef double[:] axis
    ##cdef double[:] vector
    
    #for row, (axis, angle, vector) in enumerate(zip(axes, angles, vectors)):
        #for column, value in enumerate(quat_from_angle_and_axis(angle, Vector(*axis)).rotate(Vector(*vector))):
            #rotated[row, column] = value
    #return rotated#return np.asarray(rotated)

    ##cdef double[:,::1] rotated = np.empty(N,3)
    ##cdef Vector rotated_vector
    ##for row in range(N):
        ##rotated_vector = quat_from_angle_and_axis(angles[row], Vector(axes[row])).rotate(Vector(*vectors[row]))
        ##for column in range(3):
            ##rotated[row, column] = rotated_vector[column]
        ###rotated[row,:] = quat_from_angle_and_axis(angle, Vector(*axis)).rotate(Vector(*vector))
    ##return np.asarray(rotated)

