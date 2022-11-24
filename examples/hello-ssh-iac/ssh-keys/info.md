# GENERATE

    ssh-keygen -t rsa -b 4096 -C "iac_example@example.com"

# CONFIG

    host bastion.hello-ssh
      hostname 1.2.3.4
      user ubuntu
      stricthostkeychecking no
      IdentityFile ~/.ssh/iac_example_id_rsa

# CONNECT

    ssh -i ~/.ssh/iac_example_id_rsa ubuntu@1.2.3.4
