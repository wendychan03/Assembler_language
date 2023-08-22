assume cs:code
code segment
    mov dx,0
    mov ax,0
    mov cx,10
s1: add ax,1
    push cx
    mov bl,0
    mov bh,0
    mov cx,ax
s2: add bh,1
    add bl,bh   
    loop s2
    pop cx
    mov bh,0
    add dx,bx
    loop s1
    mov ax,4c00h
    int 21h

code ends
end




