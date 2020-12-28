CHROUT	:= $ffd2

	.segment "CODE"
	.proc main

	lda #$93		; Clear Screen character
	jsr CHROUT
	ldx #$00
loop:
	lda message,x
	beq exit
	inx
	jsr CHROUT
	jmp loop
exit:	
	rts
	.endproc

message:
	.byte $48		; H
	.byte $4f		; O
	.byte $20		; <space>
	.byte $48		; H
	.byte $4f		; O
	.byte $21		; !
	.byte $00		; NULL terminator
	
