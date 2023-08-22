assume cs:code
code segment
start:
    ; 测试清屏
    mov ah,0;ah代表要执行第0个
    int 7ch

    ; 测试绿色字
    mov ah,1
    mov al,2
    int 7ch

    ; 测试红底
    mov ah,2
    mov al,4
    int 7ch

    ; 向上滚动一行
    mov ah,3
    int 7ch

    mov ax,4c00h
    int 21h
code ends
end start