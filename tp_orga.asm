;Integrantes
;Batastini Fabricio 111828
;Savone Federico
;Maximiliano Fittipaldi

global	main
extern	puts

section	.data
	secuenciaBinariaA	db	0xC4, 0x94, 0x37, 0x95, 0x63, 0xA2, 0x1D, 0x3C 
						db	0x86, 0xFC, 0x22, 0xA9, 0x3D, 0x7C, 0xA4, 0x51 
						db	0x63, 0x7C, 0x29, 0x04, 0x93, 0xBB, 0x65, 0x18 
	largoSecuenciaA		db	0x18 ; 24d

	; secuenciaImprmibleB db	"vhyAHZucgTUuznwTDciGQ8m4TuvUIyjU"
	; largoSecuenciaB		db	0x20 ; 32d

	TablaConversion		db	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

	Contador			db	0
	contadorLetras		db	0
	
; Casos de prueba:
; SecuenciaBinariaDePrueba db	0x73, 0x38, 0xE7, 0xF7, 0x34, 0x2C, 0x4F, 0x92
;						   db	0x49, 0x55, 0xE5, 0x9F, 0x8E, 0xF2, 0x75, 0x5A 
;						   db	0xD3, 0xC5, 0x53, 0x65, 0x68, 0x52, 0x78, 0x3F
; SecuenciaImprimibleCodificada	db	"czjn9zQsT5JJVeWfjvJ1WtPFU2VoUng/"

; SecuenciaImprimibleDePrueba db "Qy2A2dhEivizBySXb/09gX+tk/2ExnYb"
; SecuenciaBinariaDecodificada	db	0x43, 0x2D, 0x80, 0xD9, 0xD8, 0x44, 0x8A, 0xF8 
;								db	0xB3, 0x07, 0x24, 0x97, 0x6F, 0xFD, 0x3D, 0x81 
;								db	0x7F, 0xAD, 0x93, 0xFD, 0x84, 0xC6, 0x76, 0x1B
 
; Un codificador/decodificador online se puede encontrar en https://www.rapidtables.com/web/tools/base64-encode.html
	
section	.bss
	secuenciaImprimibleA	resb	32
	; secuenciaBinariaB		resb	24

	secuencia4Letras		resb 	4
	
section	.text

main:

obtenerBytes:
	mov 	rcx, 0
	mov		cl, [Contador]	
	mov		al,	[secuenciaBinariaA + rcx]
	inc		rcx
	mov		bl,	[secuenciaBinariaA + rcx]		;Obtengo los 3 bytes
	inc		rcx
	mov		dl,	[secuenciaBinariaA + rcx]
	inc		rcx
	mov		[Contador],cl

	jmp		separarBits


separarBits:
	;primer byte al, segundo byte bl, tercer byte dl

	;Primer grupo de bits
	mov		ah, al
	and		ah, 0b11111100		;hago and con los primeros 6 bits, los ultimos dos no me importan y con and veo sus valores
	shr		ah, 2				;Muevo los bits a la derecha 2 posiciones, para que tomen el valor como un numero de 6 bits en lugar de 8, 
								;dejando los 2 MSB con 0
	mov		[secuencia4Letras], ah

	;Segundo grupo de bits

	mov		ah, al
	and		ah, 0b00000011		;Tomo los ultimos dos bits del primer byte
	shl		ah, 4				;Los posiciono en los bits que valen 32,16
	mov		bh, bl
	and		bh, 0b11110000		;Tomo los primeros 4 bits del segundo byte
	shr		bh, 4				;Los posiciono en los bits que valen 8,4,2,1
	or		bh, ah				;Hago or para unir los dos resultados
	mov		[secuencia4Letras + 1], bh

	;Tercer grupo de bits

	mov		bh, bl
	and		bh, 0b00001111		;Tomo los ultimos 4 bits del segundo byte
	shl		bh, 2				;Muevo los bits a las posiciones con valor 32,16,8,4
	mov		ch, dl
	and		ch, 0b11000000		;Tomo los primeros 2 bits del tercer byte
	shr		ch, 6				;Muevo los bits a las posiciones con valor 2,1
	or		ch, bh				;Uno los resultados
	mov		[secuencia4Letras + 2], ch

	;Cuarto grupo de bits

	mov		ch, dl
	and		ch, 0b00111111		;Tomo los ultimos 6 bits del tercer byte, ya estan en la posicion deseada
	mov		[secuencia4Letras + 3], ch

	jmp 	inicializarVariables
	
inicializarVariables:
	mov		al,4
	add 	[contadorLetras], al ;Aumento la cantidad de letras que tendre en el resultado

	mov 	rcx, 4				;Pongo rcx en 4 para el loop
	mov 	rbx, 0				;Contador para la posicion del caracter dentro de su grupo de 4, que queremos agregar

	mov 	rdx, 0							;Limpio rdx y rax
	mov		rax, 0

	jmp insertarCaracteres

insertarCaracteres:
	mov		dl, [secuencia4Letras + rbx]	;Obtengo posicion del caracter a agregar en la tabla de conversion
	mov		dl, [TablaConversion + rdx]		;Obtengo caracter a agregar

	mov		al, [contadorLetras]
	sub		rax, rcx							;Obtengo la posicion en la que guardar el caracter, uso cl porque ahi se guarda el 4 en rcx (parte baja de rcx)
	mov		[secuenciaImprimibleA + rax], dl	;Guardo el caracter en el resultado

	inc		rbx
	loop	insertarCaracteres

	mov 	rax, 0
	mov		al, [Contador]
	cmp		al, [largoSecuenciaA]
	jl		obtenerBytes


imprimir:
	mov		rdi,secuenciaImprimibleA
	sub		rsp,8
	call	puts
	add		rsp,8

	ret