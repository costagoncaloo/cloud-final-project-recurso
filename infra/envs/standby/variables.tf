variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "project" {
  type    = string
  default = "cloud-recurso"
}

variable "environment" {
  type    = string
  default = "standby"
}

variable "owner" {
  type    = string
  default = "goncalo"
}

variable "common_tags" {
  type = map(string)
  default = {
    Project     = "cloud-recurso"
    Environment = "standby"
    Owner       = "goncalo"
    ManagedBy   = "terraform"
    Role        = "disaster-recovery"
  }
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

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR allowed to SSH into the standby EC2 app host. Use your public IP with /32."
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to the SSH public key used for EC2 access."
}

variable "app_instance_type" {
  type    = string
  default = "t3.small"
}

variable "database_multi_az" {
  type    = bool
  default = false
}
