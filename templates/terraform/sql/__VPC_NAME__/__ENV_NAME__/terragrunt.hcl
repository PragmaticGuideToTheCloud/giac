include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "git::ssh://git@github.com/PragmaticGuideToTheCloud/gcp-cloud-boilerplate.git//terraform/sql"
}

inputs = {
  vpc_name = "<<< __VPC_NAME__ >>>"
  env_name = "<<< __ENV_NAME__ >>>"
<% if db.database_version %>
  database_version = "<<< db.database_version >>>"
  <%- endif %>
  <%- if db.database_root_password %>
  database_root_password = "<<< db.database_root_password >>>"
  <%- endif %>
  <%- if db.database_name %>
  database_name = "<<< db.database_name >>>"
  <%- endif %>
  <%- if db.database_user %>
  database_user = "<<< db.database_user >>>"
  <%- endif %>
  <%- if db.database_password %>
  database_password = "<<< db.database_password >>>"
  <%- endif %>
  <%- if db.database_tier %>
  database_tier = "<<< db.database_tier >>>"
  <%- endif %>
}
