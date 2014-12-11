import os, subprocess
from setuptools import setup, Command
import numpy as np
from Cython.Build import cythonize
#from distutils.cmd import Command
#from distutils.command.build import build


CLASSIFIERS = [
        'Development Status :: 4 - Beta',
        'Environment :: Console',
        'Intended Audience :: Developers',
        'Intended Audience :: Education',
        'Intended Audience :: Science/Research',
        'License :: OSI Approved :: BSD License',
        'Operating System :: OS Independent',
        'Programming Language :: Python :: 3 :: Only'
        'Programming Language :: Cython',
        'Topic :: Scientific/Engineering',
        ]

MAJOR               = 0
MINOR               = 1
MICRO               = 0
ISRELEASED          = False
VERSION             = '%d.%d.%d' % (MAJOR, MINOR, MICRO)



def git_version():
    """Return the git revision as a string"""
    def _minimal_ext_cmd(cmd):
        # construct minimal environment
        env = {}
        for k in ['SYSTEMROOT', 'PATH']:
            v = os.environ.get(k)
            if v is not None:
                env[k] = v
        # LANGUAGE is used on win32
        env['LANGUAGE'] = 'C'
        env['LANG'] = 'C'
        env['LC_ALL'] = 'C'
        out = subprocess.Popen(cmd, stdout = subprocess.PIPE, env=env).communicate()[0]
        return out

    try:
        out = _minimal_ext_cmd(['git', 'rev-parse', 'HEAD'])
        GIT_REVISION = out.strip().decode('ascii')
    except OSError:
        GIT_REVISION = "Unknown"

    return GIT_REVISION



def get_version_info():
    # Adding the git rev number needs to be done inside write_version_py(),
    # otherwise the import of numpy.version messes up the build under Python 3.
    FULLVERSION = VERSION
    if os.path.exists('.git'):
        GIT_REVISION = git_version()
    elif os.path.exists('geometry/version.py'):
        # must be a source distribution, use existing version file
        try:
            from geometry.version import git_revision as GIT_REVISION
        except ImportError:
            raise ImportError("Unable to import git_revision. Try removing " \
                              "geometry/version.py and the build directory " \
                              "before building.")
    else:
        GIT_REVISION = "Unknown"

    if not ISRELEASED:
        FULLVERSION += '.dev-' + GIT_REVISION[:7]

    return FULLVERSION, GIT_REVISION


def write_version_py(filename='geometry/version.py'):
    cnt = """
# THIS FILE IS GENERATED FROM NUMPY SETUP.PY
short_version = '%(version)s'
version = '%(version)s'
full_version = '%(full_version)s'
git_revision = '%(git_revision)s'
release = %(isrelease)s

if not release:
    version = full_version
"""
    FULLVERSION, GIT_REVISION = get_version_info()

    a = open(filename, 'w')
    try:
        a.write(cnt % {'version': VERSION,
                       'full_version' : FULLVERSION,
                       'git_revision' : GIT_REVISION,
                       'isrelease': str(ISRELEASED)})
    finally:
        a.close()



class write_version_file(Command):
    
    user_options = []
    
    def initialize_options(self):
        pass
    
    def finalize_options(self):
        pass
    
    def run(self):
        write_version_py()


FULLVERSION, GIT_REVISION = get_version_info()


#core = Extension(
    #'geometry.core',            
    #[os.path.join("geometry", "core.pyx")],     
    #language='c++',         
    #libraries=['stdc++'],
    #include_dirs = ['.'],  
    #)

#CMDCLASS = {'build' : build,
            #'build_ext': build_ext,
            #'write_version'  : write_version_file,
            #}


setup(
    name='geometry',
    version='0.2',
    author='Frederik Rietdijk',
    author_email='fridh@fridh.nl',
    description='Python Geometry',
    long_description=open('README.md').read(),
    url="https://github.com/FRidh/python-geometry",
    download_url="",
    ext_modules = cythonize('geometry/*.pyx'),
    data_files=[],
    license='BSD',
    platforms = ['any'],
    classifiers=CLASSIFIERS,
    packages=['geometry'],
    install_requires=[
        'numpy',
        'cython',
        ],
    #cmdclass = CMDCLASS,
    zip_safe=False,
    include_dirs = [np.get_include()],  

)
