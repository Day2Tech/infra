data "digitalocean_kubernetes_versions" "version" {}

resource "digitalocean_kubernetes_cluster" "internal" {
  name    = "internal"
  region  = "ams3"
  version = data.digitalocean_kubernetes_versions.version.latest_version

  node_pool {
    name       = "internal-autoscale-pool"
    size       = "s-1vcpu-2gb"
    auto_scale = true
    min_nodes  = 3
    max_nodes  = 5
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

data "kustomization" "manifests" {
  path = "manifests/"
}

resource "kustomization_resource" "manifests" {
  for_each = data.kustomization.manifests.ids

  manifest = data.kustomization.manifests.manifests[each.value]
}
