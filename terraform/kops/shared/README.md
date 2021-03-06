## Purpose
Common resources for all KOPS kubernetes clusters in the same region/account.

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy|output> kops/shared:${WORKSPACE}
...
```

## Importing
```hcl
data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/kops_shared/terraform.tfstate"
    region = var.region
  }
}
```

## Outputs
```hcl
etcd_kms_key = {
  "arn" = "arn:aws:kms:us-west-2:<account-id>:key/<guid>"
  "key_id" = "<guid>"
  "name" = "alias/kops-etcd"
}
security_groups = {
  "external_apiserver" = {
    "id" = "sg-<0x*17>"
  }
  "internal_apiserver" = {
    "id" = "sg-<0x*17>"
  }
  "master" = {
    "id" = "sg-<0x*17>"
  }
  "node" = {
    "id" = "sg-<0x*17>"
  }
}
```
