assume cs:codesg
datasg segment
    db "Beginner's All-purpose Symbolic Instruction Code.", 0
datasg ends
codesg segment
    begin: mov ax,datasg
    mov ds,ax
    mov si,0
    mov cx,0
    call letterc
    mov ax,4c00h
    int 21h
    
    letterc:
    push si
    push ax
    push cx
    s0:

    cmp byte ptr ds:[si],61H
    jb ok;小于小写a，下一个
    cmp byte ptr ds:[si],91H
    ja ok;大于小写z，下一个
    jmp short turn;开始变大写
    turn:
    mov al,ds:[si]
    and al,11011111B;第5位置0，变为大写
    mov ds:[si],al;把改变的大写传回！！
    jmp short ok
    ok:
    mov cl,ds:[si]
    jcxz ok2
    inc si
    jmp short s0
    ok2:
    pop cx
    pop ax
    pop si
    ret

codesg ends
end begin