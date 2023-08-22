assume cs:code
code segment
screen:  

    jmp short set; 此指令占2字节
    ; 此dw数据开始地址为 0:204h入口地址+2 即0:20h
    ;由于中断向量表中一个表项是占两个字的，所以int7是从0:204h开始，前面两个字是原中断程序地址
    table dw 204h+a1-screen, 204h+sub2-screen, 204h+sub3-screen,204h+sub4-screen
set:
    push bx

    ; pushf;标志寄存器入栈
	; call dword ptr cs:[200h];执行旧程序

    cmp ah,3;ah代表要执行第几个，从0开始，因为地址从0开始
    ja sret
    mov bl,ah;ah表示想执行第几个程序
    mov bh,0
    add bx,bx

    ;call word ptr table[bx+204h];注意，虽然table是dw但是实际存的只是偏移地址，只有dd时才是偏移地址加段地址
    ;所以这里一定要用call word ptr，不能用call dword ptr
    ;因为call dword ptr后，高字是CS，低字是IP
    call word ptr cs:[bx+206h];cs:[bx+206h]是table的地址
    

    sret:pop bx
    iret

    


a1:;清屏
    push bx
    push si
    push es
    push cx

    mov bx,0b800h
    mov es,bx
    mov si,0
    mov cx,2000
    sub1s:mov byte ptr es:[si],' '
    add si,2
    loop sub1s
    
    pop cx
    pop es
    pop si
    pop bx
    ret

sub2:;设置前景色
    push bx
    push es
    push si
    push cx
    
    
    mov bx,0b800h
    mov es,bx
    mov si,1
    mov cx,2000
    sub2s:and byte ptr es:[si],11111000b
    or es:[si],al   ;al是执行中断前用户选择的
    add si,2
    loop sub2s

    pop cx
    pop si
    pop es
    pop bx
    ret

sub3:;设置背景色
    push bx
    push es
    push si
    push cx

    mov cl,4
    shl al,cl;左移4位补0
    mov bx,0b800h
    mov es,bx
    mov si,1
    mov cx,2000
    sub3s:and byte ptr es:[si],1000111b
    or es:[si],al ;al是执行中断前用户选择的
    add si,2
    loop sub3s

    pop cx
    pop si
    pop es
    pop bx
    ret

sub4:
    push bx
    push ds
    push si
    push es
    push di
    push cx

    mov bx,0b800h
    mov ds,bx
    mov si,160;ds:si=第n+1行
    mov es,bx
    mov di,0;es:di=第n行
    
    cld 
    mov cx,24;循环24次（一共25行）
    sub4s:
    push cx
    mov cx,160;每次移动160字节,一行复制完，si+=160，di+=160
    rep movsb
    pop cx
    loop sub4s

    mov cx,80
    mov di,0
    s:
    mov byte ptr es:[160*24+di],' '
    add di,2
    loop s

    pop cx
    pop di
    pop es
    pop si
    pop ds
    pop bx
    ret

screenend:nop

start:

;将程序写入		
		mov ax,cs
        mov ds,ax
		
		mov ax,0
		mov es,ax
		
		mov si,offset screen;ds:si为源地址
		mov di,204h;es,di为目标地址，一段安全的空间0:200，但前面[200]和[202]要存放原int9的IP和CS

		mov cx,offset screenend-offset screen
		cld;传输方向为正
		rep movsb

;这里一定要重设es，因为前面传输完es被改变了
    mov ax,0
    mov es,ax
;记录下原始的中断程序地址,写入新程序前		
		push es:[7ch*4]
		pop es:[200h]
		push es:[7ch*4+2]
		pop es:[202h]
		
;改变中断向量表
    mov ax,0
    mov es,ax
		cli
		mov word ptr es:[7ch*4],204h
		mov word ptr es:[7ch*4+2],0 ;这里[7*4+2]或[7ch均可*4+2]
		sti
		

		mov ax,4c00h
		int 21h
		


; screen:  

;     jmp short set; 此指令占2字节
;     ; 此dw数据开始地址为 0:204h入口地址+2 即0:20h
;     ;由于中断向量表中一个表项是占两个字的，所以int7是从0:204h开始，前面两个字是原中断程序地址
;     set1:
;     table dw 206h+a1-screen
;           dw 206h+sub2-screen
;           dw 204h+sub3-screen
;           dw 204h+sub4-screen
; set:
;     push bx

;     ; pushf;标志寄存器入栈
; 	; call dword ptr cs:[200h];执行旧程序

;     cmp ah,3;ah代表要执行第几个，从0开始，因为地址从0开始
;     ja sret
;     mov bl,ah;ah表示想执行第几个程序
;     mov bh,0
;     add bx,bx

;     call word ptr table[bx];注意，虽然table是dw但是实际存的只是偏移地址，只有dd时才是偏移地址加段地址
;     ;所以这里一定要用call word ptr，不能用call dword ptr
;     ;因为call dword ptr后，高字是CS，低字是IP
;     ;call dword ptr cs:[bx+206h]
    

;     sret:pop bx
;     iret

    


; a1:;清屏
;     push bx
;     push si
;     push es
;     push cx

;     mov bx,0b800h
;     mov es,bx
;     mov si,0
;     mov cx,2000
;     sub1s:mov byte ptr es:[si],' '
;     add si,2
;     loop sub1s
    
;     pop cx
;     pop es
;     pop si
;     pop bx
;     ret

; sub2:;设置前景色
;     push bx
;     push es
;     push si
;     push cx
    
    
;     mov bx,0b800h
;     mov es,bx
;     mov si,1
;     mov cx,2000
;     sub2s:and byte ptr es:[si],11111000b
;     or es:[si],al   ;al是执行中断前用户选择的
;     add si,2
;     loop sub2s

;     pop cx
;     pop si
;     pop es
;     pop bx
;     ret

; sub3:;设置背景色
;     push bx
;     push es
;     push si
;     push cx

;     mov cl,4
;     shl al,cl;左移4位补0
;     mov bx,0b800h
;     mov es,bx
;     mov si,1
;     mov cx,2000
;     sub3s:and byte ptr es:[si],1000111b
;     or es:[si],al ;al是执行中断前用户选择的
;     add si,2
;     loop sub3s

;     pop cx
;     pop si
;     pop es
;     pop bx
;     ret

; sub4:
;     push bx
;     push ds
;     push si
;     push es
;     push di
;     push cx

;     mov bx,0b800h
;     mov ds,bx
;     mov si,160;ds:si=第n+1行
;     mov es,bx
;     mov di,0;es:di=第n行
    
;     cld 
;     mov cx,24;循环24次（一共25行）
;     sub4s:
;     push cx
;     mov cx,160;每次移动160字节,一行复制完，si+=160，di+=160
;     pop cx
;     rep movsb
;     pop cx
;     loop sub4s

;     mov cx,80
;     mov di,0
;     s:
;     mov byte ptr es:[160*24+di],' '
;     add di,2
;     loop s

;     pop cx
;     pop di
;     pop es
;     pop si
;     pop ds
;     pop bx
;     ret

; screenend:nop


code ends
end start