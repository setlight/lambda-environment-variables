provider "aws" {
  region = "us-east-2"
}

module "api" {
  source = "./api-gateway"

  aws_region = "us-east-2"
  stage = "dev"
  path = "hello"
  method = "GET"
  lambda_arn = "arn:aws:lambda:us-east-2:745715572008:function:hello-dev-hello"
}
