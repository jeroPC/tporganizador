#!/bin/bash

echo "Creando paquete de entrega del TP Base64..."

# Crear directorio temporal para el paquete
mkdir -p tp_base64_entrega

# Copiar archivos fuente y scripts
cp main.c tp_base64_entrega/
cp codificador.asm tp_base64_entrega/
cp compilar.sh tp_base64_entrega/
cp README.md tp_base64_entrega/
cp generar_archivo_prueba.sh tp_base64_entrega/
cp verificar.sh tp_base64_entrega/
cp pruebas_padding.sh tp_base64_entrega/

# Crear archivo de instrucciones
cat > tp_base64_entrega/INSTRUCCIONES.txt << EOF
TRABAJO PRÁCTICO BASE64 - INSTRUCCIONES DE USO


COMPILACIÓN:
1. Asegúrese de tener instalado nasm y gcc:
   sudo apt install nasm gcc

2. Ejecute el script de compilación:
   chmod +x compilar.sh
   ./compilar.sh

USO:
1. Genere un archivo de prueba (189 bytes):
   chmod +x generar_archivo_prueba.sh
   ./generar_archivo_prueba.sh

2. Ejecute el codificador:
   ./tp_base64

3. Verifique el resultado:
   chmod +x verificar.sh
   ./verificar.sh

ARCHIVOS:
- main.c: Programa principal en C
- codificador.asm: Implementación del algoritmo en Assembly
- compilar.sh: Script de compilación
- README.md: Documentación del proyecto
- generar_archivo_prueba.sh: Genera archivo de prueba de 189 bytes
- verificar.sh: Verifica que la codificación sea correcta
- pruebas_padding.sh: Pruebas adicionales de casos de padding

ESPECIFICACIONES CUMPLIDAS:
✓ Codificación Base64 de archivos binarios de tamaño arbitrario
✓ Manejo de archivos en C (apertura, lectura, escritura, cierre)
✓ Algoritmo implementado en Assembly x86_64
✓ Manejo correcto de padding (=, ==)
✓ Funciona correctamente con archivos de 189 bytes (requisito mínimo)
✓ Funciona con cualquier tamaño de archivo
EOF

# Crear archivo de prueba de 189 bytes incluido
cd tp_base64_entrega
../generar_archivo_prueba.sh > /dev/null 2>&1
cd ..

# Crear el archivo comprimido
tar -czf tp_base64_entrega.tar.gz tp_base64_entrega/

# Mostrar contenido
echo "Contenido del paquete:"
tar -tzf tp_base64_entrega.tar.gz

echo ""
echo "Paquete creado: tp_base64_entrega.tar.gz"
echo "Tamaño: $(ls -lh tp_base64_entrega.tar.gz | awk '{print $5}')"

# Limpiar directorio temporal
rm -rf tp_base64_entrega

echo "¡Paquete listo para entregar!"
