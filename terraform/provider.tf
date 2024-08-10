terraform {
  backend "s3" {
    bucket = "niiadu12"
    key = "niiadu/tf-deployment/d010624-ecsstuff.tfstate"
    region = "eu-north-1"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">=5.39.0"
    }
  }
}
