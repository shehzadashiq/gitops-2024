terraform {
  cloud {
    organization = "shehzad"

    workspaces {
      name = "GitOps-2024"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.69.0"
    }
  }
}

provider "aws" {
  region = var.region
  # access_key = var.TF_VAR_AWS_ACCESS_KEY_ID
  # secret_key = var.TF_VAR_AWS_SECRET_ACCESS_KEY
}