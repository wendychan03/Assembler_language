assume cs:code

code segment
	start:
;将程序写入		
		push cs
		pop ds;将cx赋值给ds
		
		mov ax,0
		mov es,ax
		
		mov si,offset int9;ds:si为源地址
		mov di,204h;es,di为目标地址，一段安全的空间0:200，但前面[200]和[202]要存放原int9的IP和CS

		mov cx,offset int9end-offset int9
		cld;传输方向为正
		rep movsb

;记录下原始的中断程序地址,写入新程序前		
		push es:[9*4]
		pop es:[200h]
		push es:[9*4+2]
		pop es:[202h]
		
;改变中断向量表
		cli
		mov word ptr es:[9*4],204h
		mov word ptr es:[9*4+2],0
		sti
		
		
		mov ax,4c00h
		int 21h
		
	int9:
		push ax
		push bx
		push cx
		push es
		
		in al,60h;接收输入
		
		pushf;标志寄存器入栈
		call dword ptr cs:[200h];执行旧程序
		
		cmp al,9eh;A的断码
		jne int9ret
         ;满足，不转跳，开始写A
        ;一般一屏的内容在显示缓冲区共占4000个字节(实验8)

		mov cx,2000
		mov ax,0b800h
		mov es,ax
		mov bx,0
		
	s:	mov byte ptr es:[bx],'A'
        mov byte ptr es:[bx+1],00011100B
		add bx,2
		loop s
		
	int9ret:
		pop es
		pop cx
		pop bx
		pop ax
		iret
	int9end:
		nop
code ends
end start

