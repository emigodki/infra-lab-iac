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
