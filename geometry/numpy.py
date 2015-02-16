"""Geometry calculations with numpy.
"""

import numpy as np
from collections import Sequence


from geometry.tools import _rotate

def rotate(vectors, axes, angles):
    """Rotate vectors.
    """
    vectors = np.atleast_2d(vectors).astype('float64')
    axes = np.atleast_2d(axes).astype('float64')
    angles = np.atleast_1d(angles).astype('float64')
    rotated = np.zeros_like(vectors, dtype='float64')
    return np.array( _rotate(vectors, axes, angles, rotated) )


def norm(data, axis=-1):
    """Vector norm.
    """
    return np.linalg.norm(data, axis=axis)


def unit_vector(data, inplace=False):
    """Unit vector.
    """
    if inplace:
        pass
    
    else:
        return data / norm(data)[..., None]
    

def angle(a, b):
    """Angle between vector `a` and `b` over last dimension.
    
    .. math:: \\theta = \\arccos{\\frac{\\mathbf{x}\cdot\\mathbf{y}}{|\\mathbf{x}| |\\mathbf{y}|}}
    
    """
    #dot = np.einsum('...ij,...ij->...i', a, b)
    dot = (a * b).sum(axis=-1)
    return np.arccos(dot / (norm(a)*norm(b)))
    

    
###def cross_product_matrix(data):
    ###"""Cross product matrix.
    
    ####.. math:: [\mathbf{a}]_{\cross} = 
    
    
    ###"""
    
    ###out = np.zeros(shape)
    
    ###zeros_shape = list(data.shape).append(3)
    
    ###np.zeros(0.0
    ###-data[...,2]
    ###+data[...,1]
    
    ###+data[...,2]
    ###0.0
    ###-data[...,0]
    
    ###-data[...,1]
    ###+data[...,0]
    ###0.0
    
    ###out[ data[..., ]
    


def rotation_matrix(angle, axis):
    """Rotation matrix."""
    
    angle = np.atleast_1d(angle)
    axis = np.atleast_1d(axis)
    
    cosangle = np.cos(angle)
    sinangle = np.sin(angle)
    
    #shape = list()
    #if len(angle) > 1:
        #shape.append(len(angle))
    #if len(axis) > 1:
        #shape.append(len(axis))
    #shape += [3,3]
    
    shape = (len(angle), len(axis), 3, 3)
    
    R = np.squeeze( np.zeros(shape) )
    
    R = np.eye(3)[...,:] * cosangle[..., None]
    #R = np.diag([cosangle, cosangle, cosangle]) # Cannot handle vectors of angles.
    
    R += sinangle * cross_product_matrix(axis) 
    R += (1.0 - cosangle) * np.cross(axis, axis)
    
    
