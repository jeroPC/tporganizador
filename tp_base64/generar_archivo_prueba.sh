#!/bin/bash

# Script para generar un archivo de prueba de 189 bytes (divisible por 3)
# Este es el tamaño mínimo requerido para aprobar el TP

echo "Generando archivo de prueba inputBinario.bin de 189 bytes..."

# Crear un archivo con datos binarios de prueba
python3 -c "
import os
import random

# Generar 189 bytes aleatorios
data = bytes([random.randint(0, 255) for _ in range(189)])

with open('inputBinario.bin', 'wb') as f:
    f.write(data)

print('Archivo inputBinario.bin generado con 189 bytes')
print('Contenido (primeros 24 bytes en hex):')
with open('inputBinario.bin', 'rb') as f:
    content = f.read(24)
    print(' '.join(f'{b:02x}' for b in content))
"

# Verificar que el archivo se creó correctamente
if [ -f "inputBinario.bin" ]; then
    size=$(stat -c%s inputBinario.bin)
    echo "Archivo creado exitosamente. Tamaño: $size bytes"
else
    echo "Error al crear el archivo"
fi
