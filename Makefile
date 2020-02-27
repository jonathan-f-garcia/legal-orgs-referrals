WEB_APP_DIR=legal-orgs-referrals-app
S3_BUCKET_NAME=jpfg.legal-org-referrals.app

PROD_APP_VERSION=prod-v0.0.1
PROD_DB_NAME=${S3_BUCKET_NAME}.${PROD_APP_VERSION}.clinics-table
TERRAFORM_PROD_DIR=terraform/prod
TERRAFORM_PROD_DB_DIR=terraform/prod-db

DEV_APP_VERSION=dev-v0.0.1
DEV_DB_NAME=${S3_BUCKET_NAME}.${DEV_APP_VERSION}.clinics-table
TERRAFORM_DEV_DIR=terraform/dev
TERRAFORM_DEV_DB_DIR=terraform/dev-db

deploy-dev:
	terraform init ${TERRAFORM_DEV_DIR}
	terraform apply -auto-approve \
	                -var 'domain_name=${S3_BUCKET_NAME}' \
	                -var 'app_version=${DEV_APP_VERSION}' \
	                -state-out=${TERRAFORM_DEV_DIR}/dev.tfstate \
	                ${TERRAFORM_DEV_DIR}
	aws s3 sync ${WEB_APP_DIR} s3://${S3_BUCKET_NAME}.${DEV_APP_VERSION}

deploy-dev-db:
	terraform init ${TERRAFORM_DEV_DB_DIR}
	terraform apply -auto-approve \
	                -var 'domain_name=${S3_BUCKET_NAME}' \
	                -var 'app_version=${DEV_APP_VERSION}' \
	                -state-out=${TERRAFORM_DEV_DB_DIR}/dev-db.tfstate \
	                ${TERRAFORM_DEV_DB_DIR}

clean-dev-db:
	aws dynamodb delete-table --table-name "${DEV_DB_NAME}"

.PHONY: deploy-dev deploy-dev-db clean-dev-db
