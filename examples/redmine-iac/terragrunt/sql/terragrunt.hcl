include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "git::ssh://git@github.com/PragmaticGuideToTheCloud/gcp-cloud-boilerplate.git//terraform/sql"
}

inputs = {
  vpc_name = "redmine-prod"
  env_name = "redmine-prod"

  database_version = "MYSQL_5_7"
  database_name = "redmine"
  database_user = "redmine"
  database_password = "redmine"
}
