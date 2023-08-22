assume cs:code
data segment
    db'Welcome to masm!',0
data ends

code segment
    start:mov dh,8;行号
            mov dl,3;列号
            mov cl,2;颜色为绿
            mov ax,data
            mov ds,ax
            mov si,0
            call show_str

            mov ax,4c00h
            int 21h
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
       s1:mov cl,ds:[bx]
          mov es:[si],cl;转移数据到0B800h内
          inc si
          mov es:[si],ah;转移属性到0B800h内
          inc si
          inc bx
          jcxz ok
        jmp short s1
          ok:pop si
          pop ax
          pop cx
          pop dx
          ret
        


  code ends
  end start

