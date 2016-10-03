;;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;; packing + skipping
;;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;;:::
;; 8...8...8...-> 332 + maskTb checking
;;  in: es:si-> source
;;	ds-> DGROUP
;;	cx= pixels
b8_pack_skip	proc	near
		pusha
		push	ds

		mov	ax, TFXGRP
		mov	ds, ax
		assume	ds:TFXGRP
		
		xor	si, si			;; i= 0
		
		;; align on word boundary
		test	di, 1
		jz	@F			;; aligned?
		mov	al, srcMask[si]
		inc	si
		dec	cx
		test	al, al		
		lea	di, [di + 1]
		jnz	@F
		mov	al, srcRed[si-1]
		and	al, 11100000b
		mov	dl, srcGreen[si-1]
		shr	dl, 3
		mov	bl, srcBlue[si-1]
		shr	bl, 6
		and	dl, 00011100b
		and	bl, 00000011b
		or	al, dl
		or	al, bl
		mov	es:[di-1], al
		
@@:		push	cx			;; (0)
		shr	cx, 1			;; / 2
		jz	@@rem			;; < 2?

		;; 10 clocks p/ 2 pixels (5 p/ pixel)
@@loop:		mov	ax, srcMask[si]
		add	si, 2

		test	al, al
		jnz	@@chk1
		
		test	ah, ah
		jnz	@@set0
		
		mov	ax, srcRed[si-2]
		add	di, 2
		
		and	ax, 1110000011100000b
		mov	dx, srcGreen[si-2]
		
		shr	dx, 3
		mov	bx, srcBlue[si-2]
		
		shr	bx, 6
		and	dx, 0001110000011100b
		
		and	bx, 0000001100000011b
		or	ax, dx
		
		or	ax, bx		
		dec	cx
		
		mov	es:[di-2], ax
		jnz	@@loop

		;; remainder
@@rem:		pop	cx			;; (0)
		and	cx, 1
		jz	@@exit
		mov	al, srcMask[si]
		test	al, al
		jnz	@@exit
		mov	al, srcRed[si]
		and	al, 11100000b
		mov	dl, srcGreen[si]
		shr	dl, 3
		mov	bl, srcBlue[si]
		shr	bl, 6
		and	dl, 00011100b
		and	bl, 00000011b
		or	al, dl
		or	al, bl
		mov	es:[di], al
		
@@exit:		pop	ds
		assume	ds:DGROUP
		popa
		ret

@@chk1:		test	ah, ah
		jnz	@F
		mov	al, srcRed[si-2+1]		
		and	al, 11100000b
		mov	dl, srcGreen[si-2+1]
		shr	dl, 3
		mov	bl, srcBlue[si-2+1]
		shr	bl, 6
		and	dl, 00011100b
		and	bl, 00000011b
		or	al, dl
		or	al, bl
		mov	es:[di+1], al
@@:		add	di, 2
		dec	cx
		jnz	@@loop
		jmp	short @@rem

@@set0:		mov	al, srcRed[si-2]
		add	di, 2
		and	al, 11100000b
		mov	dl, srcGreen[si-2]
		shr	dl, 3
		mov	bl, srcBlue[si-2]
		shr	bl, 6
		and	dl, 00011100b
		and	bl, 00000011b
		or	al, dl
		or	al, bl
		dec	cx
		mov	es:[di-2], al
		jnz	@@loop
		jmp	short @@rem
b8_pack_skip	endp

;;:::
;; 8...8...8...-> 1555 + maskTb checking
;;  in: es:si-> source
;;	ds-> DGROUP
;;	cx= pixels
b15_pack_skip	proc	near
		pusha
		push	ds

		mov	ax, TFXGRP
		mov	ds, ax
		assume	ds:TFXGRP
		
		xor	si, si			;; i= 0
		
		;; align on dword boundary
		test	di, 10b
		jz	@F			;; aligned?
		mov	al, srcMask[si]
		inc	si
		dec	cx
		test	al, al		
		lea	di, [di + 2]
		jnz	@F
		movsx	ax, srcRed[si-1]
		shl	ax, 7
		movsx	dx, srcGreen[si-1]
		shl	dx, 3
		movsx	bx, srcBlue[si-1]
		and	ax, 0111110000000000b
		and	dx, 0000001111100000b
		and	bx, 0000000000011111b
		or	ax, dx
		or	ax, bx
		mov	es:[di-2], ax
		
@@:		push	cx			;; (0)
		shr	cx, 1			;; / 2
		jz	@@rem			;; < 2?

		;; 10 clocks p/ 2 pixels (5 p/ pixel)
@@loop:		mov	ax, srcMask[si]
		add	si, 2

		test	al, al
		jnz	@@chk1
		
		test	ah, ah
		jnz	@@set0
		
		.... .... .... .... .... .... .... .... .... .... ....
		mov	ax, srcRed[si-2]
		add	di, 4
		
		and	ax, 1110000011100000b
		mov	dx, srcGreen[si-2]
		
		shr	dx, 3
		mov	bx, srcBlue[si-2]
		
		shr	bx, 6
		and	dx, 0001110000011100b
		
		and	bx, 0000001100000011b
		or	ax, dx
		
		or	ax, bx		
		dec	cx
		.... .... .... .... .... .... .... .... .... .... ....
		
		mov	es:[di-4], eax
		jnz	@@loop

		;; remainder
@@rem:		pop	cx			;; (0)
		and	cx, 1
		jz	@@exit
		mov	al, srcMask[si]
		test	al, al
		jnz	@@exit
		movsx	ax, srcRed[si]
		shl	ax, 7
		movsx	dx, srcGreen[si]
		shl	dx, 3
		movsx	bx, srcBlue[si]
		and	ax, 0111110000000000b
		and	dx, 0000001111100000b
		and	bx, 0000000000011111b
		or	ax, dx
		or	ax, bx
		mov	es:[di], ax
		
@@exit:		pop	ds
		assume	ds:DGROUP
		popa
		ret

@@chk1:		test	ah, ah
		jz	@F
		movsx	ax, srcRed[si-2+1]
		shl	ax, 7
		movsx	dx, srcGreen[si-2+1]
		shl	dx, 3
		movsx	bx, srcBlue[si-2+1]		
		and	ax, 0111110000000000b
		and	dx, 0000001111100000b
		and	bx, 0000000000011111b
		or	ax, dx
		or	ax, bx
		mov	es:[di+2], ax
@@:		add	di, 4
		dec	cx
		jnz	@@loop
		jmp	short @@rem

@@set0:		movsx	ax, srcRed[si-2]
		add	di, 4
		shl	ax, 7
		movsx	dx, srcGreen[si-2]		
		shl	dx, 3
		movsx	bx, srcBlue[si-2]		
		and	ax, 0111110000000000b
		and	dx, 0000001111100000b
		and	bx, 0000000000011111b
		or	ax, dx
		or	ax, bx
		dec	cx
		mov	es:[di-4], ax
		jnz	@@loop
		jmp	short @@rem
b15_pack_skip	endp

;;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;; packing
;;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
