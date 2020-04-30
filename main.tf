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

data "digitalocean_kubernetes_versions" "version" {}

resource "digitalocean_kubernetes_cluster" "internal" {
  name    = "internal"
  region  = "ams3"
  version = data.digitalocean_kubernetes_versions.version.latest_version

  node_pool {
    name       = "internal-autoscale-pool"
    size       = "s-1vcpu-2gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 4
  }
}

provider "kubernetes" {
  load_config_file = false
  host             = digitalocean_kubernetes_cluster.internal.endpoint
  token            = digitalocean_kubernetes_cluster.internal.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.internal.kube_config[0].cluster_ca_certificate
  )
}