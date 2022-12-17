include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "<<< provider.gcp.vpc.boilerplate >>>"
}

inputs = {
  vpc_name = "<<< name >>>-<<< env | default ("prod") >>>"
  <%- if provider.gcp.region %>
  region = "<<< provider.gcp.region >>>"
  <%- endif %>
  <%- if provider.gcp.zone %>
  zone = "<<< provider.gcp.zone >>>"
  <%- endif %>
  <%- if provider.gcp.peer_routes %>
  peer_routes = "<<< provider.gcp.peer_routes >>>"
  <%- endif %>
  <%- if provider.gcp.vpc.bastion_public_key_filename %>
  bastion_public_key_filename = "<<< provider.gcp.vpc.bastion_public_key_filename >>>"
  <%- endif %>
}
