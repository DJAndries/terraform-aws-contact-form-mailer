resource "aws_ses_email_identity" "recipient" {
  email = var.recipient_email
}

resource "aws_ses_email_identity" "sender" {
  count = var.sender_email != "" ? 1 : 0
  email = var.sender_email
}
