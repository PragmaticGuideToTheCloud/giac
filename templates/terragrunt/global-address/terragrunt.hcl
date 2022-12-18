include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "<<< provider.gcp.global_address.boilerplate >>>"
}

inputs = {
  name = "<<< name >>>"
}
