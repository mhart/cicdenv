## Purpose
NAT gateways enable private subnets to access networks outside the VPC.
They are relatively expensive ~ $50 per month, per AZ, per sub-account.

Similarly VPC-endpoints cost $15 per endpoint per VPC.

Its useful to define them in a different component than the parent VPC so
they can be destroyed separately when no ec2 instances are running.

## Workspaces
This state is per-account.

## Usage
```bash
cicdenv$ cicdctl terraform <init|plan|apply|destroy> network/routing:${WORKSPACE}
...
```