; Assembly from: https://gist.github.com/FiloSottile/7125822

; Building and running the executable can be done with the following commands:
; $ nasm -f macho64 hello.asm
; $ ld -macosx_version_min 10.7.0 -lSystem -o hello hello.o
; $ ./hello

; global is a nasm directive: https://nasm.us/doc/nasmdoc6.html
; It is used to declare a symbol pointing to specific code.
; The `start` label is needed to mark the entrypoint of the binary.
global start

; Defines the .text section containing executable code: https://www.nasm.us/doc/nasmdoc7.html
section .text

; The x86-64 ABI can be found here: https://www.uclibc.org/docs/psABI-x86_64.pdf
; This document describes the interface used to make syscalls via ASM: A.2.1 ("Calling Conventions")
; Notes relevant to this implementation:
;
; * The syscall number is passed in via %rax
;
; * User-level applications use as integer registers for passing the sequence:
;   %rdi, %rsi, %rdx, %rcx, %r8 and %r9.
;
; * %rax will contain the return value of the syscall.
start:
    ; `write` has the following interface: write(int fd, const void *buf, size_t count)
    mov     rax, 0x2000004 ; The `write` syscall number.
    mov     rdi, 1         ; The `fd` parameter. 1 = stdout .
    mov     rsi, msg       ; The `buf` parameter.
    mov     rdx, msg.len   ; The `count` paramter.
    syscall       

    ; `exit` has the following interface: exit(int status)
    mov     rax, 0x2000001 ; The `exit` syscall number.
    mov     rdi, 0         ; The `status` parameter.
    syscall


; Defines the .data section containing data.
section .data

; Define a label `msg` pointing to the byte literals inserted into the binary by `db`. 
; `db` is a "pseduo-instruction": https://www.nasm.us/xdoc/2.11.02/html/nasmdoc3.html#section-3.2
; The `, 10` piece just concatenates ASCII value 10 (decimal) which corresponds to a newline.
msg:    db      "Hello, world!", 10

; The label `.len` is a "local label": https://www.nasm.us/doc/nasmdoc3.html#section-3.9
; This creates an association with the previous non-local label of `msg`. This why the
; `write` syscall can refer to the label `msg.len`.
; 
; The `equ` directive gives a name (here, `.len`) to a constant (here `$ - msg`).
; The `$` corresponds to the current position of the assembly. So `$ - msg` evaluates
; to the number of bytes between `msg` and `.len` which is the length of the string.
.len:   equ     $ - msg
