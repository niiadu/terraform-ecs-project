# SNS Topics for Notifications
resource "aws_sns_topic" "slack_notifications" {
  name         = "ecs-slack-notifications"
  display_name = "${var.account_name}-ecs-slack-notifications"
}

# EventBridge Rule for ECS Task State Changes
resource "aws_cloudwatch_event_rule" "ecs_task_state_change" {
  name        = "ecs-task-state-change"
  description = "Capture ECS task state changes"
  event_pattern = jsonencode({
    "source" : ["aws.ecs"],
    "detail-type" : ["ECS Task State Change"],
    "detail" : {
      "lastStatus" : ["RUNNING", "STOPPED", "PENDING"]
    }
  })
}

resource "aws_cloudwatch_event_target" "ecs_task_state_change_target" {
  rule      = aws_cloudwatch_event_rule.ecs_task_state_change.name
  target_id = "send-to-sns"
  arn       = aws_sns_topic.slack_notifications.arn
}

# EventBridge Rule for ECS Deployment State Changes
resource "aws_cloudwatch_event_rule" "ecs_deployment_state_change" {
  name        = "ecs-deployment-state-change"
  description = "Capture ECS deployment state changes"
  event_pattern = jsonencode({
    "source" : ["aws.ecs"],
    "detail-type" : ["ECS Deployment State Change"],
    "detail" : {
      "eventName" : ["SERVICE_DEPLOYMENT_SUCCEEDED", "SERVICE_DEPLOYMENT_FAILED"]
    }
  })
}

resource "aws_cloudwatch_event_target" "ecs_deployment_state_change_target" {
  rule      = aws_cloudwatch_event_rule.ecs_deployment_state_change.name
  target_id = "send-to-sns"
  arn       = aws_sns_topic.slack_notifications.arn
}

# Permission for CloudWatch Events to Publish to SNS Topic
resource "aws_sns_topic_policy" "sns_topic_policy" {
  arn = aws_sns_topic.slack_notifications.arn
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid : "Allow_CloudWatch_Events",
        Effect : "Allow",
        Principal : {
          Service : "events.amazonaws.com"
        },
        Action : ["sns:Publish"],
        Resource : aws_sns_topic.slack_notifications.arn
      }
    ]
  })
}

# IAM Role for AWS Chatbot
resource "aws_iam_role" "chatbot" {
  name = "ecs_slack_chatbot_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "chatbot.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "chatbot_policy" {
  name = "ecs_slack_chatbot_policy"
  role = aws_iam_role.chatbot.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "cloudwatch:Describe*",
          "cloudwatch:Get*",
          "cloudwatch:List*"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

module "chatbot_slack_configuration" {
  source  = "waveaccounting/chatbot-slack-configuration/aws"
  version = "1.1.0"

  configuration_name = "ecs"
  iam_role_arn       = aws_iam_role.chatbot.arn
  logging_level      = "INFO"
  slack_channel_id   = "T06DSNN1GNR"
  slack_workspace_id = "C06DY4WNKPE"

  sns_topic_arns = [
    aws_sns_topic.slack_notifications.arn,
  ]
}
