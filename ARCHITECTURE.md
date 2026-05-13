# Architecture

```mermaid
graph TD
    A[Internet] --> B[ALB]
    B --> C[EC2 ASG - Flask App]
    C --> D[RDS PostgreSQL]
    C --> E[API Gateway + Lambda]
    B --> F[CloudFront + S3]
```

Full hybrid 3-tier + serverless.
