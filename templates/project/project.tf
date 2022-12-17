module "prj" {
  source = "git::ssh://git@github.com/PragmaticGuideToTheCloud/gcp-cloud-boilerplate.git//terraform/product-env-project"

  org_id           = "<<< provider.gcp.org_id >>>"
  billing_account  = "<<< provider.gcp.billing_account >>>"
  project_name     = "<<< name >>>-prod"
  parent_folder_id = "<<< provider.gcp.parent_folder_id >>>"
}

output "prj" {
  value = module.prj
}
