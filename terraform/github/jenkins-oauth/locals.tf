locals {
  account_id = data.aws_caller_identity.current.account_id
  
  wildcard_site_cert = data.terraform_remote_state.shared_domains.outputs.wildcard_site_cert
  public_hosted_zone = data.aws_route53_zone.public_hosted_zone

  lambda_bucket = data.terraform_remote_state.lambda.outputs.lambda.bucket

  oauth_function_name = "jenkins-github-oauth-callback"
  oauth_lambda_key    = "functions/${local.oauth_function_name}.zip"
}
