locals {
  account_hosted_zone = data.terraform_remote_state.domains.outputs.account_public_zone

  host_name = "jenkins-agent-${var.jenkins_instance}-${terraform.workspace}"
  
  jenkins_agent_image = data.terraform_remote_state.ecr_jenkins.outputs.jenkins_agent_image_repo
  
  jenkins_env_secrets = data.terraform_remote_state.jenkins_backend.outputs.jenkins_env_secrets
  jenkisn_agent_secrets = data.terraform_remote_state.jenkins_backend.outputs.jenkins_agent_secrets
}
