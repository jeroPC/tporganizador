#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Declaración de la función de assembler para codificación
extern void codificar_base64(unsigned char* entrada, unsigned int tamaño_entrada, unsigned char* salida);

int main() {
    FILE *archivo_entrada, *archivo_salida;
    unsigned char *buffer_entrada, *buffer_salida;
    long tamaño_archivo;
    unsigned int tamaño_salida;
    
    // Abrir archivo de entrada
    archivo_entrada = fopen("inputBinario.bin", "rb");
    if (archivo_entrada == NULL) {
        printf("Error: No se pudo abrir el archivo inputBinario.bin\n");
        return 1;
    }
    
    // Obtener el tamaño del archivo
    fseek(archivo_entrada, 0, SEEK_END);
    tamaño_archivo = ftell(archivo_entrada);
    fseek(archivo_entrada, 0, SEEK_SET);
    
    printf("Tamaño del archivo de entrada: %ld bytes\n", tamaño_archivo);
    
    // Calcular el tamaño de salida
    // Cada 3 bytes de entrada generan 4 bytes de salida
    // Si no es divisible por 3, se redondea hacia arriba
    tamaño_salida = ((tamaño_archivo + 2) / 3) * 4;
    
    // Reservar memoria para entrada y salida
    buffer_entrada = (unsigned char*)malloc(tamaño_archivo);
    buffer_salida = (unsigned char*)malloc(tamaño_salida + 1); // +1 para el terminador nulo
    
    if (buffer_entrada == NULL || buffer_salida == NULL) {
        printf("Error: No se pudo reservar memoria\n");
        fclose(archivo_entrada);
        return 1;
    }
    
    // Leer el archivo completo
    size_t bytes_leidos = fread(buffer_entrada, 1, tamaño_archivo, archivo_entrada);
    fclose(archivo_entrada);
    
    if (bytes_leidos != tamaño_archivo) {
        printf("Error: No se pudo leer el archivo completo\n");
        free(buffer_entrada);
        free(buffer_salida);
        return 1;
    }
    
    // Inicializar buffer de salida
    memset(buffer_salida, 0, tamaño_salida + 1);
    
    // Llamar a la función de assembler para codificar
    codificar_base64(buffer_entrada, (unsigned int)tamaño_archivo, buffer_salida);
    
    // Agregar terminador nulo
    buffer_salida[tamaño_salida] = '\0';
    
    // Escribir el resultado al archivo de salida
    archivo_salida = fopen("outputTexto.txt", "w");
    if (archivo_salida == NULL) {
        printf("Error: No se pudo crear el archivo outputTexto.txt\n");
        free(buffer_entrada);
        free(buffer_salida);
        return 1;
    }
    
    fprintf(archivo_salida, "%s", buffer_salida);
    fclose(archivo_salida);
    
    printf("Codificación completada. Resultado guardado en outputTexto.txt\n");
    printf("Tamaño de salida: %u caracteres\n", tamaño_salida);
    
    // Liberar memoria
    free(buffer_entrada);
    free(buffer_salida);
    
    return 0;
}
