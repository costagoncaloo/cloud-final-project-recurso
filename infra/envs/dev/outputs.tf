//modulo VPC
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

//modulo db

output "app_security_group_id" {
  value = aws_security_group.app.id
}

output "database_endpoint" {
  value = module.db.endpoint
}

output "database_name" {
  value = module.db.database_name
}

output "ecr_repository_urls" {
    value = module.ecr.repository_urls
    }

output "ecr_repository_names" {
    value = module.ecr.repository_names
    }



