assume cs: code
data segment
    db 10 dup (0) 
data ends
code segment
    start:mov ax,12666
        mov bx, data
        mov ds, bx
        mov si,0
        call dtoc
        ; mov bl,2ch;
        ; mov ds:[si],bl;每个数尾加上逗号

        ; mov ax,12666;317A
        ; mov si,6;每个10位数对应1byte，逗号对应1byte
        ; call dtoc
        ; mov bl,2ch;
        ; mov ds:[si],bl;每个数尾加上逗号

        ; mov ax,1
        ; mov si,8
        ; call dtoc
        ; mov bl,2ch;
        ; mov ds:[si],bl;每个数尾加上逗号

        ; mov ax,8
        ; mov si,10
        ; call dtoc
        ; mov bl,2ch;
        ; mov ds:[si],bl;每个数尾加上逗号

        ; mov ax,3
        ; mov si,12
        ; call dtoc
        ; mov bl,2ch;
        ; mov ds:[si],bl;每个数尾加上逗号

        mov ax,38
        mov si,14
        call dtoc

        mov dh, 8
        mov dl, 3
        mov cl,2
        call show_str
        
        
        mov ax,4c00h
        int 21h

    dtoc:;注意，由于商1266大于255，所以如果采用被除数为16位的除法，存放在Al的商将溢出
    ;所以采用除数为16bit；被除数为32bit，ax存放低16bit，dx存放高16bit；ax存放商，dx存放余数的除法
        push ax
        push bx
        push cx
        push dx
        push di
        push si

        mov di,0;用来记录入栈次数
       s1: mov dx,0;被除数为32bit，ax存放低16bit，dx存放高16bit
        mov bx,10 ;除数为16位
        div bx;除
        push dx;余数入栈
        inc di
        mov cx,ax;商存放在ax中，转到cx
        mov dx,0;更新商为被除数,使被除数高位为0
        jcxz writedata;商为0跳出循环,准备将栈内内容写到数据段
        jmp short s1;这里用jmp不要用loop

        writedata:
        mov cx,di
        s2: 
        pop ax;将栈内内容写到数据段
        add ax,30H;转换为ascii码
        mov ds:[si],al;这里用al不要用ax
        inc si
        loop s2

        pop si
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        ret

    show_str:
        push dx
        push cx
        push ax
        push si
          ;在屏幕第8行，所以7行*160。但由于汇编中行号第0行（不显示）开始的，所以从数值上看是8*160          
          mov al,160
          mul dh
          add si,ax
          ;dec dl         
          mov al,2
          mul dl
          add si,ax;3列*2
          ;共25行，编号0-24，一行160字节，si=8*160+3*2
          ;00-01对应的是屏幕第0列(显示)
          

          mov ax,0B800h ;规定以字母开始的十六进制数，应在其前面加上数字0以便汇编程序区分常数和符号。
          mov es,ax
          mov ah,cl;颜色为绿
          mov bx,0
          mov cx,0
       s3:mov cl,ds:[bx]
          mov es:[si],cl;转移数据到0B800h内
          inc si
          mov es:[si],ah;转移属性到0B800h内
          inc si
          inc bx
          jcxz ok2
        jmp short s3
          ok2:
          pop si
          pop ax
          pop cx
          pop dx
          ret
        



code ends
end start