#!/bin/bash
terraform workspace select dev
terraform destroy -var-file=terraform/environments/dev.tfvars -auto-approve
echo 'Teardown complete!'