# backend.tf
terraform {
  backend "s3" {
    bucket         = "my-tf-state-bucket"
    key            = "network/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}