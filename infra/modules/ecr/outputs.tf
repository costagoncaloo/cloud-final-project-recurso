output "repository_urls" {
  value = {
    for service_name, repository in aws_ecr_repository.this :
    service_name => repository.repository_url
  }
}

output "repository_names" {
  value = {
    for service_name, repository in aws_ecr_repository.this :
    service_name => repository.name
  }
}


output "repository_arns" {
  value = {
    for service_name, repository in aws_ecr_repository.this :
    service_name => repository.arn
  }
}
