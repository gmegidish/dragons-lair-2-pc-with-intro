BITS    16
ORG     100h

start:
	; resize our block
	mov ax, 4a00h
	mov dx, cs
	mov es, dx
	mov bx, 1000
	int 21h

	mov ax, 0013h
	int 10h

	; go 320x240
	mov dx, 0x3c4 ; sequence controller
	mov ax, 0x0604
	out dx, ax
	mov ax, 0xff02
	out dx, ax

	mov dx, 0x3d4 ; crt controller
	mov ax, 0x0014
	out dx, ax
	mov ax, 0xe317
	out dx, ax

	mov dx, 0x3c2 ; misc output register
	mov al, 0xe3
	out dx, al

	mov dx, 0x3d4 ; crt controller
	mov ax, 0x2c11
	out dx, ax
	mov ax, 0x0d06
	out dx, ax
	mov ax, 0x3e07
	out dx, ax
	mov ax, 0xea10
	out dx, ax
	mov ax, 0xac11
	out dx, ax
	mov ax, 0xdf12
	out dx, ax
	mov ax, 0xe715
	out dx, ax
	mov ax, 0x0616
	out dx, ax

	; allocate memory for palette
	mov ax, 4800h
	mov bx, 768/16
	int 21h
	jc out
	mov cs:[palette], ax

	; open tga
	mov ax, cs
	mov ds, ax
	lea dx, [filename]
	mov ax, 3d00h
	int 21h
	jc out
	mov [handle], ax

	mov ax, 3f00h
	mov bx, cs:[handle]
	mov cx, 768
	mov dx, cs:[palette]
	mov ds, dx
	xor dx, dx
	int 21h

	call set_palette

loop_frames:
	mov ah, 01h
	int 16h
	jnz out
	
	mov ax, cs:[frame_number]
	cmp ax, 500
	jae done

	; load each plane individually
	xor cx, cx
next_plane:
	cmp cx, 4
	jz no_more_planes

	push cx

	; select plane cl
	mov dx, 0x3c4
	mov ax, 0x0102
	shl ah, cl
	out dx, ax
	
	mov ax, 3f00h
	mov bx, cs:[handle]
	mov cx, 19200 ; 320x240/4
	mov dx, cs:[page]
	mov ds, dx
	xor dx, dx
	int 21h

	pop cx
	inc cx
	jmp next_plane

no_more_planes:
	call vsync
	;call set_palette
	call flip_page
	call sleep

	inc word cs:[frame_number]
	jmp loop_frames

done:
	mov ax, 3e00h
	mov bx, cs:[handle]
	int 21h

	xor ax, ax
	int 16h
out:
	ret

vsync:
	mov dx, 3dah
	in al, dx
	test al, 8
	jz vsync
	ret

vblank:
	mov dx, 3dah
	in al, dx
	test al, 8
	jnz vblank
	ret
	
sleep:
	; reduce to 10 fps, meaning sleep 6 vsyncs
	mov cx, 5
sleep_inner:
	call vsync
	call vblank
	loop sleep_inner
	ret

set_palette:
	mov dx, 3c8h
	xor ax, ax
	out dx, al
	inc dx
	mov ax, cs:[palette]
	mov ds, ax
	xor si, si
	mov cx, 768
	rep outsb
	ret

flip_page:
	mov ax, cs:[page]
	cmp ax, 0xa000
	jz flip_to_page_1
	mov ax, 0xa000
	mov cs:[page], ax
	mov dx, 0x3d4
	mov ax, 0x4b0c
	out dx, ax
	mov ax, 0x000d
	out dx, ax
	ret
flip_to_page_1:
	mov ax, 0xa4b0
	mov cs:[page], ax
	mov dx, 0x3d4
	mov ax, 0x000c
	out dx, ax
	mov ax, 0x000d
	out dx, ax
	ret

filename: db "video.bin", 0
page: dw 0xa4b0
handle: dw 0
frame_number: dw 1
palette: dw 0

