{ buildPythonPackage
, pytest
, cython
, numpy
}:

buildPythonPackage rec {
  name = "geometry-${version}";
  version = "0.1dev";

  src = ./.;

  buildInputs = [ pytest cython ];
  propagatedBuildInputs = [ numpy ];

  meta = {
    description = "Geometry module for Python";
  };
}

