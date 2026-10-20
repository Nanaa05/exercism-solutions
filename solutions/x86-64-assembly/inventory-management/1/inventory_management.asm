%include "debug.mac"

; Everything that comes after a semicolon (;) is a comment

WEIGHT_OF_EMPTY_BOX equ 500
TRUCK_HEIGHT equ 300
PAY_PER_BOX equ 5
PAY_PER_TRUCK_TRIP equ 220

section .text

; You should implement functions in the .text section
; A skeleton is provided for the first function

; the global directive makes a function visible to the test files
global get_box_weight
get_box_weight:
    ; This function takes the following parameters:
    ; - The number of items for the first product in the box, as a 16-bit non-negative integer
    ; - The weight of each item of the first product, in grams, as a 16-bit non-negative integer
    ; - The number of items for the second product in the box, as a 16-bit non-negative integer
    ; - The weight of each item of the second product, in grams, as a 16-bit non-negative integer
    ; The function must return the total weight of a box, in grams, as a 32-bit non-negative integer
    movzx r9d, dx
    movzx r10d, cx
    
    movzx eax, di
    movzx ecx, si
    
    mul ecx

    mov r8d, eax

    xor eax, eax
    xor ecx, ecx

    mov eax, r9d
    mov ecx, r10d
    
    mul ecx

    add eax, r8d

    add eax, WEIGHT_OF_EMPTY_BOX
    
    ret

global max_number_of_boxes
max_number_of_boxes:
    ; TODO: define the 'max_number_of_boxes' function
    ; This function takes the following parameter:
    ; - The height of the box, in centimeters, as a 8-bit non-negative integer
    ; The function must return how many boxes can be stacked vertically, as a 8-bit non-negative integer
    mov ax, TRUCK_HEIGHT
    div dil
    ret

global items_to_be_moved
items_to_be_moved:
    ; TODO: define the 'items_to_be_moved' function
    ; This function takes the following parameters:
    ; - The number of items still unaccounted for a product, as a 32-bit non-negative integer
    ; - The number of items for the product in a box, as a 32-bit non-negative integer
    ; The function must return how many items remain to be moved, after counting those in the box, as a 32-bit integer
    mov rax, rdi
    sub rax, rsi
    ret

global calculate_payment
calculate_payment:
    ; TODO: define the 'calculate_payment' function
    ; This function takes the following parameters:
    ; - 1. The upfront payment, as a 64-bit non-negative integer
    ; - 2. The total number of boxes moved, as a 32-bit non-negative integer
    ; - 3. The number of truck trips made, as a 32-bit non-negative integer
    ; - 4. The number of lost items, as a 32-bit non-negative integer
    ; - 5. The value of each lost item, as a 64-bit non-negative integer
    ; - 6. The number of other workers to split the payment/debt with you, as a 8-bit positive integer
    ; The function must return how much you should be paid, or pay, at the end, as a 64-bit integer (possibly negative)
    ; Remember that you get your share and also the remainder of the division
    ; net = boxes * PAY_PER_BOX + trips * PAY_PER_TRUCK_TRIP - up_front - broken_items * item_value
    ; net = ($2 * PAY_PER_BOX) + ($3 * PAY_PER_TRUCK_TRIP) - $1 - ($4 * $5)
    ; res = net / $ 6
    ; 1 = rdi/edi/di/dil
    ; 2 = rsi/esi/si/sil
    ; 3 = rdx/edx/dx/dl
    ; 4 = rcx/ecx/cx/cl
    ; 5 = r8/r8d/r8w/r8b
    ; 6 = r9/r9d/r9w/r9b

    ; ($2 * PAY_PER_BOX)
    
    imul eax, esi, PAY_PER_BOX

    ; 2990
    debugd32 eax 

    ; tmp
    mov r10d, eax

    ; ($3 * PAY_PER_TRUCK_TRIP)
    imul eax, edx, PAY_PER_TRUCK_TRIP
    
    ; 440
    debugd32 eax

    ; tmp += ($3 * PAY_PER_TRUCK_TRIP)
    add r10d, eax

    ; ($4 * $5)
    movsx rcx, ecx
    imul rcx, r8
    mov rax, rcx
    
    ; 5400
    debugd32 eax
    
    ; tmp -= ($4 * $5)
    movsx r11, r10d
    sub r11, rax
    
    ; -1970
    debugd32 r10d

    
    ; tmp -= $1
    sub r11, rdi
    
    ; -3970
    debugd64 r11

    mov rax, r11
    movzx r10, r9b
    inc r10
    cqo

    debugd64 rdx, rax, r10
    idiv r10
    
    add rax, rdx

    debugd64 rax
    
    ; return = rax/eax/ax/al
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
