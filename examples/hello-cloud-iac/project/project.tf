module "prj" {
  source = "git::ssh://git@github.com/PragmaticGuideToTheCloud/gcp-cloud-boilerplate.git//terraform/product-env-project"

  org_id           = "123456789"
  billing_account  = "a1b2c3d4e5"
  project_name     = "hello-cloud-prod"
  parent_folder_id = "folders/1111111"
}

output "prj" {
  value = module.prj
}
