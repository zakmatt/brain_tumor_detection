#!/bin/bash

# Check if environment argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <environment>"
  echo "Environment should be either 'dev' or 'prod'."
  exit 1
fi

# Set the environment based on the input argument
ENV=$1

# Set the variable file based on the environment
if [ "$ENV" == "dev" ]; then
  VAR_FILE="vars/dev.tfvars"
elif [ "$ENV" == "prod" ]; then
  VAR_FILE="vars/prod.tfvars"
else
  echo "Invalid environment specified. Use 'dev' or 'prod'."
  exit 1
fi

export MY_PUBLIC_IP=$(curl -s ifconfig.me)
echo "My public IP is $MY_PUBLIC_IP"

# Navigate to the Terraform directory
cd infrastructure || return

# Initialize Terraform
terraform init

# Apply Terraform configuration
terraform apply -var-file=$VAR_FILE -var="my_public_ip=$MY_PUBLIC_IP" -auto-approve

ERROR_CODE=$?

if [ ${ERROR_CODE} != 0 ]; then
    exit ${ERROR_CODE}
fi

# Capture the outputs in variables
SAVE_BUCKET=$(terraform output -raw s3_bucket_name)
RDS_ENDPOINT=$(terraform output -raw rds_db_instance_endpoint)
RDS_DB_NAME=$(terraform output -raw rds_db_name)
RDS_USERNAME=$(terraform output -raw rds_username)
RDS_PASSWORD=$(terraform output -raw rds_password)

# Write the variables to a file
cat <<EOT > ./terraform_env.json
{
  "SAVE_BUCKET": "$SAVE_BUCKET",
  "RDS_ENDPOINT": "$RDS_ENDPOINT",
  "RDS_DB_NAME": "$RDS_DB_NAME",
  "RDS_USERNAME": "$RDS_USERNAME",
  "RDS_PASSWORD": "$RDS_PASSWORD"
}
EOT

# Print the environment variables to verify
echo "Environment: $ENV"
echo "SAVE_BUCKET: $SAVE_BUCKET"
echo "RDS_ENDPOINT: $RDS_ENDPOINT"
echo "RDS_DB_NAME: $RDS_DB_NAME"
echo "RDS_USERNAME: $RDS_USERNAME"
echo "RDS_PASSWORD: $RDS_PASSWORD"
