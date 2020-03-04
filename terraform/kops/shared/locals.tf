locals {
  network_cidr = "10.16.0.0/16"

  domain = var.domain

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
    "SubnetType"             = "Utility"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "SubnetType"                      = "Private"
  }

  cluster_tags = zipmap(data.null_data_source.cluster_tags.*.outputs.Key,
                        data.null_data_source.cluster_tags.*.outputs.Value)

  # Limit AZs to no more than 3
  availability_zones = split(",", length(data.aws_availability_zones.azs.names) > 3 ? 
      join(",", slice(data.aws_availability_zones.azs.names, 0, 3)) 
    : join(",", data.aws_availability_zones.azs.names))
  
  apt_repo_policy_arn = data.terraform_remote_state.iam_common_policies.outputs.apt_repo_policy_arn

  bastion_service_ssh_port  = 22
  bastion_service_host_port = 2222
}
