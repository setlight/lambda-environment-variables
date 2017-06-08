provider "aws" {
  region = "us-west-2"
}

module "api-gateway" {
  source = "./api-gateway"
}
