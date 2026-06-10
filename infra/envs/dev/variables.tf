variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "project" {
  type    = string
  default = "cloud-ecommerce"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "owner" {
  type    = string
  default = "team"
}

variable "common_tags" {
  type = map(string)
  default = {
    Project     = "cloud-ecommerce"
    Environment = "dev"
    Owner       = "team"
    ManagedBy   = "terraform"
  }
}

variable "ec2_key_name" {
  type        = string
  description = "Existing EC2 key pair name used by Ansible over SSH."
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR allowed to SSH into the app EC2. Use your current public IP with /32."
}

variable "db_username" {
  type      = string
  default   = "app_user"
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "image_registry" {
  type        = string
  description = "Container registry namespace, for example ghcr.io/owner/cloud-ecommerce-project."
}
