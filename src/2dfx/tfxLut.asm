
tfx_data	segment	para public use16 'TFXDATA'
clut		dd	?
tfx_data	ends

UGL_CODE
;;:::
;; 1i-> 8...8...8... (bit order: lsb=1st pixel, msb=last (reverse of BMP!)
;;  in: es:si-> source
;;	ds-> DGROUP
;;	cx= pixels
i1_lut		proc	near uses gs
		pusha
		push	ds
		
		mov	ax, TFXGRP
		mov	ds, ax
		assume	ds:TFXGRP
		
		xor	di, di			;; i= 0
                mov	bp, si			;; es:bp-> source
                lgs	si, clut		;; gs:si-> clut (palette)
                
                push	cx
                shr     cx, 3                   ;; / 8
                jz      @@rem

@@oloop:        xor	ax, ax
		mov     al, es:[bp]             ;; al= 0:1:2:3:4:5:6:7 attrib
                
                shl	ax, 2
                inc     bp                      ;; x+= 8
		
                mov	bx, ax
                push	cx
                
                mov     cx, 8
                and	bx, 00000100b

		;; 9 clocks p/ pixel... bleargh!
@@loop:         shr     ax, 1
		cmp	bx, 00000100b
		
		mov     edx, gs:[si + bx] 
				
                sbb	bx, bx
                mov	srcBlue[di], dl		;; srcBlue[i]                
                                                
                mov	srcGreen[di], dh	;; srcGreen[i]
                
                shr	edx, 16
                
                mov	srcMask[di], bl		;; srcMask[i]
                mov	bx, ax
                                
                and	bx, 00000100b                
                dec     cx
                
                mov	srcRed[di], dl		;; srcRed[i]
                
                lea	di, [di + 1]		;; ++i
                jnz     @@loop

                pop	cx
                dec     cx
                jnz     @@oloop

		;; remainder
@@rem:    	pop	cx
		and     cx, 7                   ;; % 8
                jz      @@exit

                xor	ax, ax
                mov     al, es:[bp]
                shl	ax, 2

@@rloop:        mov	bx, ax
		shr     ax, 1
                and	bx, 00000100b		;; cLUT index                
                cmp	bx, 00000100b
                mov     edx, gs:[si + bx]
                sbb	bx, bx
                mov	srcBlue[di], dl		;; srcBlue[i]
                mov	srcGreen[di], dh	;; srcGreen[i]
                shr	edx, 16
                mov	srcRed[di], dl		;; srcRed[i]
                mov	srcMask[di], bl		;; srcMask[i]
                inc	di			;; ++i
                dec     cx
                jnz     @@rloop

@@exit:         pop	ds
		assume	ds:DGROUP
		popa
		ret
i1_lut		endp

;;:::
;; 4i-> 8...8...8...
;;  in: es:si-> source
;;	ds-> DGROUP
;;	cx= pixels
i4_lut		proc	near uses gs
		pusha
		push	ds
		
		mov	ax, TFXGRP
		mov	ds, ax
		assume	ds:TFXGRP
		
		xor	di, di			;; i= 0
                mov	bp, si			;; es:bp-> source
                lgs	si, clut		;; gs:si-> clut (palette)
                
                push	cx
                shr     cx, 1                   ;; / 2
                jz      @@rem
				
		;; 20 clocks p/ 2 pixels (10 p/ pixel)... bleargh!
@@loop:         push	si			;; (0)
		xor     bx, bx
		
		mov     bl, es:[bp]             ;; bl= 1st:2nd attrib
		add	di, 2			;; i+= 2
				
		mov	ax, bx
		and	bx, 0F0h
		
		shr	bx, 4-2			;; bx= 1st attrib
		and	ax, 00Fh		;; di= 2nd attrib
		
		shl	ax, 2
		cmp	bx, 100b
		
		sbb	dl, dl
		inc	bp			;; ++x
		
		add	bx, si		
		cmp	ax, 100b
		
		sbb	dh, dh
		mov	srcMask[di-2], dl	;; srcSrc[i]
		
		add	si, ax
		mov	srcMask[di-2+1], dh	;; srcSrc[i+1]
		
		mov	eax, gs:[bx]
				
		mov	edx, gs:[si]
		
		pop	si			(0)		
		mov	srcBlue[di-2], al	;; srcBlue[i]
		
		mov	srcBlue[di-2+1], dl	;; srcBlue[i+1]
		
		mov	srcGreen[di-2], ah	;; srcGreen[i]
		
		shr	eax, 16
		
		mov	srcGreen[di-2+1], dh	;; srcGreen[i+1]

                shr	edx, 16
                
                mov	srcRed[di-2], al	;; srcRed[i]
                
                mov	srcRed[di-2+1], dl	;; srcRed[i+1]                
                dec     cx
                
                jnz     @@loop   
				
		;; remainder
@@rem:    	pop	cx
		and     cx, 1                   ;; % 2
                jz      @@exit

                mov     bl, es:[bp]             ;; bl= 1st:??? attrib
		shr	bx, 4			;; bx= 1st attrib
                shl     bx, 2
                cmp	bx, 100b
		sbb	al, al
		mov	srcMask[di], al		;; srcMask[i]
		mov	eax, gs:[si + bx]
		mov	srcBlue[di], al		;; srcBlue[i]
		mov	srcGreen[di], ah	;; srcGreen[i]
		shr	eax, 16
		mov	srcRed[di], al		;; srcRed[i]

@@exit:         pop	ds
		assume	ds:DGROUP
		popa
		ret
i4_lut		endp

;;:::
;; 8i-> 8...8...8...
;;  in: es:si-> source
;;	ds-> DGROUP
;;	cx= pixels
i8_lut		proc	near uses gs
		pusha
		push	ds
		
		mov	ax, TFXGRP
		mov	ds, ax
		assume	ds:TFXGRP
		
		xor	di, di			;; i= 0
                mov	bp, si			;; es:bp-> source
                lgs	si, clut		;; gs:si-> clut (palette)

                push	cx
                shr     cx, 1                   ;; / 2
                jz      @@rem

		;; 19 clocks p/ 2 pixels (9.5 p/ pixel)... bleargh!
		push	si			;; (0)
@@loop:         mov     bx, es:[bp]           	;; bx= color:color attribute
		add	di, 2			;; i+= 2
				
		mov	ax, bx
		and	bx, 000FFh
		
		shl	bx, 2			;; cLUT index
		and	ax, 0FF00h
		
                shr     ax, 8-2
                cmp	bx, 100b
                
                sbb	dl, dl
                add	bp, 2			;; x+= 2
                
                add	bx, si
		cmp	ax, 100b
		
		sbb	dh, dh
		mov	srcMask[di-2], dl	;; srcSrc[i]
		
		add	si, ax
		mov	srcMask[di-2+1], dh	;; srcSrc[i+1]
				
		mov	eax, gs:[bx]
		
		mov	edx, gs:[si]
		
		pop	si			;; (0)		
                mov	srcBlue[di-2], al	;; srcBlue[i]
                
                mov	srcBlue[di-2+1], dl	;; srcBlue[i+1]
                                
                mov	srcGreen[di-2], ah	;; srcGreen[i]
                
                shr	eax, 16
                
                mov	srcGreen[di-2+1], dh	;; srcGreen[i+1]
                                
                shr	edx, 16
                
                mov	srcRed[di-2], al	;; srcRed[i]
                
                mov	srcRed[di-2+1], dl	;; srcRed[i+1]				
		dec	cx		
		
		push	si			;; (0)
		jnz	@@loop
		
		add	sp, 2			;; (0)
		
		;; remainder
@@rem:    	pop	cx
		and     cx, 1                   ;; % 2
                jz      @@exit

		xor	bx, bx
		mov     bl, es:[bp]           	;; bl= color attribute
		shl	bx, 2			;; cLUT index
                cmp	bx, 100b
		sbb	al, al
		mov	srcMask[di], al		;; srcMask[i]
		mov	eax, gs:[si + bx]
		mov	srcBlue[di], al		;; srcBlue[i]
		mov	srcGreen[di], ah	;; srcGreen[i]
		shr	eax, 16
		mov	srcRed[di], al		;; srcRed[i]

@@exit:         pop	ds
		assume	ds:DGROUP
		popa
		ret
i8_lut		endp
UGL_ENDS