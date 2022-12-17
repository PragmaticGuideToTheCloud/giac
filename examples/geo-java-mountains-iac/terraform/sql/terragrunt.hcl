include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "git::ssh://git@github.com/PragmaticGuideToTheCloud/gcp-cloud-boilerplate.git//terraform/sql"
}

inputs = {
  vpc_name = "geo-java-mountains-prod"
  env_name = "geo-java-mountains-prod"

  database_name = "apidb"
  database_user = "apiuser"
  database_password = "SecretPassword123!"
}
