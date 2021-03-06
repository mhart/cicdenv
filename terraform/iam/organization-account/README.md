## Purpose
Terraform has only limited support for creating sub-account iam items initially.

This component can be used to import / manage those resources post creation.

## Workspaces
This state is per-account.

## Setup
```bash
cicdenv$ cicdctl terraform init iam/organization-account:${WORKSPACE}
cicdenv$ terraform/iam/organization-account/bin/import-resources.sh ${WORKSPACE}
cicdenv$ cicdctl terraform apply iam/organization-account:${WORKSPACE}
```

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> iam/organization-account:${WORKSPACE}
...
```

## Importing
N/A.

## Outputs
```hcl
console_url = https://<account-id>.signin.aws.amazon.com/console/
switch_role_url = https://signin.aws.amazon.com/switchrole?roleName=<account-name>-admin&account=<account-id>
iam = {
  "role" = {
    "arn" = "arn:aws:iam::<account-id>:role/<account-name>-admin"
    "name" = "<account-name>-admin"
  }
}
```
