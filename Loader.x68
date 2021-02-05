;----------------------------------------------------------------------------------------------------------------------------
; Title			:	Dek68 Loader
;----------------------------------------------------------------------------------------------------------------------------

CR  				equ 	$0D
LF		  			equ		$0A

					org		$1000
					
start:				move.b	#14,D0						; Display
					lea		logoString,A1				;	logoString
					trap	#15
					lea		welcomeString,A1			;	welcomeString
					trap	#15
				
StartAddressPrompt	move.b	#14,D0						; Display
					lea		startAddressString,A1		;	startAddressString
					trap	#15
				
					lea 	addressTemp,A1
					move.b	#2,D0						; Read null-term string from kb to 
														;	addressTemp
					trap	#15

					cmpi.w	#8,D1						; Compare length of entered string
					beq		GoodStartAdd				;	Continue if long
					move.b	#14,D0						; Display
					lea		invalidAddSizString,A1		; invalidAddSizString
					trap	#15
					move.b	#14,D0						; Display
					lea		newLine,A1					;	newLine
					trap	#15
					bra		StartAddressPrompt
				
GoodStartAdd		jsr		ParseAddress				; Parse starting address
					cmpi.b	#-1,D0						; Test for error code
					beq		StartAddressPrompt			; Reprompt if invalid chars
					
					move.l	addressTemp,startAddress	; Move parsed address to startAddress
				
EndAddressPrompt	move.b	#14,D0						; Display
					lea		endAddressString,A1			;	endAddressString
					trap	#15
				
					lea 	addressTemp,A1
					move.b	#2,D0						; Read null-term string from kb to addressTemp
					trap	#15
				
					cmpi.w	#8,D1						; Compare length of entered string
					beq		GoodEndAdd					;	Continue if long
					move.b	#14,D0						; Display
					lea		invalidAddSizString,A1		; invalidAddSizString
					trap	#15
					move.b	#14,D0						; Display
					lea		newLine,A1					;	newLine
					trap	#15
					bra		EndAddressPrompt
				
GoodEndAdd			jsr		ParseAddress				; Parse ending address
					cmpi.b	#-1,D0						; Test for error code
					beq		EndAddressPrompt			; Reprompt if invalid chars
					
					move.l	addressTemp,endAddress		; Move parsed address to endAddress
					
					; Check address polarity
					lea		startAddress,A0
					lea		endAddress,A1
					cmpm.l	(A0)+,(A1)+					; Compare addresses
					bge		GoodAddressPolarity			; Acceptable polarity
					move.b	#14,D0						; Display
					lea		invalidAddPolString,A1		;	invalidAddPolString
					trap	#15
					move.b	#14,D0						; Display
					lea		newLine,A1					;	newLine
					trap	#15
					bra		StartAddressPrompt			; Reprompt for addresses
				
GoodAddressPolarity	movea.l	startAddress,A0				; Put startAddress in A0 for incrementing
					move.b	#29,lineCounter				; Line counter
					
					move.w	#$FF00,D1					; Clear screen
					move.b	#11,D0
					trap	#15

DecodeLoop			cmpa.l	endAddress,A0				; Compare A0 and ending address
					bgt		EndDecodeLoop				;	If greater, end loop
					tst.b	lineCounter					; Test line counter
					blt		EndPage						; If line counter expired, wait for next page
					move.l	A0,-(SP)					; Push current address to stack (for this routine)
					jsr		OpcodeDecoder				; Jump to OpcodeDecoder
					move.b	#14,D0						; Display
					lea		newLine,A1					;	newLine
					trap	#15
					movea.l	(SP)+,A0					; Restore current address from stack
								
					adda.l	#$2,A0						; Increment A0 to next opcode
					adda.l	D2,A0				; Increment A0 according to last opcode
					
					subi.b	#1,lineCounter				; Decrement line counter
					bra		DecodeLoop					; Continue
				
EndPage				move.b	#14,D0						; Display
					lea		elipsis,A1					;	elipsis
					trap	#15
					movea.w	#0,A1						; Remove newLine from A1
					move.b	#2,D0						; Wait for enter
					trap	#15
					move.b	#29,lineCounter				; Reset line counter
					bra		DecodeLoop					; Continue
				
EndDecodeLoop		move.b	#14,D0						; Display
					lea		anotherRangeString,A1		;	anotherRangeString
					trap	#15
					
					move.b	#5,D0						; Read char from kb into D1
					trap	#15
					move.b	#14,D0						; Display
					lea		newLine,A1					;	newLine
					trap	#15
					
					cmpi.w	#$59,D1						; Compare to Y
					beq		ClearScreenRest
					
					cmpi.b	#$79,D1						; Compare to y
					beq		ClearScreenRest
					
					cmpi.b	#$4E,D1						; Compare to N
					beq		Exit
					
					cmpi.b	#$6E,D1						; Compare to n
					beq		Exit
					
					bra		EndDecodeLoop				; Invalid char, repeat prompt
					
ClearScreenRest		move.w	#$FF00,D1					; Clear screen
					move.b	#11,D0
					trap	#15
					bra		StartAddressPrompt
					
Exit				move.b	#9,D0						; Terminate
					trap	#15
				

ParseAddress		lea		addressTemp,A0				; Put addressTemp in A0 to use as loop condition
					adda.l	#$8,A0						; But move to the end of the long
					lea		addressTemp,A1				; Put addressTemp in A1 for incrementing
				
BeginParseAddress	cmpa.l	A1,A0						; Compare A0, A1
					beq		CondenseAddress				; If equal, finished so branch to condense
					
					jsr		CheckChar					; Check the current char
					tst.b	D0							; Test for error code
					bmi		ParseError
					
					cmp.b	#$5A,(A1)					; If bit larger than char Z
					bgt		ParseAlphaLower				;	Branch to ParseAlphaLower
					cmp.b	#$39,(A1)					; If bit larger than char 9
					bgt		ParseAlphaUpper				; 	Branch to ParseAlphaUpper
				
ParseNum			sub.b	#$30,(A1)+					; Sub $30 to convert to hex and move to next byte
					bra		BeginParseAddress			; Go back to BeginParseAddress
				
ParseAlphaUpper		sub.b	#$37,(A1)+					; Sub $37 to convert to hex and move to next byte
					bra		BeginParseAddress			; Go back to BeginParseAddress
				
ParseAlphaLower		sub.b	#$57,(A1)+					; Sub $57 to convert to hex and move to next byte
					bra		BeginParseAddress			; Go back to BeginParseAddress
				
CondenseAddress		clr		D0
                    clr     D1
					lea		addressTemp,A0				; Put addressTemp in A0 for incrementing
				
CondenseLoop		lsl.l	#4,D0						; Shift D0 left (D0*$10)
					add.b	(A0)+,D0					; Add place to D0 and increment A0
					add.b	#1,D1						; Increment D1
					cmp.b	#8,D1						; If 8 bytes have been placed
					beq		CondenseLoopEnd				;	Branch to end of sub
					bra		CondenseLoop				;	Otherwise, keep going
				
CondenseLoopEnd		move.l	D0,addressTemp				; Move condensed long to memory
					rts									; End sub
					
ParseError			rts									; Return error
				
;---END-SUB------------------------------------------------------------------------------------------------------------------


CheckChar			; Test 0-9
					cmpi.b	#$30,(A1)					; Compare bit to '0'
					blt		RetCheckAddFail				; If less than '0', invalid char
					cmpi.b	#$3A,(A1)					; Compare bit to ':'
					blt		RetCheckAddGood				; If less than ':', is within 0-9
					
					; Test A-F
					cmpi.b	#$41,(A1)					; Compare bit to 'A'
					blt		RetCheckAddFail				; If less than 'A' and greater than ':', invalid char
					cmpi.b	#$47,(A1)					; Compare bit to 'G'
					blt		RetCheckAddGood				; If less than 'G', is within A-F
					
					; Test a-f
					cmpi.b	#$61,(A1)					; Compare bit to 'a'
					blt		RetCheckAddFail				; If less than 'a' and greater than 'G', invalid char
					cmpi.b	#$67,(A1)					; Compare bit to 'g'
					blt		RetCheckAddGood				; If less than 'g', is within a-f
														; Fall through, because any char > f is invalid

RetCheckAddFail		move.b	#14,D0						; Display
					lea		invalidCharString,A1		;	Invalid char error
					trap	#15
					move.b	#14,D0						; Display
					lea		newLine,A1					;	newLine
					trap	#15
					move.b	#-1,D0						; Error code
					rts									; End sub
										
RetCheckAddGood		rts									; End sub

;---END-SUB------------------------------------------------------------------------------------------------------------------

					include	"./Opcode Decoder.X68"

					simhalt
    
;-Static Strings-------------------------------------------------------------------------------------------------------------
logoString			dc.b	'  _____                    _____                  _____           _ _ ',CR,LF
					dc.b	' |   __|_ _ ___ ___ _ _   |   | |___ _____ ___   |  _  |___ ___ _| |_|___ ___ ',CR,LF
					dc.b	' |   __| | |   |   | | |  | | | | .`|     | -_|  |   __| -_|   | . | |   | . | ',CR,LF
					dc.b	' |__|  |___|_|_|_|_|_  |  |_|___|__,|_|_|_|___|  |__|  |___|_|_|___|_|_|_|_  | ',CR,LF
					dc.b	'          _____    |___|            _          _                         |___| ',CR,LF
					dc.b	'         |  _  |___ ___ ___ ___ ___| |_ ___   |_| ',CR,LF
					dc.b	'         |   __|  _| -_|_ -| -_|   |  _|_ -|   _ ',CR,LF
					dc.b	'         |__|  |_| |___|___|___|_|_|_| |___|  |_| ',CR,LF,CR,LF
					
					dc.b	'                             ___     _     __    ___ ',CR,LF
					dc.b	'                            /   \___| | __/ /_  ( _ ) ',CR,LF
					dc.b	'                           / /\ / _ \ |/ / `_ \ / _ \ ',CR,LF
					dc.b	'                          / /_//  __/   <| (_) | (_) | ',CR,LF
					dc.b	'                         /___,` \___|_|\_\\___/ \___/ ',CR,LF,CR,LF,0
welcomeString		dc.b	'Welcome to Dek68.',CR,LF,CR,LF,0
startAddressString	dc.b	'Please enter the starting address of the code to be disassembled,',CR,LF
					dc.b	'    in the form FFFFFFFF: ',0
endAddressString	dc.b	'Please enter the ending address of the code to be disassembled,',CR,LF
					dc.b	'    in the form FFFFFFFF: ',0
anotherRangeString	dc.b	'Would you like to enter another range for disassembly? [Y/N]',CR,LF,0
invalidCharString	dc.b	'ERROR: One or more entered characters are invalid.',CR,LF
					dc.b	'    Please enter only 0-F',CR,LF,0
invalidAddPolString	dc.b	'ERROR: Invalid address polarity.',CR,LF
					dc.b	'    Please enter a start address less than the end address.',CR,LF,0
invalidAddSizString	dc.b	'ERROR: Invalid address length.',CR,LF
					dc.b	'    Please enter an address 8 characters long.',CR,LF,0
elipsis				dc.b	'...',0
newLine				dc.b	' ',CR,LF,0

;-Data fields----------------------------------------------------------------------------------------------------------------
addressTemp			ds.l	2							; Store address as its being parsed
startAddress		ds.l	1							; Starting address
endAddress			ds.l	1							; Ending address
lineCounter			ds.b	1							; Line counter for pagination
nextOffset			ds.b	1							; Extra offset for next command

					end    	start


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
