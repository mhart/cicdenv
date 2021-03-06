locals {
  site_hosted_zone    = data.terraform_remote_state.domains.outputs.main_public_zone
  account_hosted_zone = data.terraform_remote_state.domains.outputs.account_public_zone

  host_name = "jenkins-server-${var.jenkins_instance}-${terraform.workspace}"
  
  jenkins_server_image = data.terraform_remote_state.ecr_jenkins.outputs.ecr.jenkins_server
  jenkins_agent_image  = data.terraform_remote_state.ecr_jenkins.outputs.ecr.jenkins_agent

  persistent_config_efs = data.terraform_remote_state.jenkins_shared.outputs.persistent_config_efs
  
  jenkins_env_secrets    = data.terraform_remote_state.jenkins_backend.outputs.secrets.env
  jenkins_server_secrets = data.terraform_remote_state.jenkins_backend.outputs.secrets.server
  jenkins_agent_secrets  = data.terraform_remote_state.jenkins_backend.outputs.secrets.agent
  jenkins_github_secrets = data.terraform_remote_state.jenkins_backend.outputs.secrets.github.ec2

  server_url  = "https://jenkins-${var.jenkins_instance}.${local.account_hosted_zone.domain}"
  content_url = "https://builds-${var.jenkins_instance}.${local.account_hosted_zone.domain}"

  github_oauth_redirect_uri = "https://jenkins.${local.site_hosted_zone.domain}/securityRealm/finishLogin/${terraform.workspace}/${var.jenkins_instance}"

  main_account = data.terraform_remote_state.accounts.outputs.main_account
}
