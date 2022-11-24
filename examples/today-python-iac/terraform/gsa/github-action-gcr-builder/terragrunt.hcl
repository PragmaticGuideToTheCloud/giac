include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "git::ssh://git@github.com/PragmaticGuideToTheCloud/gcp-cloud-boilerplate.git//terraform/gsa"
}

inputs = {
  gsa_name = "github-action-gcr-builder"
  gsa_display_name = "Github Action GCR Builder"
  role_id = "gcrBuilderCustomRole"
  role_title = "GCR Builder Custom Role"
  role_description = "GCR Builder Custom Role"
  role_permissions = [
    "storage.buckets.get",
    "storage.objects.create",
    "storage.objects.get",
    "storage.objects.list"
  ]
}
