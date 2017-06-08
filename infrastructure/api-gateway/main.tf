resource "aws_api_gateway_rest_api" "rest_api" {
  name = "HelloApi"
  description = "Demonstration of Terraform + API Gateway"
}

# Resource /hello
resource "aws_api_gateway_resource" "hello_index" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  parent_id = "${aws_api_gateway_rest_api.rest_api.root_resource_id}"
  path_part = "hello"
}

# Resource /hello/{id}
resource "aws_api_gateway_resource" "hello_id" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  parent_id = "${aws_api_gateway_resource.hello_index.id}"
  path_part = "{id}"
}

# ===============================================
# Endpoints
# ===============================================

module "create-hello" {
  source = "./api-method"

  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  api_resource_id = "${aws_api_gateway_resource.hello_index.id}"
  api_resource_path = "${aws_api_gateway_resource.hello_index.path}"
  api_method = "POST"
  lambda_name = "hello-api-demo-dev-create-hello"
  stage = "dev"
}

module "index-hello" {
  source = "./api-method"

  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  api_resource_id = "${aws_api_gateway_resource.hello_index.id}"
  api_resource_path = "${aws_api_gateway_resource.hello_index.path}"
  api_method = "GET"
  lambda_name = "hello-api-demo-dev-index-hello"
  stage = "dev"
}

module "show-hello" {
  source = "./api-method"

  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  api_resource_id = "${aws_api_gateway_resource.hello_id.id}"
  api_resource_path = "${aws_api_gateway_resource.hello_id.path}"
  api_method = "GET"
  lambda_name = "hello-api-demo-dev-show-hello"
  stage = "dev"
}

module "update-hello" {
  source = "./api-method"

  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  api_resource_id = "${aws_api_gateway_resource.hello_id.id}"
  api_resource_path = "${aws_api_gateway_resource.hello_id.path}"
  api_method = "PATCH"
  lambda_name = "hello-api-demo-dev-update-hello"
  stage = "dev"
}
