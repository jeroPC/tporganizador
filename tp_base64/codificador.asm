section .data
    TablaConversion db "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

section .text
    global codificar_base64

; Función: codificar_base64
; Parámetros:
;   rdi = puntero a datos de entrada
;   rsi = tamaño de datos de entrada (unsigned int)
;   rdx = puntero a buffer de salida
codificar_base64:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    
    ; Guardar parámetros
    mov r12, rdi        ; r12 = puntero entrada
    mov r13, rsi        ; r13 = tamaño entrada
    mov r14, rdx        ; r14 = puntero salida
    mov r15, 0          ; r15 = índice de salida
    
    ; Procesar grupos de 3 bytes
    xor rbx, rbx        ; rbx = índice de entrada
    
procesar_grupos:
    ; Verificar si quedan al menos 3 bytes
    mov rax, r13
    sub rax, rbx
    cmp rax, 3
    jl procesar_resto   ; Si quedan menos de 3 bytes, procesar resto
    
    ; Leer 3 bytes
    mov al, [r12 + rbx]     ; primer byte
    mov cl, [r12 + rbx + 1] ; segundo byte  
    mov dl, [r12 + rbx + 2] ; tercer byte
    
    ; Llamar a función para separar bits y convertir
    call separar_y_convertir_3bytes
    
    ; Avanzar índices
    add rbx, 3
    add r15, 4
    
    ; Continuar si hay más datos
    cmp rbx, r13
    jl procesar_grupos
    jmp fin_codificacion

procesar_resto:
    ; Verificar cuántos bytes quedan
    mov rax, r13
    sub rax, rbx
    cmp rax, 0
    je fin_codificacion
    cmp rax, 1
    je procesar_1byte
    cmp rax, 2
    je procesar_2bytes
    
procesar_1byte:
    ; Leer 1 byte y rellenar con 0x00
    mov al, [r12 + rbx]
    mov cl, 0
    mov dl, 0
    call separar_y_convertir_3bytes
    
    ; Reemplazar los dos últimos caracteres con '='
    mov byte [r14 + r15 + 2], '='
    mov byte [r14 + r15 + 3], '='
    add r15, 4
    jmp fin_codificacion
    
procesar_2bytes:
    ; Leer 2 bytes y rellenar con 0x00
    mov al, [r12 + rbx]
    mov cl, [r12 + rbx + 1]
    mov dl, 0
    call separar_y_convertir_3bytes
    
    ; Reemplazar el último caracter con '='
    mov byte [r14 + r15 + 3], '='
    add r15, 4
    jmp fin_codificacion

fin_codificacion:
    ; Restaurar registros y retornar
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

; Función auxiliar: separar_y_convertir_3bytes
; Entrada: al=byte1, cl=byte2, dl=byte3
; Modifica: r14 (buffer salida), r15 (índice salida)
separar_y_convertir_3bytes:
    push rax
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    
    ; Primer grupo: primeros 6 bits del primer byte
    movzx r8, al
    and r8, 0b11111100
    shr r8, 2
    mov r8b, [TablaConversion + r8]
    mov [r14 + r15], r8b
    
    ; Segundo grupo: últimos 2 bits del primer byte + primeros 4 bits del segundo byte
    movzx r9, al
    and r9, 0b00000011
    shl r9, 4
    movzx r10, cl
    and r10, 0b11110000
    shr r10, 4
    or r9, r10
    mov r9b, [TablaConversion + r9]
    mov [r14 + r15 + 1], r9b
    
    ; Tercer grupo: últimos 4 bits del segundo byte + primeros 2 bits del tercer byte
    movzx r8, cl
    and r8, 0b00001111
    shl r8, 2
    movzx r10, dl
    and r10, 0b11000000
    shr r10, 6
    or r8, r10
    mov r8b, [TablaConversion + r8]
    mov [r14 + r15 + 2], r8b
    
    ; Cuarto grupo: últimos 6 bits del tercer byte
    movzx r9, dl
    and r9, 0b00111111
    mov r9b, [TablaConversion + r9]
    mov [r14 + r15 + 3], r9b
    
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret
