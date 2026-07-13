output "endpoint" {
  value = aws_db_instance.this.address
}

output "database_name" {
  value = aws_db_instance.this.db_name
}

output "security_group_id" {
  value = aws_security_group.db.id
}
