# Definitive Cost Estimate (Monthly - us-east-1, 2026)

This estimate provides a high-fidelity breakdown based on verified AWS pricing and Infracost audits. It reflects a **Production-Grade (High Availability)** architecture.

| Service | Component | 2026 Rate | Monthly Base Cost |
| :--- | :--- | :--- | :--- |
| **Networking** | 3 NAT Gateways (1 per AZ) | $0.045/hr | $98.55 |
| | 3 Public IPv4 Addresses (Elastic IPs for NAT) | $0.005/hr | $10.95 |
| | 4 VPC Interface Endpoints (SSM, SSM Msg, EC2 Msg, SecretsMgr) | $0.01/hr per AZ mapping | $87.60 |
| | VPC Flow Logs | $0.50/GB (Ingest) | ~$2.00 |
| **Database** | Aurora Serverless v2 Cluster (2 Instances @ 0.5 ACU baseline)* | $0.12/ACU-hour | $87.60 |
| | Aurora Storage (gp3 standard) | $0.10/GB-month | ~$2.00 |
| **Compute** | 2 x EC2 t4g.micro App instances (On-Demand Graviton) | $0.0084/hr | $12.26 |
| | Application Load Balancer (ALB) | $0.0225/hr | $16.43 |
| | 1 x EC2 t3.nano SSM Bastion Host (On-Demand) | $0.0052/hr + 8GB gp2 storage | $4.60 |
| **Security** | AWS WAF (Base Web ACL) | $5.00/month | $5.00 |
| | AWS Secrets Manager (1 Secret) | $0.40/secret | $0.40 |
| **Storage & CDN** | S3 Standard Storage (5GB assets) & CloudFront | Base rates (Free tier egress) | ~$0.10 |
| **Observability** | CloudWatch Dashboard & Alarms | $3.00/dashboard + $0.10/alarm | $3.20 |
| **Governance** | AWS Config (Configuration recordings) | $0.003/recording | ~$2.00 |
| **Total** | | | **~$332.69/month** |

*\*Note: Aurora Serverless v2 automatically scales down to 0.5 ACUs per instance when idle. If traffic spikes, it scales up to 1.0 ACU dynamically, which would increase the database compute cost to $175.20/month.*

---

## 💡 Implemented FinOps Strategies (Verified)

### 1. The "NAT Tax" Killer (Save ~$65.70/month in Dev)
*   **Production**: Uses 3 NAT Gateways (1 per AZ) for High Availability.
*   **Development**: Automatically scales down to **1 Shared NAT Gateway** and 1 Elastic IP.
*   **S3 Gateway Endpoints**: Implemented free VPC Gateway Endpoints that bypass NAT processing fees entirely for internal AWS S3 traffic.

### 2. VPC Endpoint Scaling (Save ~$58.40/month in Dev)
*   **Production**: Spans all 4 VPC Interface Endpoints across 3 Availability Zones (12 total connections) to ensure private routing redundancy.
*   **Development**: Automatically restricts endpoints to **1 single Availability Zone** (4 connections), testing the routing logic at 1/3 of the cost.

### 3. Next-Gen Hardware (Save 20%)
*   **Graviton Migration**: Standardized on **ARM64 (t4g.micro)** instances for the application tier, which are 20% cheaper than legacy Intel/AMD (t3) instances with better performance.

### 4. Smart Compute (Save 64%)
*   **Automated Spot Instances**: Non-prod environments automatically switch the application Auto Scaling Groups to **Spot Market** pricing, reducing EC2 compute costs from $12.26/mo to **$2.45/mo**.
*   **Capacity Downscaling**: Non-prod automatically scales down the desired fleet capacity to **1 instance** (saving an extra 50% on compute spend) while maintaining 2 instances in production.

### 5. Storage & Lifecycle (Save 40-60%)
*   **S3 Intelligent-Tiering**: Automated logic transitions data to cheaper tiers without retrieval fees.
*   **Log Retention**: Enforced a **7-day retention** on all CloudWatch logs to prevent infinite storage growth.
