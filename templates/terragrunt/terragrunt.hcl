locals {
  gcp_project_id = "<<< provider.gcp.project_id >>>"
  bucket_suffix = "<<< provider.gcp.bucket_suffix | default ("tfstate") >>>"
}

inputs = {
  project = "${local.gcp_project_id}"
  state_bucket_suffix = "${local.bucket_suffix}"
}

remote_state {
  backend = "gcs"
  config = {
    project = "${local.gcp_project_id}"
    bucket  = "${local.gcp_project_id}-${local.bucket_suffix}"
    prefix  = "${path_relative_to_include()}"
  }
}
