cwd := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
env_file := $(cwd)/.env
tf_approve_opts = --auto-approve
TF_VAR_aws_access_key = ${AWS_ACCESS_KEY_ID}
TF_VAR_aws_secret_key = ${AWS_SECRET_ACCESS_KEY}

ifneq ("$(wildcard $(env_file))","")
	include $(env_file)
	export
endif

wrap_targets := terraform tf kubectl
ifneq ($(filter $(firstword $(MAKECMDGOALS)), $(wrap_targets)), )
  RUN_ARGS := $(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif

all: version init-all apply-all
	@echo Done!
	@echo Please run: 'eval $$(make config)'

env:
	@env

version:
	terraform --version
	terragrunt --version

config:
	@echo export KUBECONFIG=$(KUBECONFIG)
	@echo export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
	@echo export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}

init-all:
	terragrunt run-all init

plan-all:
	terragrunt run-all plan

apply-all:
	terragrunt run-all apply

ec2:
	aws ec2 describe-instances
