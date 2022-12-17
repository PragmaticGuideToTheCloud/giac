module "prj" {
  source = "git::ssh://git@github.com/PragmaticGuideToTheCloud/gcp-cloud-boilerplate.git//terraform/product-env-project"

  org_id           = "111111111111"
  billing_account  = "111111-111111-111111"
  project_name     = "postmortem-prod"
  parent_folder_id = "folders/111111111111"
}

output "prj" {
  value = module.prj
}
