%include "debug.mac"
; Everything that comes after a semicolon (;) is a comment

section .text

; You should implement functions in the .text section
; A skeleton is provided for the first function

; the global directive makes a function visible to the test files
global extract_higher_bits
extract_higher_bits:
    ; This function has a 16-bit integer as argument.
    ; it returns the higher 8-bit value of the argument.
    shr di, 8
    mov al, dil
    ret

; TODO: define the 'extract_lower_bits' function.
; This function takes one 16-bit integer as argument and must return the lower 8-bit value of it.
global extract_lower_bits
extract_lower_bits:
    mov al, dil
    ret

; TODO: define the 'extract_redundant_bits' function.
; This function takes one 16-bit integer as argument.
; It returns a 8-bit integer with all bits set in both the lower and the higher 8 bits of the argument.
global extract_redundant_bits
extract_redundant_bits:
    mov si, di
    shr si, 8
    and sil, dil
    mov al, sil
    ret
    
    
; TODO: define the 'set_message_bits' function.
; This function takes one 16-bit integer as argument.
; It returns a 8-bit integer with all bits set if they are set in the higher 8 bits of the argument, the others unchanged.
global set_message_bits
set_message_bits:
    mov si, di
    shr si, 8
    or sil, dil
    mov al, sil
    ret

; TODO: define the 'rotate_private_key' function.
; This function takes one 16-bit integer as argument.
; It returns a 16-bit integer with bits of the private key rotated to the left a number of positions equal to the redundant bits.
; The private key is 0b1011_0011_0011_1100.
; A bit is redundant when it is set in both the lowest 8-bit portion of the argument and the highest 8-bit portion of the argument.
global rotate_private_key
rotate_private_key:
    mov r8w, 0b1011_0011_0011_1100
    call extract_redundant_bits
    movzx ax, al
    popcnt cx, ax
    rol r8w, cl
    mov ax, r8w
    ret

; TODO: define the 'format_private_key' function.
; This function takes one 16-bit integer as argument.
; It returns a 8-bit integer with the private key fully formatted.
; To format a private key, you must:
; - Rotate it.
; - Isolate the lowest 8-bit portion of the rotated private key, which is the base value.
; - Isolate the highest 8-bit portion of the rotated private key, which is a mask to be applied to the base value.
; - Flip set bits in the base value that are also set in the mask.
; - Flip all bits in the result.
global format_private_key
format_private_key:
    call rotate_private_key
    mov r10w, ax ; save rotate key result
    
    ; low 8-bit
    mov di, r10w
    call extract_lower_bits
    mov r8b, al ; lower bit result, base value
    
    ; high 8-bit
    mov di, r10w
    call extract_higher_bits
    mov r9b, al ; higher bit result, mask

    ; r10w is not used anymore, used for mask result
    mov r10b, r8b
    xor r10b, r9b ; the mask applied to the base value
    xor r10b, 0b11111111
    mov al, r10b 
    ret    

; TODO: define the 'decrypt_message' function
; This function takes one 16-bit integer as argument
; It returns a 16-bit integer, of which:
; - The higher 8 bits are the formatted private key, according to 'format_private_key'
; - The lower 8 bits are the message with all bits set, according to 'set_message_bits'
global decrypt_message
decrypt_message:
    mov dx, di ; save the input
    debugu16 dx
    
    call format_private_key
    movzx r8w, al
    
    shl r8w, 8
    
    mov di, dx
    debugu16 dx
    call set_message_bits
    mov r8b, al

    mov ax, r8w
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
