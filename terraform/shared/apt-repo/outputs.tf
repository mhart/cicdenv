output "apt_repo_bucket" {
  value = aws_s3_bucket.apt_repo.id
}

output "apt_repo_bucket_arn" {
  value = aws_s3_bucket.apt_repo.arn
}
