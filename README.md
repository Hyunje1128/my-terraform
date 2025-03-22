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

---

Feel free to fork and adapt for your own environment.

---
