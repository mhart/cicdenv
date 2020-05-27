output "ecr" {
  value = {
    jenkins_server = {
      id             = aws_ecr_repository.jenkins_server.id
      name           = aws_ecr_repository.jenkins_server.name
      arn            = aws_ecr_repository.jenkins_server.arn
      registry_id    = aws_ecr_repository.jenkins_server.registry_id
      repository_url = aws_ecr_repository.jenkins_server.repository_url
      latest         = var.jenkins_server_default_tag
    }
    jenkins_agent = {
      id             = aws_ecr_repository.jenkins_agent.id
      name           = aws_ecr_repository.jenkins_agent.name
      arn            = aws_ecr_repository.jenkins_agent.arn
      registry_id    = aws_ecr_repository.jenkins_agent.registry_id
      repository_url = aws_ecr_repository.jenkins_agent.repository_url
      latest         = var.jenkins_agent_default_tag
    }
    ci_builds = {
      id             = aws_ecr_repository.ci_builds.id
      name           = aws_ecr_repository.ci_builds.name
      arn            = aws_ecr_repository.ci_builds.arn
      registry_id    = aws_ecr_repository.ci_builds.registry_id
      repository_url = aws_ecr_repository.ci_builds.repository_url
    }
  }
}
