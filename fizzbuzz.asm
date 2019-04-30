; Building and running the executable can be done with the following commands:
; $ nasm -f macho64 fizzbuzz.asm
; $ ld -macosx_version_min 10.7.0 -lSystem -o fizzbuzz fizzbuzz.o
; $ ./fizzbuzz

global _main
extern _printf
extern _exit

section .text

_main:
    ; https://stackoverflow.com/questions/8691792/how-to-write-assembly-language-hello-world-program-for-64-bit-mac-os-x-using-pri
    sub rsp, 8        ; see link above for the 'why' here.
    mov r12, 30       ; r12 will contain our iterator
_loop:
    mov  rdi, number  ; prepare for print. add number format string.
    mov  rsi, r12     ; pass our iterator as second argument to printf
    mov  rdx, 0       ; terminate variable arguments to printf
    call _printf      ; call printf
_check_fizz:
    xor rdx, rdx      ; clear rdx
    mov rax, r12      ; dividend in rax
    mov rcx, 3        ; divisor in rcx
    div rcx           ; rax / 3; rdx will contain modulus
    cmp rdx, 0
    jnz _check_buzz   ; if the modulus is non-zero no fizz
_do_fizz:
    mov rdi, fizz     ; if this was not skipped over, print "Fizz"
    mov rsi, 0        ; terminate variable arguments to printf
    call _printf      ; print "Fizz"
_check_buzz:
    xor rdx, rdx      ; clear rdx
    mov rax, r12      ; dividend in rax
    mov rcx, 5        ; divisor in rcx
    div rcx           ; rax / 5; rdx will contain modulus
    cmp rdx, 0
    jnz _newline      ; if the modulus is non-zero no buzz
_do_buzz:
    mov rdi, buzz     ; if this was not skipped over, print "Buzz"
    mov rsi, 0        ; terminate variable arguments to printf
    call _printf      ; print "Buzz"
_newline:
    mov  rdi, newline ; prepare to print a newline
    mov  rsi, 0       ; varag terminate
    call _printf      ; print newline
_check_loop:
    dec  r12          ; decrement our iterator
    jnz  _loop        ; loop if iterator is nonzero
_done:
    xor  rdi, rdi     ; we're done! set our exit code to zero
    call _exit        ; call exit

; Defines the .data section containing data.
section .data

fizz:    db "Fizz", 0
buzz:    db "Buzz", 0
number:  db "%d ", 0
newline: db 10, 0 ; ascii 10 = \n
