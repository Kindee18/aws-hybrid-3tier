# Cloud Engineering Tools Series - Project 1

**Hybrid Multi-Environment 3-Tier + Serverless Platform on AWS (Terraform)**

Part 1 of the Cloud Engineering Tools Mastery Series.

## Architecture
- Custom VPC (multi-AZ)
- Application Load Balancer + EC2 Auto Scaling Group (Flask API)
- RDS PostgreSQL + DynamoDB
- API Gateway + Lambda (serverless extension)
- S3 + CloudFront
- Multi-environment support (dev/staging/prod via workspaces)
- Remote state with S3 + DynamoDB locking

## Quick Start
1. `terraform init`
2. `terraform workspace new dev`
3. `terraform apply -var-file=environments/dev.tfvars`

See `DEPLOY.md` for full instructions.

**Built as foundation for Docker, K8s, CI/CD, and Observability in future projects.**