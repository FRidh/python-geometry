import os
from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext


core = Extension(
    'geometry.core',            
    [os.path.join("geometry", "core.pyx")],     
    language='c++',         
    libraries=['stdc++'],
    include_dirs = ['.'],  
    )

setup(
    cmdclass = {'build_ext': build_ext},
    include_dirs = [],  
    ext_modules = [core]
)
