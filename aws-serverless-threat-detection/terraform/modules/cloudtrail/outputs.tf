output "trail_name" {
  value = aws_cloudtrail.this.name
}

output "bucket_name" {
  value = aws_s3_bucket.cloudtrail_bucket.id
}
