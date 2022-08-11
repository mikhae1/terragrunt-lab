env_file := .env
tf_approve_opts = --auto-approve
tg_approve_opts = --terragrunt-non-interactive

ifneq ("$(wildcard $(env_file))","")
	include $(env_file)
	export
endif

wrap_targets := terraform terragrunt tf kubectl
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
	@echo export KUBECONFIG=${KUBECONFIG}
	@echo export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
	@echo export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
	@echo export S3_BUCKET=${S3_BUCKET}

ec2:
	aws ec2 describe-instances --output table

init-all:
	terragrunt run-all init -upgrade --terragrunt-source-update

plan-all:
	terragrunt run-all plan

apply-all:
	terragrunt run-all apply ${tg_approve_opts}

destroy-all:
	terragrunt run-all destroy

terragrunt:
	terragrunt $(RUN_ARGS)

reset-lock:
	find . -name '.terraform.lock.hcl' -prune -exec rm -rf {} \;

reset-cache:
	find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \;
