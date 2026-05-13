#!/bin/bash
terraform destroy -auto-approve -var-file=environments/dev.tfvars
