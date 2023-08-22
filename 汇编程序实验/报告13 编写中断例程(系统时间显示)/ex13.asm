assume cs:code 
code segment

start:
    ;将中断例程安装在 0:200 处
    mov ax,cs
    mov ds,ax
    mov si,offset stopstart;设置 ds:si 指向要写入的地方开头

    mov ax,0
    mov es,ax
    mov di,200h ;es:di 为转送的目的位置0:200
    mov cx,offset stopend- offset stopstart
    cld
    rep movsb

    ;设置中断向量表
    mov ax,0 
    mov es,ax
    mov word ptr es:[7ch*4],200h 
    mov word ptr es:[7ch*4+2],0

    mov ax,4c00h
    int 21h

    stopstart:
    jmp short stop
    db 'yy/mm/dd hh:mm:ss'
    db 9,8,7,4,2,0
    stop:
    mov ax,cs
    mov ds,ax
    mov si,202H;第一条jmp语句占两字节
    mov cx,6
    mov bx,17

    s1:
    push cx
    mov al,ds:[bx+202H];读取系统时间
    out 70h,al
    in al,71h


    mov ah,al
    mov cl,4
    shr ah,cl
    and al,00001111b

    add ah,30h;变为字符串
    add al,30h
    mov ds:[si],ah;写入
    mov ds:[si+1],al

    add si,3
    add bx,1

    pop cx
    loop s1
 
 ;写入显示区

    ; mov ax,0
    ; mov ds,ax
    ; mov si,202H;设置 ds:si 指向要写入的地方开头

    ; mov bx,0b800h
    ; mov es,bx
    ; mov di,160*12+40*2 ;es:di 为转送的目的位置
    ; ;40*2：一行80个字符每个2字节；160*12：一行160字节共25行
    ; mov cx,17
    ; cld
    ; rep movsb
    ; ;这里不对，因为显存里每个字符串后面是有背景颜色，不能直接复制到显存

    mov  ax,0b800h
    mov  es,ax
    mov  di,120*12+31*2
    mov  si,202H

    showtime: 
        mov  cl,ds:[si];将字符串写到显存里
        mov  ch,0
        jcxz ok
        mov  es:[di],cl
        inc  si
        add  di,2
        jmp  short showtime
    ok:        
    mov ax,4c00h
    int 21h

    stopend:nop

code ends
end start