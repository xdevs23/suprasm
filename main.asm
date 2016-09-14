;
; Suprasm
; Copyright (C) 2016 Simao Gomes Viana
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;

;;; Imports ;;;


;;; .data section ;;;

section .data
defaults:
    newline      db        `\n`,     0
    cr           db        `\r`,     0
    crs1         db        `\r `,    0
    crs2         db        `\r  `,   0
    crs4         db        `\r    `, 0
protons:
    clrln        db        `\r\033[K\r`, 0
customs:
    intrmsg      db        `\033[41m   \033[40;48;5;202m   \033[43m   \033[42m   \033[46m   \033[44m   \033[45m   \033[0m\n`,
                 db        `\033[41m S \033[40;48;5;202m u \033[43m p \033[42m r \033[46m a \033[44m s \033[45m m \033[0m\n`,
                 db        `\033[41m   \033[40;48;5;202m   \033[43m   \033[42m   \033[46m   \033[44m   \033[45m   \033[0m\n`,
                 db        `Copyright (C) 2016 Simao Gomes Viana\n\n`
                 db        `This program is licensed under the GPLv3 license.\n`
                 db        `This program comes with ABSOLUTELY NO WARRANTY\n`
                 db        `This is free software, and you are welcome to redistribute it `
                 db        `under certain conditions\n`
                 db        `You may obtain a copy of this license at http://www.gnu.org/licenses/\n\n`, 0
    hlwrdmsg     db        "Hello World!", 0
    ahllnmsg1    db        "This is my first program "
                 db        "written in x64 assembly.", 0
    ahllnmsg2    db        "Enjoy!!", 0
    instrngtl    db        "Now we are going to loop a few times and print some stuff...", 0
    wowtwcool    db        "Wow, that was cool!", 0
    kthxbye      db        `Thank you very much for testing out my first program written in x86_64 ASM.\n\nThis program will exit in 5 seconds xD`, 0
    bye          db        `\033[92mGoodbye.\033[0m`, 0
   
electrons:
      timeval:
        tv_sec   dd    0
        tv_usec  dd    0
; end of .data

;;; .text section ;;;
section .text
    global _start

;;; Functions ;;;

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

;;; Main entry point ;;;

_start:
    enter 0, 0
    
    call printnl
    
    mov rdi, intrmsg
    call println
    
    mov r8, 1
    call sleep

    mov rdi, hlwrdmsg
    call println
    
    mov rdi, ahllnmsg1
    call println
    
    mov rdi, ahllnmsg2
    call println

    call printnl
    call printnl
    
    mov rdi, instrngtl
    call println
    
 mov cx, 4
 ls1:
    cmp cx, 0
    jz lc1
    push cx
 l1:
    mov r8, 1
    mov r9, 0
    call sleep
    mov rdi, clrln
    call printstr
    mov r8, 1
    mov r9, 0
    call sleep
    mov rdi, hlwrdmsg
    call printstr
    pop cx
    dec cx
 jmp ls1
    
 lc1:
    mov rdi, clrln
    call printstr
    mov rdi, wowtwcool
    call println
    
    mov r8, 1
    call sleep
    
    mov rdi, kthxbye
    call println
    
    mov r8, 5
    mov r9, 0
    call sleep
    
    call printnl
    
    mov rdi, bye
    call println
    
    call exit
    ret

;;; Last point ;;;
exit:
    call printnl
    mov rax, 60
    mov rdi, 0
    syscall
    leave
    ret

; end of .text