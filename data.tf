variable "sender_email" {
  type = string
  default = "" 
  description = "'From' email to use when forwarding a message, defaults to recipient email in the Lambda"
}

variable "recipient_email" {
  type = string
  description = "Receiving email address for forwarded messages"
}

variable "subject" {
  type = string
  default = ""
  description = "Email subject of forwarded messages"
}

variable "required_params" {
  type = string
  default = ""
  description = "Comma-separated list of required fields in message request; no whitespace, must include message and email"
}

variable "optional_params" {
  type = string
  default = ""
  description = "Comma-separated list of optional fields in message request"
}

variable "max_other_param_length" {
  default = ""
  description = "Maximum length for any field that is not the message field"
}

variable "max_message_length" {
  default = ""
  description = "Maximum length for the message field"
}

variable "allowed_origin" {
  type = string
  default = ""
  description = "Allowed origin(s) for message requests"
}

variable "api_rate_limit" {
  type = number
  default = 10
  description = "Message request rate limit"
}

variable "api_burst_limit" {
  type = number
  default = 10
  description = "Message request burst limit"
}

variable "api_monthly_quota" {
  type = number
  default = 30000
  description = "Message request monthly quota"
}

output "message_post_url" {
  value = "${aws_api_gateway_deployment.main.invoke_url}/message"
  description = "POST URL for message requests"
}

output "api_key" {
  value = aws_api_gateway_api_key.main.value
  description = "API key to use in message request, must specify in x-api-key header"
}
