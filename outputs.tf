output "nombre_contenedor" {
  description = "Nombre del contenedor creado"
  value       = docker_container.servidor_lab.name
}

output "url_servidor" {
  description = "URL para acceder al servidor"
  value       = "http://localhost:${var.puerto_externo}"
}
