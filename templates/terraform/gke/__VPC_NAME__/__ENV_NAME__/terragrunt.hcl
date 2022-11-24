include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "<<< provider.gcp.gke.boilerplate >>>"
}

inputs = {
  vpc_name = "<<< __VPC_NAME__ >>>"
  env_name = "<<< __ENV_NAME__ >>>"
  <%- if provider.gcp.region %>
  region = "<<< provider.gcp.region >>>"
  <%- endif %>
  <%- if provider.gcp.zone %>
  zone = "<<< provider.gcp.zone >>>"
  <%- endif %>
  <%- if provider.gcp.master_ipv4_cidr_block %>
  master_ipv4_cidr_block = "<<< provider.gcp.master_ipv4_cidr_block >>>"
  <%- endif %>
  <%- if provider.gcp.cidr_block %>
  cidr_block = "<<< provider.gcp.cidr_block >>>"
  <%- endif %>
}
