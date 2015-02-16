from geometry.numpy import *
from geometry import Vector

def test_angle():
    
    a = Vector(1,0,1)
    b = Vector(1,0,0)

    A = np.array(a)
    B = np.array(b)
    
    # Test for single vector pair
    assert(angle(A,B) == a.angle(b))
    
    AA = np.tile(A, (10,5,1))
    BB = np.tile(B, (10,5,1))
    
    # Test at higher-dimensions
    assert(np.all( angle(AA,BB) == a.angle(b) ))
    
    
#def test_rotate():
    
    
