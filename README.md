# infra

Day2 Infrastructure repository


## Usage:
```
# get access / secret key from https://cloud.digitalocean.com/account/api/tokens?i=2401c9
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export DIGITALOCEAN_TOKEN=...
./get_terraform_plugins
terraform init
terraform plan
terraform apply
```

## What's installed?

### cert-manager

Cert-manager is installed and configured to provide certificates, using the CloudFlare API.

Use clusterissuers `letsencrypt-staging` or `letsencrypt-prod`

### day2-tech-nl-redirect

Redirects traffic from <https://day2.tech/>* to <https://day2.nl>

### day2meet-com-redirect

Redirects <https://day2meet.com>

### discord-day2-nl-redirect

Redirects <https://discord.day2.nl>

### external-dns

Configured to add DNS records on CloudFlare

### ingress-nginx

Configured with DO LB to serve all HTTP(S) traffic

### kube-system metrics-server

Allows for `kubectl top pod` to work

### loki-stack

Loki + Grafana stack for collecting logs

### pomerium

Pomerium allows internal applications authorization and authentication through Google OAuth
