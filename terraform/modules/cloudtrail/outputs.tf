output "cloudtrail_name" {
  value = module.cloudtrail.trail_name
}

output "sns_topic_arn" {
  value = module.sns.topic_arn
}

output "lambda_arn" {
  value = module.lambda.lambda_arn
}
