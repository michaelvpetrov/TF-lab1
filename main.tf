terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {    
}

# Network for containers
resource "docker_network" "app_network" {
  name = "app_network"
}

# App container
resource "docker_container" "app" {
  image = "hashicorp/http-echo:0.2.3"
  name  = "app"

  networks_advanced {
    name = docker_network.app_network.name
  }

  ports {
    internal = 5678   # Port inside the container
    external = 8080   # Port exposed to the host or other containers
  }
  
  command = [
    "-text", "Hello, World"
  ]
}

# NGINX container
resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.name
  name  = "nginx"  
  networks_advanced {
    name = docker_network.app_network.name
  }

  volumes {
    host_path      = "/home/michael/projects/tf/lab1.1/nginx/nginx.conf"
    container_path = "/etc/nginx/nginx.conf"
  }

  volumes {
    host_path      = "/home/michael/projects/tf/lab1.1/ssl"
    container_path = "/etc/nginx/ssl"
  }

  ports {
    internal = 443
    external = 443
  }
}

# Local DNS configuration
resource "null_resource" "update_etc_hosts" {
  provisioner "local-exec" {
    command = <<EOT
      echo "127.0.0.1 myapp.local" | sudo tee -a /etc/hosts
    EOT
  }
}

# Output the NGINX container IP
output "nginx_ip" {
  value = docker_container.nginx.network_data[0].ip_address
  description = "The IP address of the NGINX container"
}
