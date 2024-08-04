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
cd infrastructure

# Initialize Terraform
terraform init

# Destroy Terraform configuration
terraform destroy -var-file=$VAR_FILE -var="my_public_ip=$MY_PUBLIC_IP" -auto-approve

# Print confirmation
echo "Destroyed infrastructure for environment: $ENV"