terraform {
  backend "s3" {
    bucket         = "alb-test-tfstate"
    key            = "alb-webserver/alb.tfstate"
    region         = "us-east-1"
    dynamodb_table = "TerraformLocks"
    encrypt        = "true"
  }
}
