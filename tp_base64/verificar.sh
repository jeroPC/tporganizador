#!/bin/bash

echo "=== Verificación del codificador Base64 ==="

# Verificar que existe el archivo de entrada
if [ ! -f "inputBinario.bin" ]; then
    echo "Error: No existe inputBinario.bin"
    echo "Ejecuta primero: ./generar_archivo_prueba.sh"
    exit 1
fi

# Mostrar información del archivo de entrada
entrada_size=$(stat -c%s inputBinario.bin)
echo "Archivo de entrada: inputBinario.bin ($entrada_size bytes)"

# Ejecutar el codificador
echo "Ejecutando codificador..."
./tp_base64

# Verificar que se generó el archivo de salida
if [ ! -f "outputTexto.txt" ]; then
    echo "Error: No se generó outputTexto.txt"
    exit 1
fi

# Mostrar información del archivo de salida
salida_size=$(stat -c%s outputTexto.txt)
echo "Archivo de salida: outputTexto.txt ($salida_size caracteres)"

# Calcular tamaño esperado de salida
expected_size=$((($entrada_size + 2) / 3 * 4))
echo "Tamaño esperado de salida: $expected_size caracteres"

if [ $salida_size -eq $expected_size ]; then
    echo "✓ Tamaño correcto"
else
    echo "✗ Tamaño incorrecto"
fi

# Mostrar una muestra del resultado
echo ""
echo "Primeros 64 caracteres del resultado:"
head -c 64 outputTexto.txt
echo ""

# Verificar con codificador estándar (si está disponible)
if command -v base64 &> /dev/null; then
    echo ""
    echo "Verificando con base64 estándar..."
    base64 inputBinario.bin > salida_estandar.txt
    
    if cmp -s outputTexto.txt salida_estandar.txt; then
        echo "✓ El resultado coincide con base64 estándar"
    else
        echo "✗ El resultado NO coincide con base64 estándar"
        echo "Comparando primeros 64 caracteres:"
        echo "Nuestro resultado:"
        head -c 64 outputTexto.txt
        echo ""
        echo "Base64 estándar:"
        head -c 64 salida_estandar.txt
        echo ""
    fi
    
    rm -f salida_estandar.txt
fi
