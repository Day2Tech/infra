terraform {
  backend "s3" {
    # get access / secret key from https://cloud.digitalocean.com/account/api/tokens?i=2401c9
    # export AWS_ACCESS_KEY_ID=...
    # export AWS_SECRET_ACCESS_KEY=...
    endpoint                    = "ams3.digitaloceanspaces.com"
    key                         = "terraform.tfstate"
    bucket                      = "day2-terraform"
    region                      = "us-west-1"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}

provider "digitalocean" {
  # export DIGITALOCEAN_TOKEN="API TOKEN"
}

provider "kustomization" {
  kubeconfig_raw = digitalocean_kubernetes_cluster.internal.kube_config[0].raw_config
}