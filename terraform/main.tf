terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Modules
module "cloudtrail" {
  source      = "./modules/cloudtrail"
  trail_name  = var.cloudtrail_name
  s3_bucket   = module.s3.bucket_name
}

module "sns" {
  source       = "./modules/sns"
  topic_name   = var.sns_topic_name
}

module "lambda" {
  source           = "./modules/lambda"
  function_name    = var.lambda_function_name
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  sns_topic_arn    = module.sns.topic_arn
  lambda_role_arn  = module.lambda.lambda_role_arn
}

# Optional: EventBridge Rule
resource "aws_cloudwatch_event_rule" "threat_rule" {
  name        = "ThreatDetectionRule"
  description = "Trigger Lambda on suspicious CloudTrail events"
  event_pattern = jsonencode({
    "source": ["aws.cloudtrail"],
    "detail-type": ["AWS API Call via CloudTrail"],
    "detail": {
      "eventName": ["ConsoleLogin","CreateUser","AttachUserPolicy","DeleteBucket"]
    }
  })
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.threat_rule.name
  target_id = "LambdaTarget"
  arn       = module.lambda.lambda_arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.lambda_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.threat_rule.arn
}
