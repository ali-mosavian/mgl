
;;:::
;;  in: ds-> DGROUP
;;	cx= pixels
masking		proc	near
		pusha
		push	ds

		mov	ax, TFXGRP
		mov	ds, ax
		assume	ds:TFXGRP
		
		xor	di, di			;; i= 0
		mov	ax, cx
		shr	cx, 3			;; / 8
		jz	@@rem			;; < 8?

		pcmpeqd	mm7, mm7		;; 7= -1

		;; 14 clocks p/ 8 pixels (1.75 p/ pixel)
@@loop:		movq	mm5, srcMask[di]	;; 5= mask
				
		movq	mm0, dstRed[di]		;; 0= dst.red[x]
		movq	mm6, mm5
				
		movq	mm1, srcRed[di]		;; 0= src.red[x]
		pandn	mm6, mm7		;; 6= !mask
				
		movq	mm2, dstGreen[di]	;; 2= dst.green[x]
		pand	mm0, mm5		;; 0= (mask? mm0: 0)
				
		movq	mm3, srcGreen[di]	;; 3= src.green[x]
		pand	mm1, mm6		;; 1= (mask? 0: mm1)
				
		movq	mm4, dstBlue[di]	;; 4= dst.blue[x]
		por	mm0, mm1		;; merge
				
		movq	mm1, srcBlue[di]	;; 1= src.blue[x]
		pand	mm2, mm5		;; 2= (mask? mm2: 0)
				
		pand	mm3, mm6		;; 3= (mask? 0: mm3)
		pand	mm4, mm5		;; 4= (mask? mm4: 0)
				
		movq	srcRed[di], mm0		;; store src.red
		por	mm2, mm3		;; merge

		pand	mm1, mm6		;; 1= (mask? 0: mm1)
		add	di, 8			;; x+= 8
				
		por	mm1, mm4		;; merge
		dec	cx
				
		movq	srcGreen[di-8], mm2	;; store src.green
				
		movq	srcBlue[di-8], mm1	;; store src.blue

		jnz	@@loop
		
		;; remainder
@@rem:		and	ax, 7			;; % 8
		jz	@@exit

		movq	mm5, srcMask[di]	;; 5= mask
		movq	mm0, dstRed[di]		;; 0= dst.red[x]
		movq	mm6, mm5				
		movq	mm1, srcRed[di]		;; 0= src.red[x]
		pandn	mm6, mm7		;; 6= !mask				
		movq	mm2, dstGreen[di]	;; 2= dst.green[x]
		pand	mm0, mm5		;; 0= (mask? mm0: 0)
		movq	mm3, srcGreen[di]	;; 3= src.green[x]
		pand	mm1, mm6		;; 1= (mask? 0: mm1)
		movq	mm4, dstBlue[di]	;; 4= dst.blue[x]
		por	mm0, mm1		;; merge
		movq	mm1, srcBlue[di]	;; 1= src.blue[x]
		pand	mm2, mm5		;; 2= (mask? mm2: 0)
		pand	mm3, mm6		;; 3= (mask? 0: mm3)
		pand	mm4, mm5		;; 4= (mask? mm4: 0)
		movq	srcRed[di], mm0		;; store src.red
		por	mm2, mm3		;; merge		
		pand	mm1, mm6		;; 1= (mask? 0: mm1)		
		movq	srcGreen[di], mm2	;; store src.green
		por	mm1, mm4		;; merge				
		movq	srcBlue[di], mm1	;; store src.blue

@@exit:		pop	ds
		assume	ds:DGROUP
		popa
		ret
masking		endp