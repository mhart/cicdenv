#!make

SHELL=/bin/bash

venv=.venv

zip_file=$(CURDIR)/s3apt.zip

AWS_PROFILE=admin-main
AWS_REGION=us-west-2

domain_config=$(CURDIR)/../../../domain.tfvars
domain=$(shell grep 'domain ' "$(domain_config)" | awk -F= '{print $$2}' | sed 's/[" ]//g' | sed 's/\./-/g')
s3_bucket=apt-repo-$(domain)

venv:
	if [ ! -d "$(venv)" ]; then python -m venv $(venv); fi
	source $(venv)/bin/activate;     \
	pip install --upgrade pip;       \
	pip install -r requirements.txt

test: venv
	source $(venv)/bin/activate; python s3apt.py *.deb

s3apt.zip: s3apt.py venv
	zip $(zip_file) s3apt.py 
	(cd $(venv)/lib/python*/site-packages/ ; zip -r $(zip_file) *)

package: s3apt.zip

publish: package
	aws --profile=$(AWS_PROFILE) --region=$(AWS_REGION) s3 cp $(zip_file) "s3://$(s3_bucket)/s3apt.zip"
