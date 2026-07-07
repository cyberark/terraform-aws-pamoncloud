terraform {
  required_version = ">= 1.9.8, <= 1.13.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.73.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
    }
  }
}