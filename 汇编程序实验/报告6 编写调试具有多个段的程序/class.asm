assume cs:code,ds:data
data segment
    dw 10h
data ends
code segment
start:
    mov ax,10h
code ends
end start