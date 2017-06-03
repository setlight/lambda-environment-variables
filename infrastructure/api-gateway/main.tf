resource "aws_api_gateway_rest_api" "rest_api" {
  name = "HelloApi"
  description = "This is an API to proof the concept of creating API gateway with Terraform"
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  parent_id = "${aws_api_gateway_rest_api.rest_api.root_resource_id}"
  path_part = "${var.path}"
}

resource "aws_api_gateway_method" "api_method" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  resource_id = "${aws_api_gateway_resource.api_resource.id}"
  http_method = "${var.method}"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  resource_id = "${aws_api_gateway_resource.api_resource.id}"
  http_method = "${aws_api_gateway_method.api_method.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  stage_name = "${var.stage}"

  depends_on = [
    "aws_api_gateway_method.api_method",
    "aws_api_gateway_integration.api_integration"
  ]
}

resource "aws_lambda_permission" "allow_api_gateway" {
  function_name = "hello-dev-hello"
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:745715572008:${aws_api_gateway_rest_api.rest_api.id}/*/${aws_api_gateway_method.api_method.http_method}${aws_api_gateway_resource.api_resource.path}"
}
