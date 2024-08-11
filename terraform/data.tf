data "aws_ssm_parameter" "vpc_id" {
    name      = "/${var.name}/${var.short_region}/vpc/id"
}

data "aws_ssm_parameter" "private_subnets" {
    name      = "/${var.name}/${var.short_region}/vpc/private_subnet/ids"
}

data "aws_ssm_parameter" "public_subnets" {
    name      = "/${var.name}/${var.short_region}/vpc/public_subnet/ids"
}

data "aws_ssm_parameter" "vpc_cidr" {
  name = "/${var.name}/${var.short_region}/vpc/cidr_block"
}

data "aws_ssm_parameter" "certificate_arn" {
    name = "/${var.name}/global/acm/certificate/arn" 
}

data "aws_route53_zone" "selected" {
  name         = "niiadu.com"
  private_zone = false
}
