# -*- coding: utf-8 -*-


help: ## ** Show this help message
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


up: ## ** Set Up the Virtual Environment
	bash ./bin/up.sh


remove: ## ** Remove Virtual Environment
	bash ./bin/remove.sh


clean: ## Clean temp files
	bash ./bin/clean.sh


#--- Install ---
pip-uninstall: ## ** Uninstall This Package
	bash ./bin/pip-uninstall.sh


pip-install: pip-uninstall ## ** Install This Package via setup.py
	bash ./bin/pip-install.sh


pip-dev-install: pip-uninstall ## ** Install This Package in Editable Mode
	bash ./bin/pip-dev-install.sh


req-dev: ## Install Development Dependencies
	bash ./bin/req-dev.sh


req-doc: ## Install Document Dependencies
	bash ./bin/req-doc.sh


req-test: ## Install Test Dependencies
	bash ./bin/req-test.sh


#--- Test ---
test: pip-dev-install req-test ## ** Run test
	bash ./bin/test.sh


test-only: ## Run test without checking test dependencies
	bash ./bin/test.sh


cov: pip-dev-install req-test ## ** Run Code Coverage test
	bash ./bin/test-cov.sh


cov-only: ## Run Code Coverage test without checking test dependencies
	bash ./bin/test-cov.sh


tox: ## Run multi python version test with tox
	bash ./bin/test-tox.sh


#--- Document ---
build-doc-only: ## Build Documents, skip check doc dependencies, skip clean existing doc
	bash ./bin/build-doc-only.sh


build-doc: req-doc pip-dev-install ## ** Build Documents, start over
	bash ./bin/build-doc.sh


view-doc: ## ** Open Html Document
	bash ./bin/view-doc.sh


deploy-doc-to-version: ## Deploy Html Document to the "x.x.x" version directory on AWS S3
	bash ./bin/deploy-doc-to-version.sh


deploy-doc-to-latest: ## Deploy Html Document to the "latest" directory on AWS S3
	bash ./bin/deploy-doc-to-latest.sh


deploy-doc: ## ** Deploy Html Document to both "x.x.x" and "latest" directory on AWS S3
	bash ./bin/deploy-doc.sh


build-and-deploy-doc: build-doc deploy-doc ## ** Build and deploy Html Document to AWS S3


clean-doc: ## ** Deploy Html Document to AWS S3
	bash ./bin/clean-doc.sh


#--- Other ---
reformat: req-dev ## ** Pep8 Format Python Source Code
	bash ./bin/reformat-python-code.sh


publish: req-dev ## ** Publish This Package to PyPI
	bash ./bin/publish-to-pypi.sh


notebook: ## ** Run jupyter notebook
	bash ./bin/run-notebook.sh


info: ## ** Show information about python, pip in this environment
	bash ./bin/info.sh


#--- AWS Lambda ---
lbd-build-deploy-pkg: ## Build lambda deployment package
	bash ./bin/build-lbd-deploy-pkg.sh


lbd-upload-deploy-pkg: ## Upload lambda deployment package to s3
	bash ./bin/upload-lbd-deploy-pkg.sh


lbd-build-and-upload-deploy-pkg: lbd-build-deploy-pkg lbd-upload-deploy-pkg ## Build and upload lambda deployment package to s3


lbd-deploy: ## Deploy lambda function
	bash ./bin/deploy-lbd.sh
