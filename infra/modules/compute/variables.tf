variable "name_prefix" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "app_security_group_id" {
  type = string
}

variable "ssh_public_key_path" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "sqs_queue_arn" {
  type = string
}

variable "ssm_parameter_arns" {
  type    = list(string)
  default = []
}
