	.segment "CODE"

	;; Clear the screen by writing spaces to the entire screen
	.proc main
	lda #$20		; Load SPACE into Accumulator
	ldx #$00		; Initialize X index
loop:
	sta $0400,x		; Store to first chunk
	sta $0500,x		; Store to second chunk
	sta $0600,x		; Store to third chunk
	sta $06e8,x		; Store to fourth chunk, but this is
				; special. Screen RAM is 1000 bytes
				; long, because of that we can use
				; increments of $0100 for every chunk
				; otherwise we would write all the the
				; way to $07ff which is outside screen
				; RAM. Instead, we prefer to have an
				; overlap of 24 bytes. There may be
				; better ways to do this, but this
				; works nicely.
	inx			; Increment X index
	bne loop		; Continue going until X wraps around

	rts
	.endproc
