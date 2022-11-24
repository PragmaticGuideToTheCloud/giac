[self:vars]
git_url=<<< ansibleBoilerplateUrl >>>
git_branch=main

[self]
localhost ansible_connection=local

[targets:vars]
ansible_user=ubuntu

PREFIX=/etc/wireguard
PEER_SUBNET=10.254.10.0/24
PEER_ROUTES=${PEER_ROUTES}
PEER_DNS=8.8.8.8
WIREGUARD_IF=wg0
SERVER_PORT=1691

${WIREGUARD_PEERS}

[targets]
${TARGET}
