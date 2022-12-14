include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "git::ssh://git@github.com/PragmaticGuideToTheCloud/gcp-cloud-boilerplate.git//terraform/sql"
}

inputs = {
  vpc_name = "testlink-prod"
  env_name = "testlink-prod"

  database_version = "MYSQL_5_7"
  database_name = "testlink"
  database_user = "testlink"
  database_password = "testlink"
}
