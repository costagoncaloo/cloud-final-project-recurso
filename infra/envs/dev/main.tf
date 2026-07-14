locals {
  name_prefix = "${var.project}-${var.environment}"
}

data "aws_caller_identity" "current" {}

//modulo VPC
module "vpc" {
  source = "../../modules/vpc"

  name_prefix = local.name_prefix
}

//Security group

resource "aws_security_group" "app" {
  name        = "${local.name_prefix}-app-sg"
  description = "Security group for the application host"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from the developer machine"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "Demo service ports"
    from_port   = 8081
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-app-sg"
  }
}

// Secrets

resource "aws_ssm_parameter" "db_username" {
  name  = "/${var.project}/${var.environment}/database/username"
  type  = "String"
  value = var.db_username

  tags = {
    Name = "${local.name_prefix}-db-username"
  }
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.project}/${var.environment}/database/password"
  type  = "SecureString"
  value = var.db_password

  tags = {
    Name = "${local.name_prefix}-db-password"
  }
}

resource "aws_ssm_parameter" "active_app_endpoint" {
  name  = "/${var.project}/dr/active-app-endpoint"
  type  = "String"
  value = "http://${module.compute.public_ip}"

  tags = {
    Name = "${var.project}-active-app-endpoint"
  }
}

//Modulo DB

module "db" {
  source = "../../modules/db"

  name_prefix             = local.name_prefix
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnet_ids
  app_security_group_id   = aws_security_group.app.id
  database_name           = "ecommerce"
  database_username       = var.db_username
  database_password       = var.db_password
  multi_az                = false
  backup_retention_period = 0
}

//Modulo ECR

module "ecr" {
  source = "../../modules/ecr"

  name_prefix = local.name_prefix

  service_names = [
    "catalog-service",
    "order-service",
    "notification-service"
  ]
}

//modulo EC2

module "compute" {
  source = "../../modules/compute"

  name_prefix           = local.name_prefix
  public_subnet_id      = module.vpc.public_subnet_ids[0]
  app_security_group_id = aws_security_group.app.id
  ssh_public_key_path   = var.ssh_public_key_path
  instance_type         = var.app_instance_type
  sqs_queue_arn         = module.queue.order_events_queue_arn
  ssm_parameter_arns = [
    aws_ssm_parameter.db_username.arn,
    aws_ssm_parameter.db_password.arn
  ]
}

//Modulo SQS

module "queue" {
  source = "../../modules/queue"

  name_prefix = local.name_prefix
}

// GitHub actions CD

module "github_actions" {
  source = "../../modules/github-actions"

  name_prefix            = local.name_prefix
  github_repository      = var.github_repository
  ecr_repository_arns    = values(module.ecr.repository_arns)
  aws_region             = var.aws_region
  aws_account_id         = data.aws_caller_identity.current.account_id
  app_security_group_id  = aws_security_group.app.id
  terraform_state_bucket = "cloud-recurso-tf-state-806758135628-euw1-v2"
  terraform_state_key    = "envs/dev/terraform.tfstate"
  terraform_lock_table   = "cloud-recurso-tf-locks"
}
