# Architecture

```mermaid
graph TD
    A[Internet] --> B[ALB]
    B --> C[EC2 Auto Scaling]
    C --> D[RDS PostgreSQL]
    C --> E[API Gateway + Lambda]
    F[S3 + CloudFront] --> A
```

Full hybrid 3-tier + serverless design with best practices.