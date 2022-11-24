#!/usr/bin/env bash

source .env

: ${DB_BACKUP_SRCDIR:=/home/ubuntu/db-backups}
: ${DB_BACKUP_DSTDIR:=.}
: ${DB_HOST:=example.net}
: ${DB_USER:=john}
: ${DB_PASSWORD:=password123}
: ${DB_NAME:=db}
: ${BASTION_HOST:=1.2.3.4}
: ${BASTION_SSH_PRIVATE_KEY:=~/.ssh/id_rsa}
: ${FILENAME_CURRENT:=current}
: ${FILENAME_PREV:=prev}

set -o errexit -o nounset -o pipefail
set -x

# pre-checks (osx: for realpath use: brew install coreutils)
which realpath xargs dirname date ssh scp

SELF=$(realpath "$0" | xargs dirname) && cd ${SELF}/

TIMESTAMP=$(date +%Y%m%d%H%M%S)
FILENAME_PREV="${FILENAME_PREV}_${TIMESTAMP}"

ssh -i ${BASTION_SSH_PRIVATE_KEY} ${BASTION_USER}@${BASTION_HOST} sudo -u ubuntu bash -s <<EOF
set -x
mv ${DB_BACKUP_SRCDIR}/${FILENAME_CURRENT}.sql.gz ${DB_BACKUP_SRCDIR}/${FILENAME_PREV}.sql.gz
mysqldump -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} ${DB_NAME} > ${DB_BACKUP_SRCDIR}/${FILENAME_CURRENT}.sql
gzip ${DB_BACKUP_SRCDIR}/${FILENAME_CURRENT}.sql
EOF

if [ -f "${SELF}/${DB_BACKUP_DSTDIR}/${FILENAME_CURRENT}.sql" ]; then
    mv ${SELF}/${DB_BACKUP_DSTDIR}/${FILENAME_CURRENT}.sql ${SELF}/${DB_BACKUP_DSTDIR}/${FILENAME_PREV}.sql
fi

scp -i ${BASTION_SSH_PRIVATE_KEY} ${BASTION_USER}@${BASTION_HOST}:${DB_BACKUP_SRCDIR}/${FILENAME_CURRENT}.sql.gz ${SELF}/${DB_BACKUP_DSTDIR}/

gzip -d ${SELF}/${DB_BACKUP_DSTDIR}/${FILENAME_CURRENT}.sql.gz

# vim:ts=4:sw=4:et:syn=sh:
