terraform {
  required_version = ">= 1.17" #terraform version cli client version

  required_providers {
    aws = {
      source  = "hashicorp/aws" #where is the provider to get download.. 
      version = "~> 6.0"
    }


  }
}