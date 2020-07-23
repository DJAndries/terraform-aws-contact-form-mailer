resource "aws_api_gateway_rest_api" "main" {
  name = "contact-form-mailer"
}

resource "aws_api_gateway_resource" "message" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id = aws_api_gateway_rest_api.main.root_resource_id
  path_part = "message"
}

resource "aws_api_gateway_method" "message" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.message.id
  http_method = "ANY"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_method" "cors" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.message.id
  http_method = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "message" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.message.id
  http_method = "ANY"
  integration_http_method = "ANY"
  type = "AWS_PROXY"
  uri = aws_lambda_function.message.invoke_arn
  depends_on = [aws_api_gateway_method.message]
}

resource "aws_api_gateway_integration" "cors" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.message.id
  http_method = "OPTIONS"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.message.invoke_arn
  depends_on = [aws_api_gateway_method.cors]
}

resource "aws_api_gateway_deployment" "main" {
  stage_name = "main"
  rest_api_id = aws_api_gateway_rest_api.main.id
  depends_on = [
    aws_api_gateway_integration.message,
    aws_api_gateway_integration.cors
  ]
}

resource "aws_api_gateway_usage_plan" "main" {
  name = "contact-form-mailer"

  api_stages {
    api_id = aws_api_gateway_rest_api.main.id
    stage = "main"
  }

  quota_settings {
    limit = var.api_monthly_quota
    offset = 0
    period = "MONTH"
  }

  throttle_settings {
    rate_limit = var.api_rate_limit
    burst_limit = var.api_burst_limit
  }

  depends_on = [aws_api_gateway_deployment.main]

}

resource "aws_api_gateway_api_key" "main" {
  name = "contact-form-mailer-main"
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id = aws_api_gateway_api_key.main.id
  key_type = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.main.id
}
