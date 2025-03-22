# My Terraform Infrastructure

This repository defines an AWS-based modular infrastructure using Terraform.

## 🔧 Project Structure

- **modules/**: Reusable Terraform modules
  - `vpc/`: VPC with public/private subnets, internet gateway
  - `alb/`: Application Load Balancer with listener and target group
  - `security/alb/`: ALB security group (HTTP ingress)
- **environments/**: Environment-specific configuration
  - `dev/`, `prod/`: References modules with environment-specific inputs

## 🚀 Usage

```bash
# Initialize Terraform
cd environments/dev
terraform init

# Preview changes
terraform plan

# Apply changes
terraform apply
```

## 🛡️ Modules Overview

### VPC Module
- Creates a VPC, public/private subnets (app, db), internet gateway, and route tables.

### ALB Module
- Deploys an Application Load Balancer in public subnets
- Creates HTTP listener and target group

### Security Group Module
- ALB security group allowing inbound HTTP (port 80)

## ✅ Prerequisites
- Terraform CLI >= 1.4.x
- AWS CLI configured with appropriate credentials

## 📦 Backend (optional)
Configure your `backend.tf` with S3 and DynamoDB for remote state management.

## 🔒 .gitignore
Sensitive and generated files are excluded from version control (see `.gitignore`).

## 📋 To-Do List

| 단계 | 항목 |
|------|------|
| 1️⃣ | VPC 모듈 보완 (IGW, Route Table 등) |
| 2️⃣ | EC2 + Auto Scaling Group 모듈 |
| 3️⃣ | EC2 보안 그룹 모듈 |
| 4️⃣ | RDS 모듈 |
| 5️⃣ | CodeDeploy / CodePipeline 모듈 |
| 6️⃣ | OpenVPN 모듈 |
| 7️⃣ | 환경 구성 보완 (`prod`, tfvars 등) |
| 8️⃣ | 고급 기능 (Remote backend, CI 등) |

---

Feel free to fork and adapt for your own environment.

---
