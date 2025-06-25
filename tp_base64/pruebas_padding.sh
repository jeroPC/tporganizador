#!/bin/bash

echo "=== Pruebas adicionales del codificador Base64 ==="

# Crear archivo de 190 bytes (189 + 1, no divisible por 3)
echo "Probando con 190 bytes (padding con ==)..."
dd if=/dev/urandom of=inputBinario.bin bs=190 count=1 2>/dev/null
./tp_base64
if [ -f outputTexto.txt ]; then
    tail_chars=$(tail -c 3 outputTexto.txt)
    echo "Últimos 3 caracteres: '$tail_chars'"
    if [[ "$tail_chars" == *"==" ]]; then
        echo "✓ Padding doble correcto para 190 bytes"
    else
        echo "✗ Padding doble incorrecto"
    fi
fi

# Crear archivo de 191 bytes (189 + 2, no divisible por 3)  
echo "Probando con 191 bytes (padding con =)..."
dd if=/dev/urandom of=test_191.bin bs=191 count=1 2>/dev/null
cp test_191.bin inputBinario.bin
./tp_base64
if [ -f outputTexto.txt ]; then
    tail_chars=$(tail -c 2 outputTexto.txt)
    echo "Últimos 2 caracteres: '$tail_chars'"
    if [[ "$tail_chars" == *"=" ]] && [[ "$tail_chars" != *"==" ]]; then
        echo "✓ Padding simple correcto para 191 bytes"
    else
        echo "✗ Padding simple incorrecto"
    fi
fi

# Restaurar archivo original
./generar_archivo_prueba.sh > /dev/null 2>&1

# Limpiar archivos de prueba
rm -f test_191.bin

echo "Pruebas adicionales completadas"
