	.segment "CODE"
	.proc main
	;; Initialize memory locations
	lda #$11
	sta $0380
	lda #$22
	sta $0381
	lda #$33
	sta $0382
	lda #$44
	sta $0383
	lda #$55
	sta $0384
	
	ldy #4
	ldx $0384
loop:	
	lda $0380-1,y
	sta $0380,y
	dey
	bne loop
	stx $380
	rts
	.endproc
