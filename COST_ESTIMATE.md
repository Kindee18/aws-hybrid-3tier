# Verified Cost Estimate (Monthly - us-east-1, 2026)

This estimate provides a realistic breakdown of the costs associated with running this architect-level 3-tier platform in a **Production-Grade (High Availability)** configuration.

| Service | Component | Monthly Base Cost |
|---------|-----------|-------------------|
| **Networking** | 6 NAT Gateways ($36.50 ea)* | ~$219.00 |
| | VPC Flow Logs (Storage/Ingest) | ~$5.00 |
| **Compute** | 2-4 EC2 t3.micro (Private Subnets) | ~$15.20 |
| | Application Load Balancer | ~$22.27 |
| **Database** | RDS PostgreSQL (Multi-AZ db.t3.micro) | ~$28.02 |
| | Performance Insights | Free (Basic) |
| **Serverless** | Lambda + API Gateway | ~$1.00 (Free Tier applies) |
| **Storage** | S3 (Standard) + CloudFront | ~$3.00 |
| **Security** | AWS WAF ($10/WebACL + Usage) | ~$12.00 |
| **Total** | | **~$305.49/month** |

*\*Note: Each of the 6 AZs has a dedicated NAT Gateway for 100% High Availability.*

---

## 💡 Cost Optimization Strategies (The "Pro" Way)

### 1. Networking (Save ~$180/month)
*   **Dev/Staging Strategy**: Use a single NAT Gateway shared across all AZs.
*   **NAT Instances**: Use a t3.nano instance as a NAT server instead of the managed service.

### 2. Compute (Save up to 90%)
*   **Spot Instances**: Use Spot for the ASG fleets in Dev/Staging environments.

### 3. Database (Save 30-50%)
*   **Reserved Instances**: Purchase a 1-year or 3-year commitment for production database instances.
*   **Single-AZ for Dev**: Switch RDS to Single-AZ for non-production environments to cut the DB bill in half ($14/month).

### ⚠ Critical Warning: Extended Support Fees
AWS now charges **$0.10 per vCPU-hour** for older PostgreSQL versions (v11, v12, v13). 
*   **Impact**: This can add **$146.00/month** to your bill.
*   **Prevention**: Always ensure your RDS is running **PostgreSQL v14 or higher** (This project uses v15).

---
*Prices are estimated based on us-east-1 on-demand rates for May 2026.*
