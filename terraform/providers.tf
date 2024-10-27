terraform {

  cloud {
    # The name of your Terraform Cloud organization.
    organization = "shehzad"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "GitOps-2024"
    }
  }

  # S3 configuration is not required as we are using a cloud configuration
  # Using both will generate the following error
  # Error: Both a backend and cloud configuration are present
  # backend "s3" {
  #   bucket         = "gitops-tf-backend-shehzadashiq"
  #   key            = "terraform.tfstate"
  #   dynamodb_table = "GitopsTerraformLocks"
  #   region         = "eu-west-2"
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.69.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.5"
    }
  }
}

provider "aws" {
  region = var.region

}