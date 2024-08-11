locals {
  # ECS Fargate
  private_subnet_ids = slice(split(",", (data.aws_ssm_parameter.private_subnets.value)), 0, 2)
  public_subnet_ids  = split(",", (data.aws_ssm_parameter.public_subnets.value))
}

