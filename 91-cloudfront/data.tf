data "aws_cloudfront_cache_policy" "cachingOptimised" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_cache_policy" "cachingDisabled" {
  name = "Managed-CachingDisabled"
}

# *.prav4cloud.online
data "aws_ssm_parameter" "certificate_arn" {
  name = "/${var.project_name}/${var.environment}/frontend_alb_certificate_arn"
}