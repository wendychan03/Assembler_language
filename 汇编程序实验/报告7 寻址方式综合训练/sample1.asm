assume cs:codesg, ss:stacksg, ds:datasg

stacksg segment 
	dw 0,0,0,0,0,0,0,0
stacksg ends

datasg segment
	db '1. display      '
	db '2. brows        '
	db '3. replace      '
	db '4. modify       '
datasg ends

codesg segment
	start:mov ax,datasg
		mov ds,ax
		mov bx,0
		mov cx,4
	s1:	mov si,3
		push cx
		
		mov cx,4
	s2: mov al,[bx+si]	;将ascii码从内存单元中取出
		and al,11011111b 
		mov [bx+si],al  ;变完大写的ascii码写回内存
		inc si
		loop s2
		
		pop cx
		add bx,16
		loop s1
			
		mov ax,4c00h
	    int 21h
codesg ends

end start
