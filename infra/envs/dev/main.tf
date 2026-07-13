locals {
  name_prefix = "${var.project}-${var.environment}"
}


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

//Modulo DB

module "db" {
  source = "../../modules/db"

  name_prefix           = local.name_prefix
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  app_security_group_id = aws_security_group.app.id
  database_name         = "ecommerce"
  database_username     = var.db_username
  database_password     = var.db_password
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


