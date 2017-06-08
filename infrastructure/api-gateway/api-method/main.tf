resource "aws_api_gateway_method" "api_method" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.api_resource_id}"
  http_method = "${var.api_method}"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.api_resource_id}"
  http_method = "${aws_api_gateway_method.api_method.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:us-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-2:745715572008:function:${var.lambda_name}/invocations"
}

resource "aws_lambda_permission" "api_lambda_permission" {
  function_name = "${var.lambda_name}"
  statement_id = "AllowExecutionFromApiGateway"
  action = "lambda:InvokeFunction"
  principal = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:us-west-2:745715572008:${var.rest_api_id}/*/${aws_api_gateway_method.api_method.http_method}${var.api_resource_path}"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = "${var.rest_api_id}"
  stage_name = "${var.stage}"

  depends_on = [
    "aws_api_gateway_method.api_method",
    "aws_api_gateway_integration.api_integration"
  ]
}
