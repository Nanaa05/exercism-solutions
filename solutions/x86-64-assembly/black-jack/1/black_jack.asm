; Everything that comes after a semicolon (;) is a comment

C2 equ 2
C3 equ 3
C4 equ 4
C5 equ 5
C6 equ 6
C7 equ 7
C8 equ 8
C9 equ 9
C10 equ 10
CJ equ 11 ; 10
CQ equ 12 ; 10
CK equ 13 ; 10
CA equ 14

TRUE equ 1
FALSE equ 0

section .text

; You should implement functions in the .text section

; the global directive makes a function visible to the test files
global value_of_card
value_of_card:
    ; This function takes as parameter a number representing a card
    ; The function should return the numerical value of the passed-in card
    
    cmp rdi, CJ
    je .special
    cmp rdi, CQ
    je .special
    cmp rdi, CK
    je .special

    cmp rdi, CA
    je .wah

    mov rax, rdi
    jmp .end

.wah:
    mov rax, 1
    jmp .end
    
.special:
    mov rax, 10
    jmp .end
.end:
    ret

global higher_card
higher_card:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return which card has the higher value
    ; If both have the same value, both should be returned
    ; If one is higher, the second one should be 0
    mov r9, rdi ; first parameter
    mov r8, rsi ; second parameter
    call value_of_card
    mov r10, rax

    mov rdi, r8
    call value_of_card
    cmp rax, r10

    je .equal
    ja .above
    jb .below

.equal:
    mov rax, r9
    mov rdx, r8
    jmp .end
.above: ; second parameter is higher
    mov rax, r8
    mov rdx, 0
    jmp .end
.below: ; first parameter is higher
    mov rax, r9
    mov rdx, 0
    jmp .end
.end:
    ret

global value_of_ace
value_of_ace:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return the value of an upcoming ace
    cmp rdi, CA
    je .one
    
    add rdi, rsi
    add rdi, 11
    cmp rdi, 21
    jg .one
    
.eleven:
    mov rax, 11
    jmp .end
.one:
    mov rax, 1
    jmp .end
.end:
    ret

global is_blackjack
is_blackjack:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards form a blackjack, and FALSE otherwise
    mov r8, FALSE ; CA exists = false
    mov r9, FALSE ; 10 value exists = false
    
    mov r10, rdi ; first param
    mov r11, rsi ; second param
    
.first_compare:
    cmp r10, CA
    je .ca_exists
    
    cmp r11, CA
    je .ca_exists
    
.second_compare:
    mov rdi, r10
    call value_of_card
    cmp rax, 10
    je .ten_exists

    mov rdi, r11
    call value_of_card
    cmp rax, 10
    je .ten_exists
    
    jmp .finish
.ca_exists:
    mov r8, TRUE
    jmp .second_compare
    
.ten_exists:
    mov r9, TRUE

.finish:
    cmp r8, r9
    jne .false
    cmp r8, FALSE
    je .false
    jmp .true
.false:
    mov rax, FALSE
    jmp .end
.true:
    mov rax, TRUE
.end:
    ret

global can_split_pairs
can_split_pairs:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards can be split into two pairs, and FALSE otherwise
    mov r8, rdi ; first param
    mov r9, rsi ; second param

    mov r10, 0 ; first res
    mov r11, 0; second res

    call value_of_card ; rdi is not modified
    mov r10, rax

    mov rdi, r9 ; assign rdi = second param
    call value_of_card
    mov r11, rax

    cmp r10, r11
    je .equal

    mov rax, FALSE
    jmp .end
.equal:
    mov rax, TRUE 
.end:
    ret

global can_double_down
can_double_down:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards form a hand that can be doubled down, and FALSE otherwise
    mov r8, rdi ; first param
    mov r9, rsi ; second param

    mov r10, 0 ; first res
    mov r11, 0; second res
    
    call value_of_card ; rdi is not modified
    mov r10, rax

    mov rdi, r9 ; assign rdi = second param
    call value_of_card
    mov r11, rax

    add r10, r11

    cmp r10, 9
    je .true
    cmp r10, 10
    je .true
    cmp r10, 11
    je .true
    
    mov rax, FALSE
    jmp .end
.true:
    mov rax, TRUE
.end:
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
