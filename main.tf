terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
# This is set in the environment with 'export TF_VAR_DoToken=123'
variable "DoToken" {
  type = string
}
provider "digitalocean" {
  token = var.DoToken
}

resource "digitalocean_droplet" "wordpress_docker" {
  image     = "debian-10-x64"
  name      = "debian-wordpress"
  region    = "sfo3"
  ipv6      =  false
  # size      = "s-1vcpu-512mb-10gb" # This is too little memory for MySQL
  size      = "s-1vcpu-1gb"
  ssh_keys  = [1234567] # the key id can be found from the DO API
  tags      = ["name:wordpress"]
  user_data = file("userdata.sh")
}

output "wordpress_docker_host" {
  value = digitalocean_droplet.wordpress_docker[*].ipv4_address
}

# DNS A Records
resource "digitalocean_domain" "wordpress" {
  name       = "mydomain.test"
  ip_address = digitalocean_droplet.wordpress_docker.ipv4_address
}

resource "digitalocean_record" "www" {
  domain    = digitalocean_domain.wordpress.id
  type      = "A"
  name      = "www"
  value     = digitalocean_droplet.wordpress_docker.ipv4_address
}