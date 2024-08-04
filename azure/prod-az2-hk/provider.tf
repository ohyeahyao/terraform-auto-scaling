terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  backend "gcs" {
    bucket      = "iac_prod_bucket"
    credentials = "./../../.credentials/prod-gcp-tf-backend.json"
    prefix      = "pdns-infra/az2-hk"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.19"
    }
  }
}

locals {
  credential_file = "./../../.credentials/prod-az2-pdns.json"
  credential      = jsondecode(file(local.credential_file))
}

provider "azurerm" {
  features {
    virtual_machine_scale_set {
      roll_instances_when_required = false
    }
  }

  skip_provider_registration = true

  subscription_id = local.credential.subscriptionId
  tenant_id       = local.credential.tenant
  client_id       = local.credential.appId
  client_secret   = local.credential.password
}

