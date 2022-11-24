#!/usr/bin/env bash

source .env

: ${DB_BACKUP_SRCDIR:=/home/ubuntu/db-backups}
: ${DB_BACKUP_DSTDIR:=.}
: ${FILENAME_CURRENT:=current}
: ${FILENAME_PREV:=prev}
: ${BASTION_HOST:=1.2.3.4}
: ${BASTION_SSH_PRIVATE_KEY:=~/.ssh/id_rsa}
: ${BASTION_USER:=ubuntu}


set -o errexit -o nounset -o pipefail
set -x

# pre-checks (osx: for realpath use: brew install coreutils)
which realpath xargs dirname date ssh scp


SELF=$(realpath "$0" | xargs dirname) && cd ${SELF}/


# create db-backups directory
ssh -i ${BASTION_SSH_PRIVATE_KEY} ${BASTION_USER}@${BASTION_HOST} sudo -u ${BASTION_USER} bash -s <<EOF
set -x
mkdir -p ${DB_BACKUP_SRCDIR}
EOF


# copy gzipped sql file
gzip ${FILENAME_CURRENT}.sql
scp -i ${BASTION_SSH_PRIVATE_KEY} ${FILENAME_CURRENT}.sql.gz ${BASTION_USER}@${BASTION_HOST}:${DB_BACKUP_SRCDIR}/${FILENAME_CURRENT}.sql.gz
gzip -d ${FILENAME_CURRENT}.sql.gz


# ungzip sql file
ssh -i ${BASTION_SSH_PRIVATE_KEY} ${BASTION_USER}@${BASTION_HOST} sudo -u ${BASTION_USER} bash -s <<EOF
set -x
cd ${DB_BACKUP_SRCDIR} && rm -rf ${FILENAME_CURRENT}.sql && gzip -d ${FILENAME_CURRENT}.sql.gz
EOF

# vim:ts=4:sw=4:et:syn=sh:
