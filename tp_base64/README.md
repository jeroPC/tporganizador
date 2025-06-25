# Trabajo Práctico Base64 - Organización del Computador

## Descripción
Este proyecto implementa un codificador Base64 en C y Assembly x86_64 según las especificaciones del trabajo práctico integrador.

## Estructura del proyecto
- `main.c`: Programa principal en C que maneja archivos
- `codificador.asm`: Implementación del algoritmo Base64 en Assembly
- `compilar.sh`: Script de compilación
- `generar_archivo_prueba.sh`: Genera archivo de prueba de 189 bytes
- `verificar.sh`: Verifica el funcionamiento del codificador

## Compilación
```bash
chmod +x compilar.sh
./compilar.sh
```

## Uso
1. Crear archivo de prueba:
```bash
chmod +x generar_archivo_prueba.sh
./generar_archivo_prueba.sh
```

2. Ejecutar codificador:
```bash
./tp_base64
```

3. Verificar resultado:
```bash
chmod +x verificar.sh
./verificar.sh
```

## Archivos
- **Entrada**: `inputBinario.bin` (archivo binario a codificar)
- **Salida**: `outputTexto.txt` (resultado codificado en Base64)

## Especificaciones cumplidas
- ✓ Codificación de archivos binarios de tamaño arbitrario
- ✓ Manejo de archivos en C
- ✓ Algoritmo de codificación implementado en Assembly x86_64
- ✓ Manejo correcto de padding (caracteres '=' al final)
- ✓ Funciona con archivos de 189 bytes (requisito mínimo)

## Integrantes
-julian malnero superno 
-jeronimo perez cordoba

## Algoritmo Base64
El algoritmo convierte grupos de 3 bytes (24 bits) en 4 caracteres imprimibles (6 bits cada uno):
1. Agrupa 3 bytes en 24 bits
2. Divide en 4 grupos de 6 bits
3. Usa cada grupo como índice en tabla de conversión
4. Aplica padding con '=' si es necesario


# 1. Compilar
./compilar.sh

# 2. Generar archivo de prueba
./generar_archivo_prueba.sh

# 3. Ejecutar codificador
./tp_base64

# 4. Verificar resultado
./verificar.sh


