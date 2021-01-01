	.segment "CODE"

	;; Manipulate the screen memory
	.proc main
	lda #$28		; 40 column screen
	ldx $0288		; Check screen memory page address
	sta $03a0		; Stash columns in a safe place
	stx $bc			; Store memory page (high-byte) address
	lda #$00		; Load A with 0
	sta $bb			; Store 0 to $bb, effectively address
				; is $bc$bb, $0400 on C64
	ldx #$00		; Initialize X to 0
nextLine:
	ldy #$06		; Initialize Y to 6
nextChar:
	lda ($bb),y		; Initialize A current characer in
				; screen
	cmp #$20		; Compare against space character
	beq skip		; Skip spaces
	eor #$80		; Reverse the character
skip:
	sta ($bb),y		; Put modified character back into the
				; screen
	iny			; Increment Y index
	cpy #$22		; Compare against 34 (last column we
				; want to modify)
	bcc nextChar		; If less than 34, go to next
				; character
	;; If we reach this point, it's time to start the next line
	clc			; Clear carry to prepare for addition
	lda $bb			; Load A with offset
	adc $03a0		; Add number of columns, effectively
				; moving to the next line
	sta $bb			; Store modified offset
	lda $bc			; Load A with page number
	adc #$00		; Add 0. The idea is to modify $bc
				; only if there was a carry from
				; previous addition. Rather clever
				; trick!
	sta $bc			; Store modified page number
	inx			; Increment X index
	cpx #$0e		; Compare against 14 (we only want to
				; modify up to 14 lines)
	bne nextLine		; If we haven't modified 14 lines, go
				; to the next one
	rts
	.endproc
