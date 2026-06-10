variable "name_prefix" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "app_security_group_id" {
  type = string
}

variable "ec2_key_name" {
  type = string
}

variable "order_queue_arn" {
  type = string
}

variable "image_registry" {
  type = string
}

variable "database_endpoint" {
  type = string
}

variable "database_name" {
  type = string
}

variable "database_username" {
  type      = string
  sensitive = true
}

variable "database_password" {
  type      = string
  sensitive = true
}

variable "order_queue_url" {
  type = string
}

variable "aws_region" {
  type = string
}
