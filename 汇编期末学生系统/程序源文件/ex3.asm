;该系统能自动计算学生的最终成绩，按照平时作业成绩占 40%，大作业 成绩占 60%计算。

;0ah
;缓冲区的第一字节置为缓冲区最大容量；
;缓冲区第二字节存放实际读入的字节数（不包括回车符），
;第三字节开始存放接收的字符串；

assume cs:code,ds:data

data segment
sname db 150, 2, 'wendi$', 'agnes$','kenda$'; 学生姓名每人最多10个字符，每个字符以$结尾。测试10个学生
sid db 150, 3, '1234$', '5678$' ,'5678$'; 学号，最多10个字符，每个字符串以$结尾
scores db 255, 204,'010$', '100$','100$','100$','100$','100$','100$','100$','100$','100$'
    db '100$','100$','100$','100$','100$','100$','100$';学生1
    db '060$','065$','100$','100$','100$','100$','100$','100$','100$','100$'
    db '100$','100$','100$','100$','100$','100$','050$';学生2
    db '061$','062$','063$','060$','100$','100$','100$','100$','100$','100$'
    db '100$','100$','100$','100$','100$','100$','050$';学生3
    db 6 dup('\');每次的成绩3个字符，每个字符串以$结尾
scoresresult db 80, 0, 80 dup('\');从ascii码转化为数字的结果，中间无符号，只最后以\结尾
final db 80, 0,80 dup('\');加权总成绩的ascii,每个字符串以$结尾,最后加上\
finalresult db 80, 0,80 dup('\');加权总成绩的十进制，中间无符号，只最后以\结尾
data ends

code segment
start:
    MOV AX,data     ; 初始化数据段寄存器
    MOV DS,AX

;把每一次的成绩ascii转化为数字
turnToNum:
    ; 初始化寄存器
    mov si,offset scores+2;字符是从第3个字节开始的
    mov di,offset scoresresult+2

convert:

    mov dx,0
    convert_loop:
    ; 将当前字符转化为数字
    mov bl,ds:[si] ; bl= 当前字符的 ASCII 码
    sub bl,'0' ; ASCII码转换为数字

    ;如果当前不是最后一个字符，将面已经转化的数字乘以 10，并加上当前数字,存到dx
    mov ax,0
    mov al,dl
    mov ah,10
    mul ah
    mov dx,ax
    add dl,bl

    ; 检查还有没有下一位
    inc si
    cmp byte ptr ds:[si],'$'
    je convert_done
    jmp convert_loop;继续转化下一位

convert_done:
    mov ds:[di],dl;保存字符串
    add di,1;只有最后的数字以'\'结尾
    add si,1
    ;一个字符串已经转化完成并保存，查看后面有没有字符串
    cmp byte ptr ds:[si],'\'
    je finalscore
    jne convert;非'\'说明后面还有字符要继续转化


;计算最终成绩
;循环16次，计算平时成绩，总平时成绩乘以4
;加上大作业成绩乘以6，再总体除以10
finalscore:
    ; 初始化寄存器
    mov si,offset scoresresult+2;每次的成绩
    mov di,offset finalresult+2;加权总成绩的十进制
    
    onefinal:
        mov ax,0
        mov bx,0
        mov cx,0
        mov dx,0

        mov cx,16;计算平时成绩，存储在bx中
        normal:
            mov ax,0
            mov al,byte ptr ds:[si]
            add bx,ax
            inc si
        loop normal
        ;平时成绩在bx
        mov ax,bx;总平时成绩除以16
        mov cl,16
        div cl
        mov bx,0
        mov bl,al

        mov ax,bx;平时成绩乘以4
        mov cx,4
        mul cx
        mov bx,ax
        
        mov ax,0;计算大作业成绩
        mov al,byte ptr ds:[si];取出期末成绩
        mov cx,6;期末成绩乘以6
        mul cx
        add bx,ax;加入bx
        
        mov ax,bx;总成绩除以10
        mov cx,10
        div cx
        mov byte ptr ds:[di],al
    inc di
    inc si
    cmp byte ptr ds:[si],'\'
    jne onefinal;非'\'说明后面还有学生的最终成绩要计算
    

;用余数把3位十进制数转化为ascii
mov di,offset finalresult+2
mov si,offset final+2
ToAscii:
    ToAsciibegin: 
        mov ax,0
        mov al,byte ptr ds:[di]
        mov cl,100
        div cl
        add al,'0';商al即为百位的值，加上‘0’变成ascii码值
        mov byte ptr ds:[si],al
        inc si
        mov al,ah;继续用余数ah
        mov ah,0
        mov cl,10
        div cl
        add al,'0';商al即为十位的值，加上‘0’变成ascii码值
        mov byte ptr ds:[si],al
        inc si
        add ah,'0';余数ah即为个位的值，加上‘0’变成ascii码值
        mov byte ptr ds:[si],ah
    inc si
    mov byte ptr ds:[si],'$';以保证每条字符串后面跟'$'
    inc si
    ; 检查还有没有下一个要转化的3位十进制数
    inc di

    cmp byte ptr ds:[di],'\'
    je ToAsciiend
    jne ToAsciibegin
    ToAsciiend:
    mov byte ptr ds:[si],'\'
    
    ; pop di
    ; pop si

printfinal:

    MOV AX, data     ; 初始化数据段寄存器
    MOV DS, AX
    mov dx,offset final+2
    mov ah,9h
    int 21h
    printall:
    add dx,4
    mov si,dx
    cmp byte ptr ds:[si],'\'
    je ok


    mov dl,' '
    mov ah,2;int 21h的2号功能调用（显示输出）
    int 21h ;显示回车

    mov dx,si
    mov ah,9h
    int 21h
    jmp printall

ok:
    MOV AH, 4CH      
    INT 21H 
code ends
end start