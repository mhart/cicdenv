---
apiVersion: kops/v1alpha2
kind: InstanceGroup
metadata:
  labels:
    kops.k8s.io/cluster: ${cluster_fqdn}
  name: ${name}
spec:
  image: ${ami_id}
  machineType: ${instance_type}
  maxSize: ${max_size}
  minSize: ${min_size}
  nodeLabels:
    kops.k8s.io/instancegroup: ${name}
  role: ${role}
  rootVolumeSize: ${root_volume_size}
  iam:
    profile: ${iam_profile_arn}
  additionalSecurityGroups: ${security_groups}
  additionalUserData:
${addition_user_data}
  subnets:
    - ${subnet_name}
  detailedInstanceMonitoring: true