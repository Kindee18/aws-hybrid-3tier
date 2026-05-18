# Production-Grade Hybrid 3-Tier + Serverless Platform (AWS/Terraform)

![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)

This repository contains a **High-Availability, Architect-Level Hybrid Infrastructure** deployed via Terraform. It seamlessly integrates a traditional 3-tier web application (EC2/ASG/RDS) with a modern serverless API (Lambda/API Gateway), protected by enterprise-grade security and automated governance.

## 🏗️ Architecture Overview

The platform is designed for **100% High Availability** and follows the **AWS Well-Architected Framework**.

*   **Networking Tier**: 1 VPC with **18 Subnets** distributed across 6 Availability Zones (Public, Private, Database).
*   **Compute Tier**: 
    *   **Traditional**: Flask Application running on an Auto Scaling Group (ASG) behind an Application Load Balancer (ALB).
    *   **Serverless**: Python Lambda function integrated with an HTTP API Gateway.
*   **Database Tier**: Multi-AZ RDS PostgreSQL instance with automated backups and deletion protection.
*   **Storage Tier**: Private S3 Bucket for static assets, served via **CloudFront** with **Origin Access Control (OAC)**.
*   **Management Tier**: Zero-Trust **SSM Bastion** host with no open SSH ports.

## 🌟 Architect-Level Features

What makes this project different from basic tutorials:

### 1. **Zero-Trust Management (SSM)**
Administrative access is handled through **AWS Systems Manager (SSM)**. The Bastion host sits in a private subnet with **zero inbound security group rules**. All traffic stays on the AWS backbone via **VPC Interface Endpoints**.

### 2. **Self-Healing Governance (AWS Config + Lambda)**
Implemented **Governance-as-Code**. An AWS Config rule monitors Security Groups for unauthorized SSH exposure (Port 22). If a violation is detected, a **Remediation Lambda** automatically deletes the non-compliant rule within milliseconds.

### 3. **Blue/Green & Canary Deployments**
The compute tier supports zero-downtime releases using **Weighted ALB Routing**. You can shift traffic incrementally (e.g., 90% Blue / 10% Green) to test new versions before full commitment.

### 4. **Operational Observability**
A comprehensive **CloudWatch Operations Dashboard** provides real-time telemetry for:
*   ALB Request Count & 5XX Error rates.
*   P99 Target Response Latency.
*   ASG Instance Health (Desired vs. In-Service).
*   RDS CPU Utilization & Connection counts.

## 🔒 Security Hardening
*   **WAF Integration**: ALB is protected by an AWS Web Application Firewall.
*   **VPC Flow Logs**: Full network audit logging enabled.
*   **FinOps Managed Logs**: Explicit CloudWatch Log Groups with 7-day retention to prevent infinite storage costs.
*   **IMDSv2 Enforced**: Metadata service hardening on all EC2 instances.
*   **Secret Protection**: No hardcoded credentials; Git history purged of all sensitive placeholder data.

## 🚀 Quick Start

### Prerequisites
*   Terraform >= 1.14
*   AWS CLI configured
*   (Optional) Moto/LocalStack for local validation

### Deployment
1.  Navigate to the terraform directory:
    ```bash
    cd terraform
    ```
2.  Initialize the project:
    ```bash
    terraform init
    ```
3.  Create your environment variables (refer to `environments/example.tfvars`):
    ```bash
    cp environments/example.tfvars environments/dev.tfvars
    # Edit dev.tfvars with your specific values
    ```
4.  Deploy to AWS:
    ```bash
    terraform plan -var-file=environments/dev.tfvars
    terraform apply -var-file=environments/dev.tfvars
    ```

## 🛠️ Local Validation
This project has been 100% verified using **Moto Docker** to simulate a 120+ resource AWS environment. Every dependency and logic path has been traces and confirmed physically sound.

## 📄 License
Distributed under the MIT License. See `LICENSE` for more information.

---
**Maintained by:** [Kindee18](https://github.com/Kindee18)  
*Part of the Cloud Engineering Tools Mastery Series.*
