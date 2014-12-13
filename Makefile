DOCS=docs

develop:	
	python setup.py develop

documentation:	
	cd ${DOCS}; make html
	
push_docs:
	make documentation
	ghp-import -np ${DOCS}/_build/html
