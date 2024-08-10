################################################################
# General
################################################################
variable "tags" {
  description = "A map of default tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "Account name to use in naming resources"
  type        = string
  default     = "jomacsit"
}

variable "short_region" {
  description = "Short form of the AWS region"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "account_name" {
}

variable "account_id" {
  description = "Account id of the account the resources would be created"
  type = string
  default = "736024348173"
}


#################################################################
# VPC
#################################################################
variable "vpc_ip_cidr" {
}

variable "vpc_subnets_map" {
  type        = map(any)
  description = "Map of CIDR-to-subnet associations"
}

#################################################################
# Route53
#################################################################
# variable "zone_id" {
#   type    = string
# }

# variable "zone_name" {
#   type    = string
# }

variable "domain_name" {
  type    = string
  default = "niiadu.com"
}
