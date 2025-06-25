# Compilación del proyecto Base64

# Compilar el archivo de assembler
nasm -f elf64 codificador.asm -o codificador.o

# Compilar el archivo de C y enlazar con el objeto de assembler
gcc -no-pie -o tp_base64 main.c codificador.o

# Limpiar archivos objeto
rm codificador.o

echo "Compilación completada. Ejecutable: tp_base64"
