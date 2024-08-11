locals {
  # ECS Fargate
  private_subnet_ids = slice(split(",", nonsensitive(data.aws_ssm_parameter.private_subnets.value)), 0, 2)
  public_subnet_ids  = split(",", nonsensitive(data.aws_ssm_parameter.public_subnets.value))
}

