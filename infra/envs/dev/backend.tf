terraform {
  backend "s3" {
    bucket         = "cloud-ecommerce-tf-state-337058962986-eu-west-1"
    key            = "envs/dev/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "cloud-ecommerce-tf-locks"
    encrypt        = true
  }
}