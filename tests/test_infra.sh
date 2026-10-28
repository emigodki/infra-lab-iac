#!/usr/bin/env bash
# Prueba funcional de la infraestructura definida en Terraform.
# Verifica que los servidores existan y funcionen como se definió en el código.

fallos=0
IMAGEN_ID=$(docker image inspect -f '{{.Id}}' nginx:alpine 2>/dev/null)

# Ejecuta una verificación e imprime PASS o FAIL
verificar() {
  local descripcion="$1"; shift
  if "$@" > /dev/null 2>&1; then
    echo "PASS - $descripcion"
  else
    echo "FAIL - $descripcion"
    fallos=$((fallos + 1))
  fi
}

verificar_servidor() {
  local nombre="$1" puerto="$2"
  verificar "[$nombre] el contenedor existe" docker inspect "$nombre"
  verificar "[$nombre] está en ejecución" \
    test "$(docker inspect -f '{{.State.Running}}' "$nombre" 2>/dev/null)" = "true"
  verificar "[$nombre] usa la imagen nginx:alpine" \
    test "$(docker inspect -f '{{.Image}}' "$nombre" 2>/dev/null)" = "$IMAGEN_ID"
  verificar "[$nombre] expone el puerto $puerto hacia el 80" \
    bash -c "docker port $nombre 80/tcp | grep -q ':$puerto'"
  verificar "[$nombre] responde HTTP 200 en localhost:$puerto" \
    curl -sf -o /dev/null "http://localhost:$puerto"
}

echo "=== Pruebas funcionales de infraestructura ==="
verificar_servidor "servidor-lab" 8082
verificar_servidor "servidor-lab-2" 8083

echo "=============================================="
if [ "$fallos" -eq 0 ]; then
  echo "RESULTADO: TODAS LAS PRUEBAS PASARON"
else
  echo "RESULTADO: $fallos PRUEBA(S) FALLARON"
fi
exit "$fallos"
