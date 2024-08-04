terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  backend "gcs" {
    bucket      = "iac_uat_bucket"
    credentials = "./../../.credentials/uat-gcs-backend.json"
    prefix      = "pdns-infra/azure-hk"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.19"
    }
  }
}

locals {
  credential_file = "./../../.credentials/uat-azure-pdns-tf-svc.json"
  credential      = jsondecode(file(local.credential_file))
}

provider "azurerm" {
  features {
    virtual_machine_scale_set {
      roll_instances_when_required = false
    }
  }

  skip_provider_registration = true

  subscription_id = "4c6d5afb-6789-4bda-8a6a-ca10ad2f5675"
  tenant_id       = local.credential.tenant
  client_id       = local.credential.appId
  client_secret   = local.credential.password
}

