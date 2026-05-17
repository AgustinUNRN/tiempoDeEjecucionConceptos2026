; Algoritmos/radix.asm
; Compilar: nasm -f elf64 Algoritmos/radix.asm -o Algoritmos/radix_asm.o
; Enlazar con C: gcc -O2 Algoritmos/radix_asm.o Algoritmos/bench.c -o radix_asm

global radix_sort
extern malloc, free

section .text

; void radix_sort(int *a, size_t n)
; rdi = a (puntero al arreglo)
; rsi = n (cantidad de elementos)
radix_sort:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
    push rbx

    test rsi, rsi           ; Si n == 0, salir
    jz .fin

    mov r12, rdi            ; r12 = a
    mov r13, rsi            ; r13 = n

    ; --- PASO 1: Buscar el máximo ---
    mov r14d, dword [r12]   ; max = a[0]
    mov rcx, 1              ; i = 1
.buscar_max:
    cmp rcx, r13
    je .max_encontrado
    mov eax, dword [r12 + rcx*4]
    cmp eax, r14d
    jle .siguiente_max
    mov r14d, eax           ; max = a[i]
.siguiente_max:
    inc rcx
    jmp .buscar_max
.max_encontrado:

    ; --- PASO 2: aux = malloc(n * 4 bytes) ---
    mov rdi, r13
    shl rdi, 2              ; n * 4
    call malloc wrt ..plt
    mov rbx, rax            ; rbx = puntero a aux

    mov r15d, 1             ; exp = 1

.bucle_principal:
    ; Condición: if (max / exp == 0) salir del bucle
    mov eax, r14d
    xor edx, edx
    div r15d                ; eax = max / exp
    test eax, eax
    jz .fin_bucle

    ; Crear count[10] = {0} en el Stack (40 bytes)
    sub rsp, 40
    mov rcx, 10
    lea rdi, [rsp]
    xor eax, eax
    rep stosd               ; Llena 40 bytes con 0

    ; --- for i=0..n-1: count[(a[i]/exp)%10]++ ---
    xor rcx, rcx
.conteo:
    cmp rcx, r13
    je .fin_conteo
    mov eax, dword [r12 + rcx*4] ; a[i]
    xor edx, edx
    div r15d                     ; eax = a[i] / exp
    mov edi, 10
    xor edx, edx
    div edi                      ; edx = digito (resto de / 10)
    
    mov eax, dword [rsp + rdx*4]
    inc eax
    mov dword [rsp + rdx*4], eax ; count[digito]++
    inc rcx
    jmp .conteo
.fin_conteo:

    ; --- Suma de prefijos: count[i] += count[i-1] ---
    mov rcx, 1
.prefijos:
    cmp rcx, 10
    je .fin_prefijos
    mov eax, dword [rsp + rcx*4 - 4]
    add dword [rsp + rcx*4], eax
    inc rcx
    jmp .prefijos
.fin_prefijos:

    ; --- Distribuir: for i = n-1 down to 0 ---
    mov rcx, r13
    dec rcx
.distribuir:
    cmp rcx, 0
    jl .fin_distribuir
    mov eax, dword [r12 + rcx*4] ; a[i]
    push rax                     ; Guardar a[i] temporalmente
    
    xor edx, edx
    div r15d
    mov edi, 10
    xor edx, edx
    div edi                      ; edx = digito
    
    mov eax, dword [rsp + 8 + rdx*4] ; +8 por el push anterior
    dec eax
    mov dword [rsp + 8 + rdx*4], eax ; --count[digito]
    
    pop r8                       ; Recuperar a[i] en r8
    mov dword [rbx + rax*4], r8d ; aux[pos] = a[i]
    
    dec rcx
    jmp .distribuir
.fin_distribuir:

    ; --- memcpy(a, aux, n * 4) ---
    mov rcx, r13
.copiar:
    test rcx, rcx
    jz .fin_copiar
    dec rcx
    mov eax, dword [rbx + rcx*4]
    mov dword [r12 + rcx*4], eax
    jmp .copiar
.fin_copiar:

    add rsp, 40             ; Limpiar count[10] del stack

    ; exp *= 10
    mov eax, r15d
    mov edi, 10
    mul edi
    mov r15d, eax
    jmp .bucle_principal

.fin_bucle:
    ; free(aux)
    mov rdi, rbx
    call free wrt ..plt

.fin:
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret
