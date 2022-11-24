include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "git::ssh://git@github.com/PragmaticGuideToTheCloud/gcp-cloud-boilerplate.git//terraform/sql"
}

inputs = {
  vpc_name = "dev"
  env_name = "dev1"

  database_name = "apidb"
  database_user = "apiuser"
  database_password = "SecretPassword123!"
}
