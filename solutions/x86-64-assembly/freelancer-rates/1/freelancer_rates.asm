%include "debug.mac"
; Everything that comes after a semicolon (;) is a comment.

section .text

; You should implement functions in the .text section.
; A skeleton is provided for the first function.

; The global directive makes a function visible to the test files.
global daily_rate
daily_rate:
    ; This function takes an hourly_rate, as a 64-bit floating-point number.
    ; It returns the daily rate, also as a 64-bit floating-point number.
    ; A day has 8 billable hours.
    mov rcx, 8
    cvtsi2sd xmm1, rcx
    mulsd xmm0, xmm1
    ret

; TODO: define the 'apply_discount' function.
; It takes as parameters a price and a discount in percent, both as 64-bit floating-point number.
; It returns the price with discount applied, as a 64-bit floating-point number.
global apply_discount
apply_discount:
    mov rcx, 100
    cvtsi2sd xmm2, rcx
    cvtsi2sd xmm3, rcx
    subsd xmm2, xmm1
    divsd xmm2, xmm3
    mulsd xmm0, xmm2
    ret
; TODO: define the 'monthly_rate' function.
; It takes as parameters an hourly_rate and a discount in percent, both as a 64-bit floating-point number.
; It returns the discounted monthly rate, as a 64-bit integer, rounded up.
; A month has 22 billable days.
global monthly_rate
monthly_rate:
    ; apply discount (daily rate (hourly rate) * 22, discount), then round up
    ; first param : hourly rate
    ; second param : discount
    movsd xmm10, xmm1 ; discount
    call daily_rate
    mov rcx, 22
    cvtsi2sd xmm1, rcx
    mulsd xmm0, xmm1
    movsd xmm1, xmm10
    call apply_discount
    debugf64 xmm0
    roundsd xmm0, xmm0, 2
    cvtsd2si rax, xmm0
    ret

; TODO: define the 'days_in_budget' function.
; It takes as parameters:
; 1. A budget as a 64-bit unsigned integer.
; 2. An hourly_rate, as a 64-bit floating-point number.
; 3. A discount in percent, as a 64-bit floating-point number.
; It returns the number of complete days of work the budget covers, as a 32-bit unsigned integer, rounded down.
global days_in_budget
days_in_budget:
    ; rounddown ( budget / apply_discount(daily_rate(hourly_rate)))
    movsd xmm11, xmm1
    call daily_rate
    
    movsd xmm1, xmm11
    call apply_discount
    cvtsi2sd xmm2, rdi
    divsd xmm2, xmm0
    roundsd xmm2, xmm2, 1
    cvtsd2si rax, xmm2
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
