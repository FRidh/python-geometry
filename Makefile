DOCS=docs

compile:	
	python setup_cython.py build_ext --inplace

documentation:	
	cd ${DOCS}; make html
	
push_docs:
	make documentation
	ghp-import -np ${DOCS}/_build/html
