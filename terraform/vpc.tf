module "vpc" {
  source          = "../modules/tf-vpc"
  region          = var.region
  short_region    = var.short_region
  cidr            = var.vpc_ip_cidr
  account_name    = var.name
  private_subnets = flatten([for name, subnet in var.vpc_subnets_map["private"] : keys(subnet) if name == "general"])
  public_subnets  = flatten([for name, subnet in var.vpc_subnets_map["public"] : keys(subnet) if name == "general"])
  tags            = var.tags
}

#----------------------------------------------------------------

# SSM Parameter Store Values 

resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.name}/${var.short_region}/vpc/id"
  type  = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "vpc_ip_cidr" {
  name  = "/${var.name}/${var.short_region}/vpc/cidr_block"
  type  = "String"
  value = var.vpc_ip_cidr
}

resource "aws_ssm_parameter" "public_subnets" {
  name  = "/${var.name}/${var.short_region}/vpc/public_subnet/ids"
  type  = "StringList"
  value = join(",", module.vpc.public_subnets)
}

resource "aws_ssm_parameter" "private_subnets" {
  name  = "/${var.name}/${var.short_region}/vpc/private_subnet/ids"
  type  = "StringList"
  value = join(",", module.vpc.private_subnets)
}

