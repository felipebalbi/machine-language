	CHROUT	:= $ffd2	; Output a character on the screen
	GETIN	:= $ffe4	; Get a character from keyboard
	STOP	:= $ffe1	; Check RUN/STOP key

	.segment "CODE"

	;; Main entry point
	.proc main
	lda #$93		; Clear Screen character
	jsr CHROUT		; Write it out on the screen

	jsr add			; Add two numbers

	jsr CHROUT		; Print it to the screen
	lda #$0d		; Load A with newline character
	jsr CHROUT		; Print it to the screen
	rts			; Return from subroutine
	.endproc

	;; Add two numbers together printing result to the screen
	;; A should contain one number
	;; $03c0 should contain another number
	.proc add
	jsr getnumber		; Get a number from the user
	sta $03c0		; Stash number from user away
	lda #$2b		; Load A with the + sign
	jsr CHROUT		; Print it to the screen
	jsr getnumber		; Get the next number
	tax			; Transfer number in A to X
	lda #$3d		; Load A with the = sign
	jsr CHROUT		; Print it to the screen
	txa			; Transfer X back to A
	clc			; Clear any possible Carry
	adc $03c0		; Add with first number
	cmp #$0a		; Compare against 9
	bcc done		;
	jsr printone		; Print leading 1
done:	
	ora #$30		; Convert number to PETSCII
	rts
	.endproc

	;; Print a leading 1 to the screen
	;; If result of addition is >9, we must print a leading 1
	;; character. This subroutine helps with that
	.proc printone
	tax			; Save current A to X
	lda #$31		; Load A with PETSCII 1
	jsr CHROUT		; Print it to the screen
	txa			; Put X back to A
	sec			; Set carry for subtraction
	sbc #$0a		; Subtract 10 from A
	rts			; Return from subroutine
	.endproc
	
	;; Get a single number from the keyboard
	;; Any non-number characters will be ignored by busy looping
	.proc getnumber
again:	
	jsr STOP		; Check RUN/STOP key
	beq exit		; If set, bail
	jsr GETIN		; Get a char from keyboard

	cmp #$30		; Compare against PETSCII 0
	bcc again		; If less than that, try again
	cmp #$3a		; Compare aginst PETSCII 9
	bcs again		; If greater than that, try again
	jsr CHROUT		; Otherwise print the character
	and #$0f		; Convert to integer by clearing top nibble
exit:
	rts			; Return from subroutine

	.endproc

