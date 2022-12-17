include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "git::ssh://git@github.com/PragmaticGuideToTheCloud/gcp-cloud-boilerplate.git//terraform/sql"
}

inputs = {
  vpc_name = "memorize-it-prod"
  env_name = "memorize-it-prod"

  database_version = "MYSQL_5_7"
  database_name = "memorize_it_net"
  database_user = "memory_admin"
  database_password = "memoryPWD345"
}
