assume cs:code
data segment
     db 'ID: 2021103285, Name: Wendi Chen'
data ends
code segment
start: 
          mov ax,data
          mov ds,ax
          mov bx,0
          mov ax,0B800h ;规定以字母开始的十六进制数，应在其前面加上数字0以便汇编程序区分常数和符号。
          mov es,ax
          mov si,1970 ;第十行中间 12*160+50(共25行一行160字节)
          mov ah,00000010B 

          mov cx,32
     s1:mov al,ds:[bx]
          mov es:[si],al
          inc si
          ;mov byte ptr es:[si],02h
          mov es:[si],ah
          inc si
          inc bx
          loop s1

     ;s2:  jmp short s2
	   mov ax,4c00h
	   int 21h
code ends
end start