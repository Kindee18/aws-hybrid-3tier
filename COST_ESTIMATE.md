# Cost Estimate (Monthly - us-east-1)

| Service | Component | Estimated Cost |
|---------|-----------|----------------|
| **Networking** | NAT Gateway (2) | ~$64.80 |
| | Data Processing | ~$10.00 |
| **Compute** | EC2 t3.micro (2 instances) | ~$15.20 |
| | Application Load Balancer | ~$22.50 |
| **Database** | RDS PostgreSQL (db.t3.micro) | ~$13.00 |
| | Storage (20GB gp3) | ~$1.60 |
| **Serverless** | Lambda | Free Tier |
| | API Gateway | ~$1.00 |
| **Storage** | S3 (Standard) | ~$0.50 |
| | CloudFront | ~$2.00 |
| **Total** | | **~$130.60/month** |

## Cost Optimization Strategies
1. **Spot Instances:** Use Spot for non-production EC2 instances to save up to 90%.
2. **NAT Gateway Alternatives:** Use a single NAT Gateway for dev/staging or NAT Instances.
3. **RDS Reserved Instances:** 1-year or 3-year commitments for production databases.
4. **S3 Intelligent-Tiering:** Automatically move infrequently accessed assets to cheaper tiers.
