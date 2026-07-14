variable "name_prefix" {
  type = string
}

variable "github_repository" {
  type        = string
  description = "GitHub repository allowed to assume the deployment role, in OWNER/REPO format."
}

variable "ecr_repository_arns" {
  type = list(string)
}

variable "terraform_state_bucket" {
  type = string
}

variable "terraform_state_key" {
  type = string
}

variable "terraform_lock_table" {
  type = string
}
