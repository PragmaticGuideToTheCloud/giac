include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "git::ssh://git@github.com/PragmaticGuideToTheCloud/gcp-cloud-boilerplate.git//terraform/vpc"
}

inputs = {
  vpc_name = "dev"
  bastion_public_key_filename = "~/.ssh/iac_example_id_rsa.pub"
}
