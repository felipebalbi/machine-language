	CHROUT	:= $ffd2	; Output a character on the screen
	GETIN	:= $ffe4	; Get a character from keyboard
	STOP	:= $ffe1	; Check RUN/STOP key

	.segment "CODE"
	.proc main

	lda #$93		; Clear Screen character
	jsr CHROUT
again:	
	jsr STOP
	beq exit
	jsr GETIN

trynum:	
	cmp #$30
	bcc again
	cmp #$3a
	bcs tryalpha
	jmp printchar

tryalpha:
	cmp #$41
	bcc again
	cmp #$5a
	bcs again
	jmp printchar

printchar:
	;; ora #$80		; Turn on highest bit. Prints shifted char
	;; and #$fe		; Clear lowest bit. For digits,
				; prints only evens
	jsr CHROUT
	jmp again

exit:	
	rts
	.endproc

