;绘制系统界面

assume cs:code,ds:data
data segment
    T DB '  welcome,please chose your requirement(input number)', '$'
    LINE DB '+------------------------------------------------+', '$'
    LABEL1 DB '| 1. Information input                         |', '$'
    LABEL2 DB '| 2. Query                                     |', '$'
    LABEL3 DB '| 3. Final grade sorting                       |', '$'
    LABEL4 DB '| 4. Display of score statistics information   |', '$'
    LINE2 DB '+------------------------------------------------+', '$'
data ends

code segment
start:
        mov ax, data
        mov ds,ax
        
        mov dx,offset T;ds:dx=需要输出字符串的首地址，字符串以’$’为结束标志。
        mov ah,9;int 21h的9号功能调用（显示字符串）
        int 21H
        call anotherline
        mov dx,offset LINE 
        mov ah,9
        int 21H
        call anotherline
        mov dx,offset LABEL1
        mov ah,9
        int 21H
        call anotherline
        mov dx,offset LABEL2
        mov ah,9
        int 21H
        call anotherline
        mov dx,offset LABEL3
        mov ah,9
        int 21H
        call anotherline
        mov dx,offset LABEL4
        mov ah,9
        int 21H
        call anotherline
        mov dx,offset LINE2
        mov ah,9
        int 21H
        call anotherline

        MOV AH, 01H
        INT 21H
        ; 处理用户输入
        CMP AL, '1'
        JE INPUT
        CMP AL, '2'
        JE QUERY
        CMP AL, '3'
        JE SORT
        CMP AL, '4'
        JE STAT
        JMP EXIT

        EXIT:
        MOV AH, 4CH
        INT 21H

 ;+++++++++++++++++++++++++++++++++++++++++++++++++
    anotherline:;换行
        mov dl,0dh;回车键的ASCII码是0dh
        mov ah,2;int 21h的2号功能调用（显示输出）
        int 21h ;显示回车
        mov dl,0ah
	int 21h ;显示换行
        ret


    INPUT:
        ; 跳转到信息录入程序
        JMP EXIT
    QUERY:
        ; 跳转到成绩查询程序
        JMP EXIT
    SORT:
        ; 跳转到成绩排序程序
        JMP EXIT
    STAT:
        ; 跳转到成绩统计程序
        JMP EXIT
    

code ends
end start