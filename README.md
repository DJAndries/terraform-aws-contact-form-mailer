# Contact form mailer Terraform module - AWS

Sets up a serverless contact form handler, which will turn POST requests into forwarded emails.

Uses APIGW, Lambda, SES.

## Features

- Handles JSON POST request, forwards to preconfigured email.
- Some validation
  - Configurable required and optional fields
  - Maximum length
  - Email
- Configurable CORS, ability to set multiple allowed origins
- API Gateway usage plan configured to keep costs low; customizable

## Usage

### Basic usage with development and production origin restrictions:

In this example, all mail is sent to `sales@awesomelitbusiness.biz` from `no-reply@awesomelitbusiness.biz`. The required fields in the body are name, message and email, and the optional fields are company and phone.

```
module "contact_mailer" {
  source = "DJAndries/contact-form-mailer/aws"

  sender_email = "no-reply@awesomelitbusiness.biz"
  recipient_email = "sales@awesomelitbusiness.biz"

  allowed_origin = "http://localhost:8000,https://awesomelitbusiness.biz"
}
```

### Custom fields

```
module "contact_mailer" {
  source = "DJAndries/contact-form-mailer/aws"

  sender_email = "no-reply@awesomelitbusiness.biz"
  recipient_email = "sales@awesomelitbusiness.biz"

  allowed_origin = "http://localhost:8000,https://awesomelitbusiness.biz"

  required_params = "name,email,message,how_did_you_find_us"
  optional_params = "company,cell_phone,work_phone"
}
```

## Requirements/Providers

- Terraform 0.12.x
- AWS provider 2.x
- archive and null provider

## Inputs

|Name|Description|Default|Required|
|--|--|--|--|
|recipient_email|Receiving email address for forwarded messages|None|Yes|
|sender_email|'From' email to use when forwarding a message|Recipient email|No|
|subject|Email subject of forwarded messages|"Message from your friendly mailer!|No|
|required_params|Comma-separated list of required fields in message request; no whitespace, must include message and email at a minimum|name,email,message|No|
|optional_params|Comma-separated list of optional fields in message request; no whitespace|company,phone|No|
|max_other_param_length|Maximum length for any field that is not the message field|512|No|
|max_message_length|Maximum length for the message field|50000|No|
|allowed_origin|Comma-separated list of allowed origin(s) for message requests|*|No|
|api_rate_limit|API Gateway message request rate limit; see API Gateway usage plan for details|10|No|
|api_burst_limit|API Gateway message request burst limit; see API Gateway usage plan for details|10|No|
|api_monthly_quota|API Gateway message request monthly quota|30000|No|


## Outputs

|Name|Description|
|--|--|
|message_post_url|URL to use for JSON POST requests.|
|api_key|API Gateway key (provided so usage plan works), supply in x-api-key header when making request|
