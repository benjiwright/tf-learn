resource "aws_sns_topic" "stripe_feed_sns" {
  name = "stripe-feed-topic"
}

resource "aws_sqs_queue" "stripe_feed_queue" {
  name                       = "stripe-feed-queue"
  redrive_policy             = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.stripe_feed_dl_queue.arn}\",\"maxReceiveCount\":5}"
  visibility_timeout_seconds = 300

  tags = {
    Environment = "dev"
  }
}

resource "aws_sqs_queue" "stripe_feed_dl_queue" {
  name = "stripe-feed-dl-queue"
}

resource "aws_sns_topic_subscription" "stripe_feed_sqs_target" {
  topic_arn = aws_sns_topic.stripe_feed_sns.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.stripe_feed_queue.arn
}

resource "aws_sqs_queue_policy" "stripe_feed_queue_policy" {
  queue_url = aws_sqs_queue.stripe_feed_queue.id

  # FIXME: figure out how to use data block and limit priveledges
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.stripe_feed_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.stripe_feed_sns.arn}"
        }
      }
    }
  ]
}
POLICY
}
