include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "git::ssh://git@github.com/PragmaticGuideToTheCloud/gcp-cloud-boilerplate.git//terraform/gke-public-plane"
}

inputs = {
  vpc_name = "api-microservices-prod"
  cluster_name = "api-microservices-prod"
}
