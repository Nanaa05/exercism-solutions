TRUE equ 1
FALSE equ 0

section .text
global leap_year

leap_year:
    ; Provide your implementation here
    ; The function has type signature int leap_year(int year)
    ; The return value and the argument are of type int, which is a 32-bit signed integer
    mov rax, rdi
    mov rdx, 0
    mov r8, 4 ; check 4 as divisor
    idiv r8
    cmp rdx, 0
    jne .false

    mov rax, rdi
    mov rdx, 0
    mov r8, 100 ; check 100 as divisor
    idiv r8
    cmp rdx, 0
    je .false
    
.true:
    mov rax, TRUE
    jmp .end
.false:
    mov rax, rdi
    mov rdx, 0
    mov r8, 400 ; check 400 as divisor
    idiv r8
    cmp rdx, 0
    je .true
    mov rax, FALSE
.end:
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
