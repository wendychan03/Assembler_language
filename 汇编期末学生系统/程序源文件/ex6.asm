;分数统计信息显示：各个总成绩分数段的人数、平均分、最高分、最低分
;90-100一个分数段；80-89一个分数段；60-79一个分数段；60以下一个分数段。
assume cs:code,ds:data
data segment
HIGHTEST DB '  highest score: ', '$'
LOWEST DB '  lowest score: ', '$'
AVERAGE DB '  average score: ', '$'
scoreinfo DB '  highest score: ', '$','  lowest score: ', '$','  average score: ', '$'
    DB '  90-100: ', '$','  80-89: ', '$','  60-79: ', '$','  0-60: ', '$',1 dup('|')


sname db 255, 18, 'wendi$', 'agnes$','kenda$','ddddd$','eeeee$'
    db 'fffff$','ggggg$','hhhhh$','jjjjj$','kkkkk$',1 dup('|'); 学生姓名每人5个字符，每个字符以$结尾。测试10个学生
sid db 255, 0, '11111$', '22222$' ,'33333$','44444$','55555$'
    db '66666$','77777$','88888$','99999$','00000$',1 dup('|'); 学号，5个字符，每个字符串以$结尾
scores db 255, 0,255 dup('|');每次的成绩3个字符，每个字符串以$结尾 17*10*4
scoresresult db 255, 0,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100;1
    db 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100;2
    db 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100;3
    db 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100;4
    db 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100;5
    db 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100;6
    db 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100;7
    db 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100;8
    db 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100;9
    db 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,5 dup('|');10
    ;从ascii码转化为数字的结果，中间无符号，只最后以\结尾
final db 80, 12,'100$','097$','096$','095$','094$','093$','092$','091$','099$','100$',1 dup('$');加权总成绩的ascii,每个字符串以$结尾,最后加上\
finalresult db 20,0,100,97,96,95,94,93,92,75,65,55,1 dup('|');加权总成绩的十进制，中间无符号，只最后以\结尾
;rank db 40, 0, 40 dup('$')
rankresult db 20,10,01,02,03,04,05,06,07,08,09,10,10 dup('|')
srankresult db 20,0,20 dup('|')
srank db 255,0,20 dup('|')
hla4result db 20,0,20 dup('|');hla:high low average 4 segment
hla4 db 255,0,255 dup('|');hla:high low average 4 segment

data ends

code segment
start:
mov ax,data
mov ds,ax
;得到最高分最低分
call HighandLow
call stuaverage
call statistics
mov di,offset hla4result+2
mov si,offset hla4+2
call ToAscii

printhla:
; mov dx,offset HIGHTEST
; mov ah,9h
; int 21h
;     mov dx,offset hla4+2
;     mov ah,9h
;     int 21h
; call anotherline
; mov dx,offset LOWEST
; mov ah,9h
; int 21h
;     mov dx,offset hla4+6
;     mov ah,9h
;     int 21h
; call anotherline
; mov dx,offset AVERAGE
; mov ah,9h
; int 21h
;     mov dx,offset hla4+10
;     mov ah,9h
;     int 21h

mov si,offset scoreinfo
mov di,offset hla4+2
mov cx,7;有7个东西要打印
    showinfoname:
        mov dx,si
        mov ah,9h
        int 21h
            nextinfoname:
            inc si
            cmp byte ptr ds:[si],'$'
            je showhla
            jmp nextinfoname
        showhla:
        inc si;这样下次又可以打印score info
        mov dx,di
        mov ah,9h
        int 21h
        add di,4
        call anotherline
    loop showinfoname



ok:
    MOV AH, 4CH      
    INT 21H 
;========================================
HighandLow:
push ax
push bx
push cx
push dx
push si
push di
    mov si,offset finalresult+2
    mov di,offset hla4result+2
    mov cx,9;10个数只需比9次
    mov bx,1
    mov ax,0
    mov al,ds:[si]
    rankhigh:
        cmp al,ds:[si+bx]
        ja next1;al大则不交换，保留大的数在al
        mov al,ds:[si+bx]
        next1:inc bx
    loop rankhigh
    mov ds:[di],al;存入hla
    inc di
    mov cx,9
    mov bx,1
    mov ax,0
    mov al,ds:[si]
    ranklow:
        cmp al,ds:[si+bx]
        jb next2;al小则不交换，保留小的数在al
        mov al,ds:[si+bx]
        next2:inc bx
    loop ranklow
    mov ds:[di],al;存入hla
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret

stuaverage:
push ax
push bx
push cx
push dx
push si
push di
mov ax,data
mov ds,ax
    ; 初始化寄存器
    mov si,offset finalresult+2;所有学生的最终成绩
    mov di,offset hla4result+4;平均成绩
        mov cx,10;平均成绩总和存储在bx中
        average1:
            mov ax,0
            mov al,ds:[si]
            add bx,ax
            inc si
        loop average1
        ;平时成绩在bx
        mov ax,bx;总平时成绩除以10
        mov cl,10
        div cl
        ;al为商，是平均成绩
        mov ds:[di],al
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret


statistics:
push ax
push bx
push cx
push dx
push si
push di
mov ax,data
mov ds,ax
    ; 初始化寄存器
    mov si,offset finalresult+2;所有学生的最终成绩
    mov di,offset hla4result+5;保存4个分数段的人数
    mov byte ptr ds:[di],0
    inc di
    mov byte ptr ds:[di],0
    inc di
    mov byte ptr ds:[di],0
    inc di
    mov byte ptr ds:[di],0
    mov di,offset hla4result+5
        mov cx,10
        statistics1:
            mov ax,0
            mov al,ds:[si]
            cmp al,90;100-90
            jb nextseg1;如果小于，比较下一个分数段
            add byte ptr ds:[di],1
            jmp statisticsend;如果大于，加1后结束该成绩的比较
            nextseg1:
            mov al,ds:[si]
            cmp al,80;89-80
            jb nextseg2
            add byte ptr ds:[di+1],1
            jmp statisticsend
            nextseg2:
            mov al,ds:[si]
            cmp al,60;79-60
            jb nextseg3
            add byte ptr ds:[di+2],1
            jmp statisticsend
            nextseg3:
            add byte ptr ds:[di+3],1
            statisticsend:
            inc si
        loop statistics1
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret

;用余数把3位十进制数转化为ascii
; mov di,offset finalresult+2
; mov si,offset final+2
ToAscii:
push ax
push bx
push cx
push dx
push si
push di
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
    cmp byte ptr ds:[di],'|'
    je ToAsciiend
    jne ToAsciibegin
    ToAsciiend:
    mov byte ptr ds:[si],'|'
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret

anotherline:;换行
    push dx
    push ax
    mov dl,0dh;回车键的ASCII码是0dh
    mov ah,2;int 21h的2号功能调用（显示输出）
    int 21h ;显示回车
    mov dl,0ah
	int 21h ;显示换行
    pop ax
    pop dx
    ret


code ends
end start