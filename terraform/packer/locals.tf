locals {
  allowed_account_roots = data.terraform_remote_state.accounts.outputs.all_roots
  allowed_account_ids   = values(data.terraform_remote_state.accounts.outputs.organization_accounts)[*]["id"]

  apt_repo_policy_arn = data.terraform_remote_state.iam_common_policies.outputs.apt_repo_policy_arn
}
