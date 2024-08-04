# Terraform Infrastructure Management for AWS and Azure

## Overview
This repository contains Terraform scripts for managing infrastructure on AWS and Azure. The primary goal is to set up Auto Scaling Groups to ensure high availability and scalability of applications. The directory structure is divided into modules for reusability and environments for managing configurations in different deployment regions.

## Directory Structure
### aws

- `modules/`: Contains reusable Terraform modules.
  - `app/`: Manages the application Auto Scaling Group and related resources.
  - `global-accelerator/`: Manages AWS Global Accelerator.
  - `key_pair/`: Manages SSH key pairs.
  - `launch_template/`: Manages launch templates for EC2 instances.
  - `network/`: Manages network resources such as Internet Gateway and route tables.
  - `security-group/`: Manages security groups and load balancer security groups.
  - `sns/`: Manages SNS topics and subscriptions for auto scaling notifications.

- `prod-ap-southeast-1/`: Production environment configuration for Asia Pacific (Singapore).
- `prod-ap-southeast-2/`: Production environment configuration for Asia Pacific (Sydney).
- `prod-eu-central-1/`: Production environment configuration for Europe (Frankfurt).
- `prod-global/`: Global configuration containing regional resource setups.

### azure

- `modules/`: Contains reusable Terraform modules.
  - `app/`: Manages the application Auto Scaling Group and related resources.
  - `general/`: Manages general resources like image galleries and network configurations.
  - `image-gallery/`: Manages Azure image galleries.
  - `network/`: Manages network resources like virtual networks and security groups.

- `prod-az2-hk/`: Production environment configuration for Hong Kong.
- `uat-hk/`: User Acceptance Testing environment configuration for Hong Kong.

## Usage Instructions

1. Run `terraform init` in the appropriate directory to initialize the Terraform working directory.
2. Run `terraform plan` to review the changes that will be made.
3. Run `terraform apply` to apply the configuration and deploy the infrastructure.
