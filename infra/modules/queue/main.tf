resource "aws_sqs_queue" "dead_letter" {
  name = "${var.name_prefix}-order-events-dlq"

  message_retention_seconds = 1209600

  tags = {
    Name = "${var.name_prefix}-order-events-dlq"
  }
}

resource "aws_sqs_queue" "order_events" {
  name = "${var.name_prefix}-order-events"

  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_letter.arn
    maxReceiveCount     = 5
  })

  tags = {
    Name = "${var.name_prefix}-order-events"
  }
}