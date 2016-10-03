                .model  medium, pascal
                .386
                option  proc:private

                include ugl.inc

;;::::::::::::::
DC_CLIP         macro   x:req, y:req, dst:req,\
                        srcXRes:req, srcYRes:req,\
                        leftGap:req, topGap:req,\
                        exitLabel:req, freeStack:=<0>, conserve
		local   $rg, $exitLabel, $freeStack

                $rg    		equ topGap

                $freeStack 	= freeStack

        ifb     <conserve>
                xor     leftGap, leftGap	;; leftGap= 0
        else
                push    topGap
                $freeStack 	= $freeStack + 2
        endif

        if      ($freeStack ne 0)
                $exitLabel      equ @@clip_exit
        else
                $exitLabel  	equ exitLabel
        endif
             
                mov     $rg, dst:[DC.xMax]
                sub     $rg, x
                js      $exitLabel             	;; x > dst.xMax?

                inc     $rg
                cmp     $rg, srcXRes
                jge     @F                      ;; x + src.width <= dst.xMax?
             
                mov     srcXRes, $rg           	;; width= dst.xMax - x + 1

@@:             mov     $rg, dst:[DC.xMin]
                sub     $rg, x
                jle     @@clip_vert             ;; x >= dst.xMin?

                sub     srcXRes, $rg           	;; width-= (dst.xMin - x)
                jle     $exitLabel             	;; x + width < dst.xMin?
             
                add     leftGap, $rg            ;; leftGap= dst.xMin - x
                mov     x, dst:[DC.xMin]       	;; x= dst.xMin

@@clip_vert:    mov     $rg, dst:[DC.yMax]
                sub     $rg, y
                js      $exitLabel             	;; y > dst.yMax?

                inc     $rg
                cmp     $rg, srcYRes
                jge     @F                      ;; y+src.height <= dst.ymax?
                mov     srcYRes, $rg          	;; height= dst.yMax - y + 1
 
@@:             mov     $rg, dst:[DC.yMin]
                sub     $rg, y
                jle     @@clip_done             ;; y >= dst.yMin?

                sub     srcYRes, $rg          	;; height-= (dst.yMin - y)
                jle     $exitLabel             	;; y + height < yMin?
             
        ifnb    <conserve>
                pop     y
                add     topGap, y              	;; topGap+= (dst.yMin - y)
        endif
                mov     y, dst:[DC.yMin]       	;; y= dst.yMin
                jmp     short @@clip_end
        
@@clip_exit:
        if      ($freeStack ne 0)
                add     sp, $freeStack
                jmp     exitLabel
        endif

@@clip_done:
        ifb     <conserve>
                xor     topGap, topGap          ;; topGap= 0
        else
                pop     topGap
        endif
@@clip_end:
endm
