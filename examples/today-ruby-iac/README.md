# GIAC

The following procedure is for `dev1` environment in `dev` vcp.

## PART I: SETTING UP THE CLOUD

### 1. Creation of GCP project


    manual in GCP web interface

### 2. Authorization and initialization


    cd authorize/dev/dev1
    make

### 3. Creation of VPC


    cd terraform/vpc/dev
    terragrunt apply

### 4. Setting up VPN


    manual in Wireguard

### 5. Creation of GKE


    cd terraform/gke/dev/dev1
    terragrunt apply

### 6. Generation of authorization keys for GKE


    cd authorize/dev/dev1
    make kubeconfig

## PART II: APPLICATION DEPLOYMENT

### 7. Application development


    manual

### 8. Building and pushing container


    cd docker/build
    make

### 9. Verification of container


    cd docker/test
    docker-compose up -d

    http http://localhost:8080
    curl http://localhost:8080

### 10. Application deployment


    cd helm/dev/dev1
    ./deploy.sh

### 11. Verification of deployment


    http http://x.x.x.x
    curl http://x.x.x.x
