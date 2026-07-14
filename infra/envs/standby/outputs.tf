output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "app_security_group_id" {
  value = aws_security_group.app.id
}

output "database_endpoint" {
  value = module.db.endpoint
}

output "database_name" {
  value = module.db.database_name
}

output "database_identifier" {
  value = module.db.identifier
}

output "database_username_parameter_name" {
  value = aws_ssm_parameter.db_username.name
}

output "database_password_parameter_name" {
  value = aws_ssm_parameter.db_password.name
}

output "app_instance_id" {
  value = module.compute.instance_id
}

output "app_public_ip" {
  value = module.compute.public_ip
}

output "app_public_dns" {
  value = module.compute.public_dns
}

output "app_ssh_command" {
  value = "ssh -i ~/.ssh/cloud-recurso/cloud-recurso-dev ec2-user@${module.compute.public_ip}"
}

output "order_events_queue_url" {
  value = module.queue.order_events_queue_url
}

output "order_events_queue_name" {
  value = module.queue.order_events_queue_name
}

output "dead_letter_queue_url" {
  value = module.queue.dead_letter_queue_url
}
