# Deployment Guide

## Prerequisites
- AWS account with IAM user (admin or appropriate permissions)
- Terraform 1.5+
- AWS CLI configured

## Steps
1. Clone repo
2. terraform init
3. terraform workspace new dev
4. terraform apply -var-file=terraform/environments/dev.tfvars

## Teardown
./teardown.sh
