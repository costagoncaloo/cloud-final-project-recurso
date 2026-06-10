locals {
  name_prefix = "${var.project}-${var.environment}"
}

module "vpc" {
  source = "../../modules/vpc"

  name_prefix = local.name_prefix
}

module "queue" {
  source = "../../modules/queue"

  name_prefix = local.name_prefix
}

resource "aws_security_group" "app" {
  name        = "${local.name_prefix}-app-sg"
  description = "Allow HTTP demo ports and SSH"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    from_port   = 8081
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "db" {
  source = "../../modules/db"

  name_prefix        = local.name_prefix
  private_subnet_ids = module.vpc.private_subnet_ids
  app_security_group = aws_security_group.app.id
  database_name      = "ecommerce"
  database_username  = var.db_username
  database_password  = var.db_password
}

module "compute" {
  source = "../../modules/compute"

  name_prefix           = local.name_prefix
  public_subnet_id      = module.vpc.public_subnet_ids[0]
  app_security_group_id = aws_security_group.app.id
  ec2_key_name          = var.ec2_key_name
  order_queue_arn       = module.queue.order_created_queue_arn
  image_registry        = var.image_registry
  database_endpoint     = module.db.endpoint
  database_name         = module.db.database_name
  database_username     = var.db_username
  database_password     = var.db_password
  order_queue_url       = module.queue.order_created_queue_url
  aws_region            = var.aws_region
}
