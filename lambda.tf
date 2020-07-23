resource "aws_iam_role" "iam_for_lambda" {
  name = "contact-form-mailer-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "send" {
  name = "SES_Send_Email"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": "ses:SendEmail",
      "Resource": "*"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "basic_exec" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "send" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.send.arn
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "contact-form-mailer"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.main.execution_arn}/*/*/*"
}

resource "null_resource" "npm" {
  provisioner "local-exec" {
    command = "cd ${path.module}/lambda_src && npm install"
  }
}

data "archive_file" "lambda_payload" {
  type = "zip"
  source_dir = "${path.module}/lambda_src"
  output_path = "${path.module}/files/lambda.zip"
  depends_on = [null_resource.npm]
}

resource "aws_lambda_function" "message" {
  filename      = "${path.module}/files/lambda.zip"
  function_name = "contact-form-mailer"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.lambda_payload.output_base64sha256

  runtime = "nodejs12.x"

  environment {
    variables = {
      SENDER = var.sender_email
      RECIPIENT = var.recipient_email
      SUBJECT = var.subject
      REQUIRED_PARAMS = var.required_params
      OPTIONAL_PARAMS = var.optional_params
      MAX_OTHER_PARAM_LENGTH = var.max_other_param_length
      MAX_MESSAGE_LENGTH = var.max_message_length
      ALLOWED_ORIGIN = var.allowed_origin
    }
  }
}

resource "aws_cloudwatch_log_group" "main" {
  name = "/aws/lambda/contact-form-mailer"
  retention_in_days = 30 
}
