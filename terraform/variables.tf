variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cloudtrail_name" {
  description = "Name of CloudTrail trail"
  type        = string
  default     = "ThreatDetectionTrail"
}

variable "sns_topic_name" {
  description = "SNS topic for alerts"
  type        = string
  default     = "ThreatAlerts"
}

variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
  default     = "ThreatDetectorLambda"
}

variable "lambda_handler" {
  description = "Lambda function handler"
  type        = string
  default     = "threat_detector.lambda_handler"
}

variable "lambda_runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.11"
}
