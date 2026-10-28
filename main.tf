# Infraestructura de la red de laboratorio
# Proveedor: Docker (simula servidores/servicios de la red)

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# Imagen que usará el servidor
resource "docker_image" "nginx" {
  name         = var.imagen
  keep_locally = true
}

# Servidor web del laboratorio
resource "docker_container" "servidor_lab" {
  name  = var.nombre_contenedor
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.puerto_externo
  }
}

# Segundo servidor web del laboratorio (agregado vía GitOps)
resource "docker_container" "servidor_lab_2" {
  name  = "servidor-lab-2"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = 8083
  }
}
