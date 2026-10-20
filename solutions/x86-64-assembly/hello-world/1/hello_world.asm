default rel

section .rodata
    msg: db "Hello, World!", 0

section .text
    global hello
hello:
    lea rax, [msg]
    ; mov rdi, 1
    ; mov rsi, rax
    ; mov rax, 1
    ; mov rdx, 14
    ; syscall
    ; mov rax, 60
    ; mov rdi, 0
    ; syscall
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
