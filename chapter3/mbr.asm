; 主引导程序
;-----------------------------------------------
%include "boot.inc"
SECTION MBR vstart=0x7c00

    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov fs, ax
    mov sp, 0x7c00
    mov ax, 0xb800
    mov gs, ax

; 清屏
;---------------------------------------------------
    mov ax, 0600h
    mov bx, 0700h
    mov cx, 0
    mov dx, 184fh
    int 10h

    ; 显示"MBR"
    mov byte [gs:0x00], '1'
    mov byte [gs:0x01], 0xA4

    mov byte [gs:0x02], ' '
    mov byte [gs:0x03], 0xA4

    mov byte [gs:0x04], 'M'
    mov byte [gs:0x05], 0xA4

    mov byte [gs:0x06], 'B'
    mov byte [gs:0x07], 0xA4

    mov byte [gs:0x08], 'R'
    mov byte [gs:0x09], 0xA4

    mov eax, LOADER_START_SECTOR
    mov bx, LOADER_BASE_ADDR
    mov cx, 1
    call rd_disk_m_16

    jmp LOADER_BASE_ADDR

;-----------------------------------------------------------
; 读取磁盘的n个扇区，用于加载loader
; eax保存从硬盘读取到的数据的保存地址，ebx为起始扇区，cx为读取的扇区数
rd_disk_m_16:
;-----------------------------------------------------------

    mov esi, eax
    mov di, cx
    
    ; 读写硬盘：
    ; 第1 步：设置要读取的扇区数
    mov dx, 0x1f2
    mov al, cl  ; cx 原来是 1
    out dx, al

    mov eax, esi

    ; 第2 步：将LBA地址存入Ox1f3－ Ox1f6

    mov dx, 0x1f3
    out dx, al

    mov cl, 8
    shr eax, cl
    mov dx, 0x1f4
    out dx, al

    shr eax, cl
    mov dx, 0x1f5
    out dx, al

    shr eax, cl
    and al, 0x0f
    or al, 0xe0
    mov dx, 0x1f6
    out dx, al

    ; 第3 步：向Ox1f7 端口写入读命令， Ox20

    mov dx, 0x1f7
    mov al, 0x20
    out dx, al

    ; 第4 步：检测硬盘状态
    .not_ready:
        nop
        in al, dx
        and al, 0x88
        cmp al, 0x08
        jnz .not_ready

        ; 第5 步：从Ox1fO 端口读数据, 计算读 512 * di / 2 次
        mov ax, di
        mov dx, 256
        mul dx
        mov cx, ax
        mov dx, 0x1f0

    .go_on_read:
        in ax, dx
        mov [bx], ax
        add bx, 2
        loop .go_on_read
        ret

        times 510-($-$$) db 0
        db 0x55, 0xaa