# How to?

## Create project

```
terraform init
terraform apply
```

## Push state to GCS

Create backend.tf file:

```
terraform {
  backend "gcs" {
    bucket = "..."
    prefix = "terraform/prj/state"
  }
}
```

Move the state:

```
terraform init
```
