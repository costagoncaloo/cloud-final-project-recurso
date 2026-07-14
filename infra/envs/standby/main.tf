locals {
  name_prefix = "${var.project}-${var.environment}"
}

module "vpc" {
  source = "../../modules/vpc"

  name_prefix = local.name_prefix
}

resource "aws_security_group" "app" {
  name        = "${local.name_prefix}-app-sg"
  description = "Security group for the standby application host"
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

module "queue" {
  source = "../../modules/queue"

  name_prefix = local.name_prefix
}

module "db" {
  source = "../../modules/db"

  name_prefix             = local.name_prefix
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnet_ids
  app_security_group_id   = aws_security_group.app.id
  database_name           = "ecommerce"
  database_username       = var.db_username
  database_password       = var.db_password
  multi_az                = var.database_multi_az
  storage_encrypted       = true
  backup_retention_period = 0
}

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
