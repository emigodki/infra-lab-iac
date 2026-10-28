variable "nombre_contenedor" {
  description = "Nombre del contenedor del servidor"
  type        = string
  default     = "servidor-lab"
}

variable "imagen" {
  description = "Imagen Docker del servidor"
  type        = string
  default     = "nginx:alpine"
}

variable "puerto_externo" {
  description = "Puerto del equipo anfitrión que apunta al puerto 80 del contenedor"
  type        = number
  default     = 8082
}
