locals {
  tf_credential_file = "./../../.credentials/prod-aws-pdns-svc.json"
  tf_credential      = jsondecode(file(local.tf_credential_file))
}

terraform {
  required_version = ">= 1.0.0, < 2.0.0"
  backend "gcs" {
    bucket      = "iac_prod_bucket"
    credentials = "./../../.credentials/prod-gcp-tf-backend.json"
    prefix      = "pdns-infra/aws-prod-fra"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region     = "eu-central-1"
  access_key = local.tf_credential.AccessKeyId
  secret_key = local.tf_credential.SecretAccessKey
}
