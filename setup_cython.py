import os
from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import numpy as np

core = Extension(
    'geometry.core',            
    [os.path.join("geometry", "core.pyx")],     
    language='c++',         
    libraries=['stdc++'],
    include_dirs = ['.'],  
    )

setup(
    cmdclass = {'build_ext': build_ext},
    include_dirs = [np.get_include()],  
    ext_modules = [core]
)
