variable "name" {
  description = "Prefix used for naming all resources for unique identification."
  type        = string
}

variable "account_id" {
  description = "The AWS account where the resources will be created"
  type        = string
}

variable "account_name" {
  description = "The name of the AWS account where the code is being deployed"
}

variable "aws_region" {
  description = "The AWS region where the resources will be created."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the application and related resources will be deployed."
}

variable "vpc_ip_cidr" {
  type = string
  # default     = 
}

variable "public_subnets_ids" {
  description = "List of IDs for the public subnets where the Application Load Balancer (ALB) will be deployed."
  type        = list(string)
  # default = aws_ssm_parameter.public_subnets.id
}

variable "private_subnet_ids" {
  description = "List of IDs for the private subnets where the ECS service and tasks will be deployed."
  type        = list(string)
  # default = aws_ssm_parameter.private_subnets.id
}

variable "ssl_certificate_arn" {
  description = "The ARN of the SSL certificate to be used by the Application Load Balancer (ALB) for HTTPS support."
}

variable "zone_id" {
  description = "The ID of the DNS zone where the DNS record for the service will be created."
}

variable "dns_record_name" {
  description = "The DNS record name to be used for the service, facilitating access via a custom domain name."
}

variable "container_name" {
  description = "The name of the container to be used in task definitions. It acts as a key for linking with the Application Load Balancer."
}

variable "image" {
  description = "The Docker image to be used for running the service. Format should be repository/image:tag."
}

variable "app_port" {
  description = "The network port that the Docker container exposes and which will be used by the load balancer to route traffic to the container."
#   default     = 80
}

variable "app_count" {
  description = "The desired number of instances of the Docker container to run within the ECS service."
#   default     = 3
}

variable "health_check_path" {
  description = "The path used by the load balancer to perform health checks on the Docker container."
  # default     = "/"
  # default     = "/images/logo.svg" #the actual heath_check_path for IA.
}

variable "container_cpu" {
  description = "The amount of CPU to allocate for the Fargate task. Specified in CPU units (1 vCPU = 1024 CPU units)."
}

variable "container_memory" {
  description = "The amount of memory to allocate for the Fargate task, specified in MiB."
}
