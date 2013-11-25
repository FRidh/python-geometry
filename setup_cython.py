from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext


core = Extension(
    'geopy.core',            
    ["geopy/core.pyx"],     
    language='c++',         
    libraries=['stdc++'],
    )

setup(
    cmdclass = {'build_ext': build_ext},
    include_dirs = [],  
    ext_modules = [core]
)
