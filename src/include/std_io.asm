section .data
defaults:
    newline      db        `\n`,     0
    cr           db        `\r`,     0
    crs1         db        `\r `,    0
    crs2         db        `\r  `,   0
    crs4         db        `\r    `, 0
protons:
    clrln        db        `\r\033[K\r`, 0

section .text

; szstr computes the lenght of a string.
; rdi - string address
; rdx - contains string length (returned)
strsz:
    xor     rcx, rcx                ; zero rcx
    not     rcx                     ; set rcx = -1 (uses bitwise id: ~x = -x-1)
    xor     al,al                   ; zero the al register (initialize to NUL)
    cld                             ; clear the direction flag
    repnz scasb                     ; get the string length (dec rcx through NUL)
    not     rcx                     ; rev all bits of negative -> absolute value
    dec     rcx                     ; -1 to skip the null-term, rcx contains length
    mov     rdx, rcx                ; size returned in rdx, ready to call write
    ret

; strprn writes a string to the file descriptor.
; rdi - string address
; rdx - contains string length
printstr:
    push    rdi                     ; push string address onto stack
    call    strsz                   ; call strsz to get length
    pop     rsi                     ; pop string to rsi (source index)
    mov     rax, 0x1                ; put write/stdout number in rax (both 1)
    mov     rdi, rax                ; set destination index to rax (stdout)
    syscall                         ; call kernel
    ret

; println prints a string and a new line
; rdi - string address
println:
    push rdi                     ; push str addr onto stack
    call printstr                ; call printstr
    pop rdi                      ; restore rdi
    mov rdi, newline             ; put newline in rdi
    call printstr                ; call printstr (prints new line now)
    ret

; print a new line
printnl:
    mov rdi, newline
    call printstr
    ret

; do a carriage return
cret:
    mov rdi, cr
    call printstr
    ret

; sleep
; r8 - seconds
; r9 - microseconds
sleep:
    push r8
    push r9
    mov dword [tv_sec ], r8d
    mov dword [tv_usec], r9d
    mov eax, 162
    mov ebx, timeval
    mov ecx, 0
    int 0x80
    pop r8
    pop r9
    ret