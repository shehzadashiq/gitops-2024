terraform {

  cloud {
    # The name of your Terraform Cloud organization.
    organization = "shehzad"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "GitOps-2024"
    }
  }

  backend "s3" {
    bucket         = "gitops-tf-backend-shehzadashiq"
    key            = "terraform.tfstate"
    dynamodb_table = "GitopsTerraformLocks"
    region         = var.region
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.69.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region
}