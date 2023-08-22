;查询功能，询问按姓名还是学号查询
assume cs:code,ds:data
data segment
    T DB '  welcome,please chose your requirement', '$'
    LINE DB '+------------------------------------------------+', '$'
    LABEL1 DB '| 1. Information input                         |', '$'
    LABEL2 DB '| 2. Query                                     |', '$'
    LABEL3 DB '| 3. Final grade sorting                       |', '$'
    LABEL4 DB '| 4. Display of score statistics information   |', '$'
    LINE2 DB '+------------------------------------------------+', '$'
LABEL5 DB '   1. student name: ', '$'
LABEL6 DB '   2. student ID: ', '$'
LABEL7 DB '   3. student scores(17 times): ', '$'
LABEL8 DB '   4. student final: ', '$'
LABEL9 DB '   5. student rank: ', '$'
BLANK DB '        ', '$'

msg1 db 'Search by name(input 1) or by student ID(input 2):', '$'
msg2 db 'Please input name(5 characters):', '$'
msg3 db 'Please input student ID(5 characters):', '$'
msg4 db 'There is no this student', '$'
buf db 20,0,20 dup('$');缓存
sname db 150, 18, 'wendi$', 'agnes$','kenda$',132 dup('\'); 学生姓名每人5个字符，每个字符以$结尾。测试10个学生
sid db 150, 0, '11111$', '22222$' ,'33333$',132 dup('\'); 学号，5个字符，每个字符串以$结尾
scores db 151, 51,'100$', '100$','100$','100$','100$','100$','100$','100$','100$','100$'
    db '100$','100$','100$','100$','100$','100$','060$'
    db '100$', '100$','100$','100$','100$','100$','100$','100$','100$','100$'
    db '100$','100$','100$','100$','100$','100$','060$';学生2
    db '100$', '100$','100$','100$','100$','100$','100$','100$','100$','100$'
    db '100$','100$','100$','100$','100$','100$','030$';学生3
    db 100 dup('\');每次的成绩3个字符，每个字符串以$结尾 17*10*4
scoresresult db 80, 0, 80 dup('\');从ascii码转化为数字的结果，中间无符号，只最后以\结尾
final db 80, 12,'097$','068$','066$', 68 dup('$');加权总成绩的ascii,每个字符串以$结尾,最后加上\
finalresult db 80, 0,80 dup('\');加权总成绩的十进制，中间无符号，只最后以\结尾
rank db 80, 6,'01$','02$','03$',74 dup('$')
data ends

code segment
start:
mov ax,data
mov ds,ax
mov es,ax
Searchchose:
    mov dx,offset msg1;询问'Search by name or by student ID:'
    mov ah,9
    int 21h
    mov ah,1
    int 21h
    mov bl,al;al内存储的是接收的字符
    call anotherline
    cmp bl,'1'
    je byname
    cmp bl,'2'
    je byid
    
byname:
    mov dx,offset msg2;'Please input name(1-10characters):'
    mov ah,9
    int 21h
    mov dx,offset buf;一定要注意！不要buf+2，它会自动存到第3字节的
    mov ah,0ah
    int 21h
    mov ax,data
    mov es,ax
    mov bl,0;作为计数器，方便定位名字
    mov di,offset buf+2
    mov si,offset sname+2

    findbyname:
        mov di,offset buf+2
        inc bl
        mov cx,4;姓名字长为5
        CLD ;增地址方向
        repz cmpsb
        jnz istherenext
        jz printfind;若所有字符都相同
 
        istherenext:
            mov si,offset sname+2
            mov al,bl
            mov ah,6;含'$'是6个字符
            mul ah
            add si,ax         
            cmp byte ptr ds:[si],'\';说明后面没有名字了
            je notfindname
            jne findbyname
            notfindname:
                call anotherline
                mov dx,offset msg4;'There is no this student'
                mov ah,9
                int 21h
                jmp ok
        printfind:
        call anotherline
            ; mov dx,offset msg1
            ; mov ah,9
            ; int 21h
        call printinfo
    jmp ok

byid:
    mov dx,offset msg3;'Please input student ID(1-10 characters):'
    mov ah,9
    int 21h
    mov dx,offset buf;一定要注意！不要buf+2，它会自动存到第3字节的
    mov ah,0ah
    int 21h

    mov ax,data
    mov es,ax
    mov bl,0;作为计数器，方便定位名字
    mov di,offset buf+2
    mov si,offset sid+2

    findbyid:
        mov di,offset buf+2
        inc bl
        mov cx,4;id字长为5
        CLD ;增地址方向
        repz cmpsb
        jnz istherenext2
        jz printfind2;若所有字符都相同
 
        istherenext2:
            mov si,offset sid+2
            mov al,bl
            mov ah,6;含'$'是6个字符
            mul ah
            add si,ax         
            cmp byte ptr ds:[si],'\';说明后面没有名字了
            je notfindid
            jne findbyid
            notfindid:
                call anotherline
                mov dx,offset msg4;'There is no this student'
                mov ah,9
                int 21h
                jmp ok
        printfind2:
        call anotherline
        call printinfo
    jmp ok

ok:
    MOV AH, 4CH      
    INT 21H 
;++++++++++++++++++++++++++++++++++++

;输出学生信息，bl代表着第几个学生
printinfo:
mov ax,data
mov ds,ax
mov dx,offset LINE
mov ah,9
int 21h
call anotherline
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
    call anotherline
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
    call anotherline
    ;后面要增加一个ex3里面的数字转字符串
    stuscores:
    mov dx,offset LABEL7
    mov ah,9
    int 21h
    call anotherline
        mov dx,offset scores+2
        mov al,bl
        sub al,1
        mov cl,4*17
        mul cl
        add dx,ax
    push dx
    mov dx,offset BLANK
    mov ah,9
    int 21h
    pop dx
        mov cx,9
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
    push dx
    mov dx,offset BLANK
    mov ah,9
    int 21h
    pop dx
        mov cx,8
        printallscore2:
            mov ah,9h
            int 21h
            add dx,4
            push dx
            mov dl,' '
            mov ah,2;int 21h的2号功能调用（显示输出）
            int 21h ;显示回车
            pop dx
        loop printallscore2
    call anotherline
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
    sturank:
    mov dx,offset LABEL9
    mov ah,9
    int 21h
        mov dx,offset rank+2
        mov al,bl
        sub al,1
        mov cl,3
        mul cl
        add dx,ax
        mov ah,9h
        int 21h
call anotherline
mov dx,offset LINE2
mov ah,9
int 21h
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