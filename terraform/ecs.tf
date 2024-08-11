module "ecs" {
  source              = "../modules/tf-ecs"
  name                = "jonas_project"
  account_id          = var.account_id
  account_name        = var.account_name
  aws_region          = var.region
  vpc_id              = aws_ssm_parameter.vpc_id.value
  vpc_ip_cidr         = data.aws_ssm_parameter.vpc_id.value
  private_subnet_ids  = local.private_subnet_ids
  public_subnets_ids  = local.public_subnet_ids
  ssl_certificate_arn = "arn:aws:acm:eu-north-1:736024348173:certificate/c382160d-b2c3-4863-b779-1f29ee6a9bc6"
  container_name      = "jomacsit"
  image               = "chriscloudaz/netflix:latest" #"213939666921.dkr.ecr.us-west-2.amazonaws.com/jomacsit"
  app_port            = 80
  app_count           = 2
  container_memory    = 2048
  container_cpu       = 1024
  zone_id             = data.aws_route53_zone.selected.zone_id
  dns_record_name     = "ecs"
  health_check_path   = "/"
}

#--------------------------------------------------------
