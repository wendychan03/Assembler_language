;信息录入包括:学生的姓名、学号、及 16 次作业成绩和一次大作业成 绩。(通过键盘输入)

assume cs:code,ds:data
data segment
msg1 db 'Please input student name(must be 5 charaters): $'
msg2 db 'Please input student ID(must be 5 charaters): $'
msg3 db 'Please input the scores as xxx(16 homework scores): $'
msg4 db 'Please input the score as xxx(1 final project score): $'

sname db 255, 0, 255 dup('$'); 学生姓名每人5个字符，每个字符以$结尾。测试10个学生
sid db 255, 0, 255 dup('$'); 学号，5个字符，每个字符串以$结尾
scores db 255, 0, 255 dup('|');每次的成绩3个字符，每个字符串以$结尾 
scoresresult db 255,0,255 dup('|')
final db 255, 0, 255 dup('$');加权总成绩的ascii,每个字符串以$结尾,最后加上\
finalresult db 255,0,255 dup('|');加权总成绩的十进制，中间无符号，只最后以\结尾
rankresult db 255,0,255 dup('|')
srankresult db 255,0,255 dup('|')
srank db 255,0,20 dup('|')
hla4result db 255,0,255 dup('|');hla:high low average 4 segment
hla4 db 255,0,255 dup('|');hla:high low average 4 segment

data ends

code segment
start:
inputinfo:
    MOV AX, data ; 初始化数据段寄存器
    MOV DS, AX
    mov dx,offset msg1;Please enter student name
    mov ah,9h
    int 21h
    mov dx,offset sname;这里不要加2，它会自己从第三字节开始写入的
	mov ah,0ah;读字符串
	int 21h
call anotherline
    mov dx,offset msg2;Please enter student id
    mov ah,9h
    int 21h
    mov dx,offset sid
	mov ah,0ah;读字符串
	int 21h
call anotherline
    mov dx,offset msg3;Please enter student scores
    mov ah,9h
    int 21h
    ;16次作业
    mov cx, 16
    mov dx,offset scores+2
    lea si,scores+2
input_scores1:
;由于使用mov ah, 0ah会重叠在同一行所以使用01h
    mov ah, 01h
    int 21h
    mov ds:[si], al ; 将输入字符保存到数组中
    inc si
    mov ah, 01h
    int 21h
    mov ds:[si], al ; 将输入字符保存到数组中
    inc si
    mov ah, 01h
    int 21h
    mov ds:[si], al ; 将输入字符保存到数组中
    inc si
    mov byte ptr ds:[si], '$' 
    inc si
        cmp cx,1
        je input_scores1end;为了最后一次没有逗号
        mov ah, 02h;每次作业以逗号隔开
        mov dl, ','
        int 21h
loop input_scores1
input_scores1end:nop
call anotherline
    mov dx,offset msg4;Please enter student final
    mov ah,9h
    int 21h
    mov ah, 01h;继续用上面的ds:si
    int 21h
    mov ds:[si], al ; 将输入字符保存到数组中
    inc si
    mov ah, 01h
    int 21h
    mov ds:[si], al ; 将输入字符保存到数组中
    inc si
    mov ah, 01h
    int 21h
    mov ds:[si], al ; 将输入字符保存到数组中
    inc si
    mov byte ptr ds:[si], '$' 
    inc si
mov byte ptr ds:[si],'|'
inc si

call anotherline
;++++++++++++输出++++++++++

    mov si,offset scores+2;字符是从第3个字节开始的
    mov di,offset scoresresult+2
call convertscoretonum
    mov si,offset scoresresult+2
    mov di,offset scores+2
call convertscoreToAscii
    MOV AX, data
    MOV DS, AX
; 输出学生信息和成绩
    mov dx,offset sname+2
    mov ah, 09h
    int 21h
call anotherline   
    mov dx,offset sid+2
    mov ah, 09h
    int 21h
; call anotherline
;     mov dx,offset scores+2
;     mov ah, 09h
;     int 21h
; call anotherline
;     mov dx,offset scores+6
;     mov ah, 09h
;     int 21h
; call anotherline
;     mov dx,offset scores+10
;     mov ah, 09h
;     int 21h
call anotherline
mov dx,offset scores+2
mov cx,17
printall:
    mov ah,9h
    int 21h
push dx
    mov dl,' '
    mov ah,2;int 21h的2号功能调用（显示输出）
    int 21h ;显示回车
pop dx
add dx,4
loop printall



    MOV AH, 4CH        ; 设置程序结束功能号
    INT 21H            ; 结束程序

;===================================
;=================函数===============
;===================================
    anotherline:;换行
        mov dl,0dh;回车键的ASCII码是0dh
        mov ah,2;int 21h的2号功能调用（显示输出）
        int 21h ;显示回车
        mov dl,0ah
	    int 21h ;显示换行
        ret

;将所有成绩的ascii转化为数字
    ; mov si,offset scores+2;字符是从第3个字节开始的
    ; mov di,offset scoresresult+2
convertscoretonum:
push ax
push bx
push cx
push dx
push si
push di
convertnumbegin:
    mov dx,0
    convertnum_loop:
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
        je convertnum_done
        jmp convertnum_loop;继续转化下一位
    convertnum_done:
    mov ds:[di],dl;保存字符串
    add di,1
    add si,1
    ;一个字符串已经转化完成并保存，查看后面有没有字符串
    cmp byte ptr ds:[si],'|'
    jne convertnumbegin;非'|'说明后面还有字符要继续转化   
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret

;用余数把3位十进制数成绩转化为ascii
; mov si,offset finalresult+2
; mov di,offset final+2
convertscoreToAscii:
push ax
push bx
push cx
push dx
push si
push di
mov cx,17
    convertscoreToAsciibegin: 
    push cx
        mov ax,0
        mov al,byte ptr ds:[si]
        mov cl,100
        div cl
        add al,'0';商al即为百位的值，加上‘0’变成ascii码值
        mov byte ptr ds:[di],al
        inc di
        mov al,ah;继续用余数ah
        mov ah,0
        mov cl,10
        div cl
        add al,'0';商al即为十位的值，加上‘0’变成ascii码值
        mov byte ptr ds:[di],al
        inc di
        add ah,'0';余数ah即为个位的值，加上‘0’变成ascii码值
        mov byte ptr ds:[di],ah
    inc di
    mov byte ptr ds:[di],'$';以保证每条字符串后面跟'$'
    inc di
    ; 检查还有没有下一个要转化的3位十进制数
    inc si
    pop cx
    loop convertscoreToAsciibegin
pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret

code ends
end start