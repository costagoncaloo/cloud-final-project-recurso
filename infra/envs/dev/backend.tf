terraform {
  backend "s3" {
    bucket         = "cloud-recurso-tf-state-806758135628-euw1-v2"
    key            = "envs/dev/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "cloud-recurso-tf-locks"
    encrypt        = true
  }
}