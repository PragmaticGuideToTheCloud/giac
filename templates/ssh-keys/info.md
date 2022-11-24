# GENERATE

    ssh-keygen -t rsa -b 4096 -C "iac_example@example.com"

# CONFIG

    host bastion.<<< name >>>
      hostname <<< bastionHost >>>
      user ubuntu
      stricthostkeychecking no
      IdentityFile <<< provider.gcp.vpc.bastion_private_key_filename | default("~/.ssh/id_rsa") >>>

# CONNECT

    ssh -i <<< provider.gcp.vpc.bastion_private_key_filename | default("~/.ssh/id_rsa") >>> ubuntu@<<< bastionHost >>>
