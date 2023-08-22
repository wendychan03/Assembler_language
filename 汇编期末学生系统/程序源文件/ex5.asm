;排序

assume cs:code,ds:data
data segment

    T DB '  welcome,please chose your requirement', '$'
    LINE DB '+------------------------------------------------+', '$'
    LABEL1 DB '| 1. Information input                         |', '$'
    LABEL2 DB '| 2. Query                                     |', '$'
    LABEL3 DB '| 3. Final grade sorting                       |', '$'
    LABEL4 DB '| 4. Display of score statistics information   |', '$'
    LINE2 DB '+------------------------------------------------+', '$'
LABEL5 DB '    name: ', '$'
LABEL6 DB '    ID: ', '$'
LABEL7 DB 'scores: ', '$'
LABEL8 DB '    final: ', '$'
LABEL9 DB '    rank: ', '$'
BLANK DB '        ', '$'
longLINE DB '+-----------------------------------------------------------------------+', '$'


sname db 255, 18, 'wendi$', 'agnes$','kenda$','ddddd$','eeeee$'
    db 'fffff$','ggggg$','hhhhh$','jjjjj$','kkkkk$',1 dup('\'); 学生姓名每人5个字符，每个字符以$结尾。测试10个学生
sid db 255, 0, '11111$', '22222$' ,'33333$','44444$','55555$'
    db '66666$','77777$','88888$','99999$','00000$',1 dup('\'); 学号，5个字符，每个字符串以$结尾
scores db 255, 0,255 dup('\');每次的成绩3个字符，每个字符串以$结尾 17*10*4
scoresresult db 255, 0,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100;1
    db 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100;2
    db 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100;3
    db 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100;4
    db 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100;5
    db 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100;6
    db 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100;7
    db 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100;8
    db 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100;9
    db 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,5 dup('\');10
    ;从ascii码转化为数字的结果，中间无符号，只最后以\结尾
final db 80, 12,'100$','097$','096$','095$','094$','093$','092$','091$','099$','100$',1 dup('$');加权总成绩的ascii,每个字符串以$结尾,最后加上\
finalresult db 20,0,100,97,96,95,94,93,92,91,99,100,1 dup('\');加权总成绩的十进制，中间无符号，只最后以\结尾
;rank db 40, 0, 40 dup('$')
rankresult db 20,10,01,02,03,04,05,06,07,08,09,10,10 dup('\')
srankresult db 20,0,20 dup('\')
srank db 255,0,20 dup('\')

data ends
code segment
start:

mov ax,data
mov ds,ax
call studentrank

;在srank写上每个学生的排名
mov si,offset rankresult+2
mov di,offset srankresult+2
mov al,1
mov cx,10
sranking:
mov bx,0
mov bl,ds:[si] 
sub bl,1
mov ds:[di+bx],al
inc al
inc si
loop sranking

;2位十进制数转化为ascii
mov di,offset srankresult+2
mov si,offset srank+2
ToAscii:
    ToAsciibegin: 
        mov ax,0
        mov al,byte ptr ds:[di]
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

; printfinal:
;     mov dx,offset rank+2
;     mov ah,9h
;     int 21h
;     printall:
;     add dx,3
;     mov si,dx
;     cmp byte ptr ds:[si],'\'
;     je ok

;     mov dl,' '
;     mov ah,2;int 21h的2号功能调用（显示输出）
;     int 21h ;显示回车

;     mov dx,si
;     mov ah,9h
;     int 21h
;     jmp printall

mov cx,10
mov si,offset rankresult+2
printrankinfo:
    mov bx,0
    mov bl,ds:[si]
    call onestuscore
    call printinfo
    inc si
loop printrankinfo


ok:
    MOV AH, 4CH      
    INT 21H 
;+++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++
studentrank:
    mov si,offset finalresult+2
    mov di,offset rankresult+2
    mov cx,10
    ranking:
    mov bx,0;bx最大为8
    mov dx,cx
    sub dx,1
    rank1:
        mov ax,0
        mov al,ds:[si+bx]
        cmp al,ds:[si+bx+1]
        jb next;小于则不交换，排序由大到小
        mov ah,ds:[si+bx+1];交换成绩
        mov ds:[si+bx+1],al;交换成绩
        mov ds:[si+bx],ah;交换成绩
        mov ax,0
        mov al,ds:[di+bx]
        mov ah,ds:[di+bx+1];交换序号
        mov ds:[di+bx+1],al;交换序号
        mov ds:[di+bx],ah;交换序号
        next:
        inc bx
        sub dx,1
        cmp dx,0
        je rankend
        jne rank1
    rankend:
    sub cx,1
    cmp cx,1
    jne ranking
ret
; ;输出学生信息，bl代表着第几个学生
printinfo:
push ax
push bx
push cx
push dx
push si
push di
sturank2:
    mov dx,offset LABEL9
    mov ah,9
    int 21h
        mov ax,0
        mov dx,offset srank+2
        mov al,bl
        sub al,1
        mov cl,3
        mul cl
        add dx,ax
        mov ah,9h
        int 21h
    stuname:
    mov dx,offset LABEL5
    mov ah,9
    int 21h
        mov dx,offset sname+2
        mov al,bl
        sub al,1
        mov cl,6
        mul cl
        add dx,ax
        mov ah,9h
        int 21h
    stuid:
    mov dx,offset LABEL6
    mov ah,9
    int 21h
        mov dx,offset sid+2
        mov al,bl
        sub al,1
        mov cl,6
        mul cl
        add dx,ax
        mov ah,9h
        int 21h
    stufinal:
    mov dx,offset LABEL8
    mov ah,9
    int 21h
        mov dx,offset final+2
        mov al,bl
        sub al,1
        mov cl,4
        mul cl
        add dx,ax
        mov ah,9h
        int 21h
    call anotherline
    stuscores:
    mov dx,offset LABEL7
    mov ah,9
    int 21h
        mov dx,offset scores+2
        mov cx,17
        printallscore1:
            mov ah,9h
            int 21h
            add dx,4
            push dx
            mov dl,' '
            mov ah,2;int 21h的2号功能调用（显示输出）
            int 21h ;显示回车
            pop dx
        loop printallscore1
call anotherline
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret


;读取一位学生的17次成绩，转换成ascii码，写入score
onestuscore:
push ax
push bx
push cx
push dx
push si
push di
    mov di,offset scoresresult+2
    mov al,bl
    sub al,1
    mov cl,17
    mul cl
    add di,ax;di
    mov si,offset scores+2;si
    mov cx,17
    scoreAsciibegin: 
    push cx
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
    inc di
    pop cx
    loop scoreAsciibegin
    scoreAsciiend:
    mov byte ptr ds:[si],'\'
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

mov ah,4CH
int 21H

code ends
end start
