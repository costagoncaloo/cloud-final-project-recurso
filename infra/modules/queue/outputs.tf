output "order_events_queue_url" {
  value = aws_sqs_queue.order_events.url
}

output "order_events_queue_arn" {
  value = aws_sqs_queue.order_events.arn
}

output "order_events_queue_name" {
  value = aws_sqs_queue.order_events.name
}

output "dead_letter_queue_url" {
  value = aws_sqs_queue.dead_letter.url
}

output "dead_letter_queue_arn" {
  value = aws_sqs_queue.dead_letter.arn
}