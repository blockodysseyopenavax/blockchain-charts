terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }

  backend "s3" {
    region = "ap-northeast-2"
    bucket = "blockchain-tfstates"
    key    = "devnet/terraform.tfstate"
  }
}
