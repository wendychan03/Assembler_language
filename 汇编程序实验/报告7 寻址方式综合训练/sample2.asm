assume cs:codesg

data segment
        db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
        db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
        db '1993','1994','1995'
        ;以上是表示21年的21个字符串
        dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
        dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
        ;以上是表示21年公司总收的21个dword型数据
        dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
        dw 11542,14430,45257,17800
        ;以上是表示21年公司雇员人数的21个word型数据
data ends


table segment
    db 21 dup ('year summ ne ?? ')
table ends


codesg segment
start:
        mov ax,data
        mov ds,ax
        mov ax,table
        mov es,ax
        mov si,0 ;si:data的偏移
        mov bx,0

        mov cx,21;按行每次写入
        mov bx,0
        s1:
        mov ax,ds:[si];年份
        mov es:[bx],ax
        mov ax,ds:[si+2];
        mov es:[bx+2],ax
        add bx,10h
        add si,4
        loop s1
        
        mov cx,21
        mov bx,0
        mov si,0
        s2: 
        mov ax,ds:[si+84];收入 一个年份4字节*21年=84
        mov es:[bx+5],ax
        mov ax,ds:[si+84+2]
        mov es:[bx+7],ax
        add bx,10h
        add si,4
        loop s2

        mov cx,21
        mov bx,0
        mov si,0
        s3: 
        mov ax,ds:[si+84+84];雇员
        mov es:[bx+0ah],ax
        add bx,10h
        add si,2
        loop s3

        mov cx,21
        mov bx,0
        s4: 
        mov ax,es:[bx+5]
        mov dx,es:[bx+7]
        div word ptr es:[bx+0ah]
        mov es:[bx+0dh],ax
        add bx,10h      
        loop s4

       mov ax,4c00h
        int 21h
codesg ends


end start