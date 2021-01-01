	.segment "CODE"

	;; Clear the screen by writing spaces to the entire screen
	.proc main
	ldx $0288		; Check screen memory page address
	stx $bc			; Store to $bc
	inx			; Increment high byte
	stx $be			; Store to $be
	inx			; Increment again
	stx $fd			; Store to $c0
	stx $ff			; Store to $c2 as well

	ldy #$e8		; Load low byte of top-most chunk
	sty $fe			; Store to $c1
	ldy #$00		; Initialize Y index
	sty $bb			; Store to $bb
	sty $bd			; Store to $bd
	sty $fc			; Store to $bf
	lda #$20		; Load SPACE into Accumulator
loop:
	sta ($bb),y		; Store to first chunk
	sta ($bd),y		; Store to second chunk
	sta ($fc),y		; Store to third chunk
	sta ($fe),y		; Store to fourth chunk, but this is
				; special. Screen RAM is 1000 bytes
				; long, because of that we can use
				; increments of $0100 for every chunk
				; otherwise we would write all the the
				; way to $07ff which is outside screen
				; RAM. Instead, we prefer to have an
				; overlap of 24 bytes. There may be
				; better ways to do this, but this
				; works nicely.
	iny			; Increment Y index
	bne loop		; Continue going until X wraps around

	rts
	.endproc

