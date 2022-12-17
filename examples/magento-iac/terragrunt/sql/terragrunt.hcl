include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "git::ssh://git@github.com/PragmaticGuideToTheCloud/gcp-cloud-boilerplate.git//terraform/sql"
}

inputs = {
  vpc_name = "magento-prod"
  env_name = "magento-prod"

  database_version = "MYSQL_5_7"
  database_name = "bitnami_magento"
  database_user = "bn_magento"
  database_password = "zaq12wsx"
}
