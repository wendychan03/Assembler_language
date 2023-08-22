assume cs:code
code segment
        mov dl,0
        mov al,1
        mov cx,20       
    s: add dl,al
       add al,1
        loop s

        mov ax,4c00h
        int 21h

code ends 
end