#!/bin/bash
set -eu -o pipefail

username=${1?Usage: $0 <username>}
username=$(echo "$username" | sed -e 's/^# //' -e 's/+/plus/' -e 's/=/equal/' -e 's/,/comma/' -e 's/@/at/' )

(
mkdir -p "/home/${username}/.aws"
cp "/root/.aws/credentials" "/home/${username}/.aws/credentials"

sshkey_id=$(
    aws iam list-ssh-public-keys \
        --user-name "$username" \
        --query "SSHPublicKeys[?Status == 'Active'].[SSHPublicKeyId]" \
        --output text
)
ssh_key=$(
    aws iam get-ssh-public-key \
    --user-name "$username" \
    --ssh-public-key-id "$sshkey_id" \
    --encoding SSH \
    --query "SSHPublicKey.SSHPublicKeyBody" \
    --output text
)

echo "$username ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${username}"
chmod 0440 "/etc/sudoers.d/${username}"

_uid=$(iam "${username}" | sed 's/.*(\([0-9]\+\))/\1/' | head -n1)
if ! grep "${username}" /etc/passwd &>/dev/null; then
    echo "${username}:x:${_uid}:${_uid}:${username}:/home/${username}:/bin/bash" >> /etc/passwd
fi
if ! grep "${username}" /etc/group &>/dev/null; then
    echo "${username}:x:${_uid}:${username}" >> /etc/group
fi

mkdir -p "/home/${username}/.ssh"
if ! grep "$ssh_key" "/home/${username}/.ssh/authorized_keys" &>/dev/null; then
    echo "$ssh_key" >> "/home/${username}/.ssh/authorized_keys"
fi

cat <<'EOF' > "/home/${username}/.ssh/config"
StrictHostKeyChecking no
UserKnownHostsFile=/dev/null

Host *
ServerAliveInterval 120
ServerAliveCountMax 5040
ConnectTimeout 5
EOF
chmod 0600 "/home/${username}/.ssh/config"

chown -R "${username}:${username}" "/home/${username}"
chmod 700 "/home/${username}/.ssh"
chmod 0600 "/home/${username}/.ssh/authorized_keys"

CONTAINER_ID=$(cat "/proc/self/cgroup" | grep 'name' | awk -F/ '{print $NF}')
redis-cli -s /var/run/redis/sock \
    --user sshd-worker --pass sshd-worker \
    --no-auth-warning \
    SETNX "$CONTAINER_ID" "$username"
) > >(tee -a /var/log/sshd-service-out.log) 2> >(tee -a /var/log/sshd-service-err.log >&2)

cat "/home/${username}/.ssh/authorized_keys"
