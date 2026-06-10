output "app_public_ip" {
  value = module.compute.public_ip
}

output "app_ssh_command" {
  value = "ssh ec2-user@${module.compute.public_ip}"
}

output "catalog_url" {
  value = "http://${module.compute.public_ip}:8081/products"
}

output "order_url" {
  value = "http://${module.compute.public_ip}:8082/orders"
}

output "order_created_queue_url" {
  value = module.queue.order_created_queue_url
}
