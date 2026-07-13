variable "aws_region" {
  type    = string
  default = "eu-west-1"
}
variable "project" {
  type    = string
  default = "cloud-recurso"
}
variable "environment" {
  type    = string
  default = "dev"
}
variable "owner" {
  type    = string
  default = "goncalo"
}
variable "common_tags" {
  type = map(string)
  default = {
    Project     = "cloud-recurso"
    Environment = "dev"
    Owner       = "goncalo"
    ManagedBy   = "terraform"
  }
}

//modulo DB
variable "db_username" {
  type      = string
  default   = "app_user"
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

//Security group

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR allowed to SSH into the EC2 app host. Use your public Ip with /32."
}
