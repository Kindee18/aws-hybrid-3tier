# aws-hybrid-3tier

Production-grade Hybrid 3-Tier + Serverless Platform on AWS using Terraform

Part 1 of Cloud Engineering Tools Mastery Series.

## Architecture
See ARCHITECTURE.md for Mermaid diagram.

## Quick Deploy
```bash
cd terraform
terraform init
terraform workspace new dev
terraform apply -var-file=environments/dev.tfvars
```
