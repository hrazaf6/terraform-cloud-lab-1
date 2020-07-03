provider "aws" {
  region     = "us-east-1"
}

terraform {
    backend "remote" {
        organization = "cloudilm-dev"
        workspaces {
            name = "terraform-cloud-lab"
        }
    }
}