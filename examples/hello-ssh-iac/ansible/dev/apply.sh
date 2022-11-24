#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail
set -x

if which ${HOME}/.local/bin/ansible-playbook; then
    readonly ANSIBLE_PLAYBOOK=${HOME}/.local/bin/ansible-playbook
else
    readonly ANSIBLE_PLAYBOOK=ansible-playbook
fi

# pre-checks (osx: for realpath use: brew install coreutils)
which realpath xargs dirname ${ANSIBLE_PLAYBOOK}

SELF=$(realpath "$0" | xargs dirname)

cd ${SELF}/

${ANSIBLE_PLAYBOOK} -v \
    --inventory="${SELF}/hosts.ini" \
    sync.yml

cd ${SELF}/.cache/cloud-boilerplate/ansible/

exec \
${ANSIBLE_PLAYBOOK} \
    --inventory="${SELF}/hosts.ini" \
    --extra-vars WIREGUARD_PEER_DESTDIR="${SELF}/../../vpn/" \
    --key-file ~/.ssh/iac_example_id_rsa \
    provision-bastion.yml
