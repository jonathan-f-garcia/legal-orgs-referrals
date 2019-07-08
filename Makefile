WEB_APP_DIR=legal-orgs-referrals-app

S3_BUCKET_NAME=jpfg.legal-org-referrals.app
PROD_APP_VERSION=prod-v0.0.1
DEV_APP_VERSION=dev-v0.0.1

TERRAFORM_PROD_DIR=terraform/prod
TERRAFORM_DEV_DIR=terraform/dev

dev-deploy:
	terraform init ${TERRAFORM_DEV_DIR}
	terraform apply -auto-approve \
	                -var 'domain_name=${S3_BUCKET_NAME}' \
	                -var 'app_version=${DEV_APP_VERSION}' \
	                -state-out=${TERRAFORM_DEV_DIR}/dev.tfstate \
	                ${TERRAFORM_DEV_DIR}
	aws s3 sync ${WEB_APP_DIR} s3://${S3_BUCKET_NAME}.${DEV_APP_VERSION}

.PHONY: dev-deploy
