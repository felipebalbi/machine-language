	CHROUT	:= $ffd2	; Output a character on the screen
	GETIN	:= $ffe4	; Get a character from keyboard
	STOP	:= $ffe1	; Check RUN/STOP key

	.segment "CODE"

	;; Main entry point
	.proc main
	lda #$93		; Clear Screen character
	jsr CHROUT		; Write it out on the screen

	;; jsr add			; Add two numbers
	;; jsr subtract		; Subtract two numbers
	;; jsr getAndPrintNumber	; Get one number and print it
	jsr evenOrOdd		; Get a number, print EVEN or ODD

	jsr CHROUT		; Print it to the screen
	lda #$0d		; Load A with newline character
	jsr CHROUT		; Print it to the screen
	rts			; Return from subroutine
	.endproc

	.proc evenOrOdd
	jsr getnumber		; Get a number from the user
	tax			; Stash it in X
	lda #$20		; Load A with space character
	jsr CHROUT		; Print it to the screen
	txa			; Load X back into A
	ldx #$00
	lsr			; Load bit 0 into carry
	bcc printEven		; Print Even
	bcs printOdd		; Print Odd

printEven:
	lda even,x
	beq exit
	inx
	jsr CHROUT
	jmp printEven

printOdd:
	lda odd,x
	beq exit
	inx
	jsr CHROUT
	jmp printOdd
exit:
	rts
	.endproc

even:
	.byte $45		; E
	.byte $56		; V
	.byte $45		; E
	.byte $4e		; N
	.byte $00		; NULL terminator

odd:
	.byte $4f		; O
	.byte $44		; D
	.byte $44		; D
	.byte $00		; NULL terminator

;; 	;; Get one number:
;; 	;; If <5  -> double and print
;; 	;; If >=5 -> divide by 2 and print
;; 	.proc getAndPrintNumber
;; 	jsr getnumber		; Get a number
;; 	cmp #$05		; Compare against 5
;; 	bcc double		; Double the number
;; 	jmp half		; Halve the number
;; double:
;; 	rol a			; Double the number in A
;; 	jmp print		; Print result

;; half:
;; 	clc			; Clear carry
;; 	ror a			; Halve the number in A

;; print:
;; 	ora #$30		; Convert to PETSCII
;; 	rts
;; 	.endproc
	
;; 	;; Add two numbers together printing result to the screen
;; 	;; A should contain one number
;; 	;; $03c0 should contain another number
;; 	.proc add
;; 	jsr getnumber		; Get a number from the user
;; 	sta $03c0		; Stash number from user away
;; 	lda #$2b		; Load A with the + sign
;; 	jsr CHROUT		; Print it to the screen
;; 	jsr getnumber		; Get the next number
;; 	tax			; Transfer number in A to X
;; 	lda #$3d		; Load A with the = sign
;; 	jsr CHROUT		; Print it to the screen
;; 	txa			; Transfer X back to A
;; 	clc			; Clear any possible Carry
;; 	adc $03c0		; Add with first number
;; 	cmp #$0a		; Compare against 9
;; 	bcc done		;
;; 	jsr printone		; Print leading 1
;; done:	
;; 	ora #$30		; Convert number to PETSCII
;; 	rts
;; 	.endproc

;; 	;; Subtract two numbers and print result to the screen
;; 	;; A contains one number
;; 	;; $03c0 contains another number
;; 	;; It's assumed that A > $03c0
;; 	.proc subtract
;; 	jsr getnumber		; Get a number from the user
;; 	sta $03c0		; Stash number from user away
;; 	lda #$2d		; Load A with the - sign
;; 	jsr CHROUT		; Print it to the screen
;; 	jsr getnumber		; Get the next number
;; 	tax			; Transfer number in A to X
;; 	lda #$3d		; Load A with the = sign
;; 	jsr CHROUT		; Print it to the screen
;; 	lda $03c0		; Load A with first number
;; 	stx $03c0		; Store X to $03c0
;; 	sec			; Set Carry
;; 	sbc $03c0		; Subtract from first number
;; 	ora #$30		; Convert number to PETSCII
;; 	rts
;; 	.endproc

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

