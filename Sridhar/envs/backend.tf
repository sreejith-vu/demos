terraform {
  backend "s3" {
    bucket         = "terraform-tfstate-files-65465"
    key            = "poc/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock-dynamo"
  }
}