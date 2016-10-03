;; name: uglPalSet
;; desc: changes the current palette
;;
;; args: [in] idx:integer,	| first index
;;	      entries:integer,	| pal array entries
;;	      pal:RGB 		| array with Red, Green, Blue components
;; retn: none
;;
;; decl: uglPalSet (byval idx as integer, byval entries as integer,
;;		    seg pal as RGB)
;;
;; chng: nov/02 written [v1ctor]
;;
;; obs.: components ranging from 0 to 255 (8-bit)
;;	 uglColor# routines don't work if palette is changed
;;

;; name: uglPalGet
;; desc: gets the current palette
;;
;; args: [in] idx:integer,	| first index
;;	      entries:integer,	| pal array entries
;;	      pal:RGB 		| array with Red, Green, Blue
;; retn: none
;;
;; decl: uglPalGet (byval idx as integer, byval entries as integer,
;;		    seg pal as RGB)
;;
;; chng: nov/02 written [v1ctor]
;;
;; obs.: components ranging from 0 to 255 (8-bit)
;;
                
;; name: uglPalLoad
;; desc: load a palette file
;;
;; args: [in] fname:string	| file to load
;;	      fmt:integer	| stream format (PALRGB, PALBGR)
;; retn: long			| palette
;;
;; decl: uglPalLoad& (fname As String, fmt As Integer )
;;
;; chng: nov/02 written [v1ctor]
;;
;; obs.: components' range must be: 0 to 255 (8-bit)
;;

;; name: uglPalUsingLin
;; desc: Set wether or not you are using a linear palette
;;
;; args: [in] flag              | TRUE, FALSE
;; retn: nothing
;;
;; decl: uglPalUsingLin ( byval linpal as integer )
;;
;; chng: nov/03 written [Blitz]
;;
;; obs.: Some routines act differently with a linear palette
;;       then they do with the 332 palette. One of these are
;;       uglTriG. It's abit faster ( 3 cpp vs 7 cpp ). And 
;;       looks better, down side is that its many shades of
;;       the same color. Compared to many color with few shades
;;       when using a 332 palette.
;;
		
		include common.inc
                include vbe.inc
		include dos.inc
		include arch.inc
		include lang.inc

.data
;;
;; Linear palette flag
;;
ul$linpal       word    FALSE

.code
;;::::::::::::::
;; uglPalSet( idx:word, entries:word, pal:far ptr RGB )
uglPalSet	proc	public uses bx si ds,\
			idx:word,\
			entries:word,\
			pal:far ptr RGB
		

		mov     cl, 8                   ;; cl= 8 - bits p/ component
		sub     cl, vb$dacbits          ;; /
		
		mov     dx, 3C8h
                mov     al, B idx
                out     dx, al
                inc     dx
		
		mov	bx, entries

		lds	si, pal

@@loop:		mov	al, [si].RGB.red
		shr	al, cl
		out	dx, al
		
		mov	al, [si].RGB.green
		shr	al, cl
		out	dx, al

		mov	al, [si].RGB.blue
		shr	al, cl
		out	dx, al
		
		add	si, 1+1+1
		dec	bx
		jnz	@@loop

		ret
uglPalSet	endp
		
;;::::::::::::::
;; uglPalSet( idx:word, entries:word, pal:far ptr RGB )
uglPalGet	proc	public uses bx di ds,\
			idx:word,\
			entries:word,\
			pal:far ptr RGB
		
                int     3
		mov     cl, 8                   ;; cl= 8 - bits p/ component
		sub     cl, vb$dacbits          ;; /
		
		mov     dx, 3C7h
                mov     al, B idx
                out     dx, al
                add     dx, 2
		
		mov	bx, entries

		lds	si, pal

@@loop:		in	al, dx
		shl	al, cl
		mov	[si].RGB.red, al
		
		in	al, dx
		shl	al, cl
		mov	[si].RGB.green, al		

		in	al, dx
		shl	al, cl
		mov	[si].RGB.blue, al		
		
		add	si, 1+1+1
		dec	bx
		jnz	@@loop

		ret
uglPalGet	endp


;;::::::::::::::
;; uglPalLoad( fname:STRING, format:word ): far ptr RGB
uglPalLoad	proc	public uses bx di si es,\ 
			fname:STRING,\
			format:word
		
		local   bf:UAR, pal:dword
		
		invoke	uarOpen, addr bf, fname, F_READ
		jc	@@error
		
		invoke	memAlloc, T RGB * 256
		jc	@@error2
                mov	W pal+0, ax
		mov	W pal+2, dx
		mov	es, dx			;; es:di-> pal
		mov	di, ax			;; /
		
		;;
		cmp	format, PAL_RGB
		jne	@F		
		invoke	uarRead, addr bf, es::di, T RGB * 256
		jc	@@error3
		jmp	@@done
		
		;;
@@:		cmp	format, PAL_BGR
		jne	@@error3
		invoke	uarRead, addr bf, es::di, T RGB * 256
		jc	@@error3
		
		mov	cx, 256

@@bgr2rgb:	mov	al, es:[di+0]
		xchg	al, es:[di+2]
		add	di, 1+1+1
		dec	cx
		jnz	@@bgr2rgb
		
@@done:		invoke	uarClose, addr bf

		mov	ax, W pal+0
		mov	dx, W pal+2

@@exit:		ret

@@error3:	invoke	uarClose, addr bf

@@error2:	invoke	memFree, pal

@@error:	xor	ax, ax
		xor	dx, dx
		jmp	short @@exit
uglPalLoad	endp


;;::::::::::::::
;; uglPalUsingLin( flag:word )
uglPalUsingLin	proc	public uses es,\ 
			flag:word
                ;;
                ;; We only set the flag if the video mode
                ;; is 8 bit? (ignored for now)
                ;;
                ;mov     ax, W cs:ul$videoDC+2
                ;mov     es, ax
                ;cmp     es:[DC.bpp], 8
                ;jne     @@exit
                
                ;;
                ;; Set flag
                ;;
                mov     ax, flag
                mov     ul$linpal, FALSE
                
                or      ax, ax
                jz      @@exit
                mov     ul$linpal, TRUE
                
@@exit:         ret
uglPalUsingLin	endp
		end
