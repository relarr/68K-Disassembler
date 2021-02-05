;----------------------------------------------------------------------------------------------------------------------------
; Title			:	Dek68 Opcode Decoder
;----------------------------------------------------------------------------------------------------------------------------

OpcodeDecoder	movea.l	SP,A0			; Load stack pointer
				adda.l	#$4,A0			; Increment our pointer
				movea.l	(A0),A0			; Move the machine code address into A0
				move.w	(A0),D7			; Move machine code into D7
		
; Determine which group the opcode belongs to, based on the most significant four bits
				move.l	#$C000,D1		; Mask for ccqq
				and.l	D7,D1			; Apply mask
				cmpi.l	#$0000,D1		; Compare masked code to group
				beq		ccqq			;	Branch if equal
				
				move.l	fBtMsk,D1		; Mask for all other groups
				and.l	D7,D1			; Apply mask
				cmpi.l	#$4000,D1		; Compare masked code to group
				beq		cscc			;	Branch if equal
				
				move.l	fBtMsk,D1		; Mask for all other groups
				and.l	D7,D1			; Apply mask
				cmpi.l	#$5000,D1		; Compare masked code to group
				beq		cscs			;	Branch if equal
				
				move.l	fBtMsk,D1		; Mask for all other groups
				and.l	D7,D1			; Apply mask
				cmpi.l	#$6000,D1		; Compare masked code to group
				beq		cssc			;	Branch if equal
				
				move.l	fBtMsk,D1		; Mask for all other groups
				and.l	D7,D1			; Apply mask
				cmpi.l	#$7000,D1		; Compare masked code to group
				beq		csss			;	Branch if equal
				
				move.l	fBtMsk,D1		; Mask for all other groups
				and.l	D7,D1			; Apply mask
				cmpi.l	#$8000,D1		; Compare masked code to group
				beq		sccc			;	Branch if equal
				
				move.l	fBtMsk,D1		; Mask for all other groups
				and.l	D7,D1			; Apply mask
				cmpi.l	#$9000,D1		; Compare masked code to group
				beq		sccs			;	Branch if equal
				
				move.l	fBtMsk,D1		; Mask for all other groups
				and.l	D7,D1			; Apply mask
				cmpi.l	#$B000,D1		; Compare masked code to group
				beq		scss			;	Branch if equal
				
				move.l	fBtMsk,D1		; Mask for all other groups
				and.l	D7,D1			; Apply mask
				cmpi.l	#$C000,D1		; Compare masked code to group
				beq		sscc			;	Branch if equal
				
				move.l	fBtMsk,D1		; Mask for all other groups
				and.l	D7,D1			; Apply mask
				cmpi.l	#$D000,D1		; Compare masked code to group
				beq		sscs			;	Branch if equal
				
				move.l	fBtMsk,D1		; Mask for all other groups
				and.l	D7,D1			; Apply mask
				cmpi.l	#$E000,D1		; Compare masked code to group
				beq		sssc			;	Branch if equal
				
				bra		qqqq			; Branch to qqqq; unknown opcode
				
; Mask groups
; 00?? msB
ccqq			move.l	#$FF00,D1		; Mask for addi
				and.l	D7,D1			; Apply mask
				cmpi.l	#$0600,D1		; Compare for addi
				bne		tMOVE			; Continue if !=
				lea		sADDI,A1		; Place string in A1
				move.b	#$6,D6			; Set size offset
				jsr		GetSize			; Get size of opcode
				move.b	D5,-(SP)		; Push size to stack
				move.b	iADDI,-(SP)		; Push identifier to stack
				bra		printOp
		
tMOVE			move.l	#$C000,D1		; Mask for move
				and.l	D7,D1			; Apply mask
				cmpi.l	#$0000,D1		; Compare for move
				bne		tMOVEA			; Continue if !=
				lea		sMOVE,A1		; Place string in A1
				move.b	iMOVE,-(SP)		; Push identifier to stack
				jsr		GetMSize		; Get size of opcode
				move.b	(SP)+,D0		; Dump identifier
				move.b	D5,-(SP)		; Push size to stack
				move.b	iMOVE,-(SP)		; Push identifier to stack
				bra		printOp
		
tMOVEA			move.l	#$C1C0,D1		; Mask for movea
				and.l	D7,D1			; Apply mask
				cmpi.l	#$0040,D1		; Compare for movea
				bne		qqqq			; Branch to qqqq; unknown opcode
				lea		sMOVEA,A1		; Place string in A1
				move.b	iMOVEA,-(SP)	; Push identifier to stack
				jsr		GetMSize		; Get size of opcode
				move.b	(SP)+,D0		; Dump identifier
				move.b	D5,-(SP)		; Push size to stack
				move.b	iMOVEA,-(SP)	; Push identifier to stack
				bra		printOp

; 0100 msB
cscc			move.l	#$FF00,D1		; Mask for clr
				and.l	D7,D1			; Apply mask
				cmpi.l	#$4200,D1		; Compare for clr
				bne		tDIVUL			; Continue if !=
				;bne		tNOP
				lea		sCLR,A1			; Place string in A1
				move.b	#$6,D6			; Set size offset
				jsr		GetSize			; Get size of opcode
				move.b	D5,-(SP)		; Push size to stack
				move.b	iCLR,-(SP)		; Push identifier to stack
				bra		printOp
				
tDIVUL			move.l	#$FFC08BF8,D1	; Mask for divu.l
				and.l	D7,D1			; Apply mask
				cmpi.l	#$4C000000,D1	; Compare for divu.l
				bne		tMULSL			; Continue if !=
				lea		sDIVU,A1		; Place string in A1
				move.b	#$4C,D6			; Place size in D6
				move.b	D5,-(SP)		; Push size to stack
				move.b	iDIVU,-(SP)		; Push identifier to stack
				bra		printOp
				
tMULSL			move.l	#$FFC08BF8,D1	; Mask for muls.l
				and.l	D7,D1			; Apply mask
				cmpi.l	#$4C000800,D1	; Compare for muls.l
				bne		tNOP			; Continue if !=
				lea		sMULS,A1		; Place string in A1
				move.b	#$4C,D6			; Place size in D6
				move.b	D5,-(SP)		; Push size to stack
				move.b	iMULS,-(SP)		; Push identifier to stack
				bra		printOp
		
tNOP			move.l	#$FFFF,D1		; Mask for nop (not really needed, but y`know, consistency)
				and.l	D7,D1			; Apply mask
				cmpi.l	#$4E71,D1		; Compare for nop
				bne		tRTS			; Continue if !=
				lea		sNOP,A1			; Place string in A1
				move.b	#-1,D5			; Set no size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iNOP,-(SP)		; Push identifier to stack
				bra		printOp
		
tRTS			move.l	#$FFFF,D1		; Mask for rts (not really needed, but y`know, consistency)
				and.l	D7,D1			; Apply mask
				cmpi.l	#$4E75,D1		; Compare for rts
				bne		tJSR			; Continue if !=
				lea		sRTS,A1			; Place string in A1
				move.b	#-1,D5			; Set no size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iRTS,-(SP)		; Push identifier to stack
				bra		printOp
		
tJSR			move.l	#$FFC0,D1		; Mask for jsr
				and.l	D7,D1			; Apply mask
				cmpi.l	#$4E80,D1		; Compare for jsr
				bne		tMOVEM			; Continue if !=
				lea		sJSR,A1			; Place string in A1
				move.b	#-1,D5			; Set no size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iJSR,-(SP)		; Push identifier to stack
				bra		printOp
		
tMOVEM			move.l	#$FB80,D1		; Mask for movem
				and.l	D7,D1			; Apply mask
				cmpi.l	#$4880,D1		; Compare for movem
				bne		tLEA			; Continue if !=
				lea		sMOVEM,A1		; Place string in A1
				move.b	iMOVEM,-(SP)	; Push identifier to stack
				jsr		GetMSize		; Get size
				move.b	(SP)+,D0		; Dump identifier
				move.b	D5,-(SP)		; Push size to stack
				move.b	iMOVEM,-(SP)	; Push identifier to stack
				bra		printOp
				
tLEA			move.l	#$F1C0,D1		; Mask for lea
				and.l	D7,D1			; Apply mask
				cmpi.l	#$41C0,D1		; Compare for lea
				bne		qqqq			; Branch to qqqq; unknown opcode
				lea		sLEA,A1			; Place string in A1
				move.b	#-1,D5			; Set no size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iLEA,-(SP)		; Push identifier to stack
				bra		printOp

; 0101 msB
cscs			move.l	#$F100,D1		; Mask for addq
				and.l	D7,D1			; Apply mask
				cmpi.l	#$5000,D1		; Compare for addq
				bne		qqqq			; Branch to qqqq; unknown opcode
				lea		sADDQ,A1		; Place string in A1
				move.b	#$6,D6			; Set size offset
				jsr		GetSize			; Get size of opcode
				move.b	D5,-(SP)		; Push size to stack
				move.b	iADDQ,-(SP)		; Push identifier to stack
				bra		printOp
				
; 0110 msB (AKA all Bcc commands)
;tBHI			
cssc			move.l	csscMsk,D1
				and.l	D7,D1
				cmpi.l	#$6200,D1		; Compare for bhi
				bne		tBLS			; Continue if !=
				lea		sBHI,A1			; Place string in A1
				move.b	#-1,D5			; Set no size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iBHI,-(SP)		; Push identifier to stack
				bra		printOp
				
tBLS			move.l	csscMsk,D1
				and.l	D7,D1
				cmpi.l	#$6300,D1		; Compare for bls
				bne		tBCC			; Continue if !=
				lea		sBLS,A1			; Place string in A1
				move.b	#-1,D5			; Set no size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iBLS,-(SP)		; Push identifier to stack
				bra		printOp
				
tBCC			move.l	csscMsk,D1
				and.l	D7,D1
				cmpi.l	#$6400,D1		; Compare for bcc
				bne		tBCS			; Continue if !=
				lea		sBCC,A1			; Place string in A1
				move.b	#-1,D5			; Set no size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iBCC,-(SP)		; Push identifier to stack
				bra		printOp
				
tBCS			move.l	csscMsk,D1
				and.l	D7,D1
				cmpi.l	#$6500,D1		; Compare for bcs
				bne		tBNE			; Continue if !=
				lea		sBCS,A1			; Place string in A1
				move.b	#-1,D5			; Set no size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iBCS,-(SP)		; Push identifier to stack
				bra		printOp
				
tBNE			move.l	csscMsk,D1
				and.l	D7,D1
				cmpi.l	#$6600,D1		; Compare for bne
				bne		tBEQ			; Continue if !=
				lea		sBNE,A1			; Place string in A1
				move.b	#-1,D5			; Set no size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iBNE,-(SP)		; Push identifier to stack
				bra		printOp
				
tBEQ			move.l	csscMsk,D1
				and.l	D7,D1
				cmpi.l	#$6700,D1		; Compare for beq
				bne		tBVC			; Continue if !=
				lea		sBEQ,A1			; Place string in A1
				move.b	#-1,D5			; Set no size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iBEQ,-(SP)		; Push identifier to stack
				bra		printOp
				
tBVC			move.l	csscMsk,D1
				and.l	D7,D1
				cmpi.l	#$6800,D1		; Compare for bvc
				bne		tBVS			; Continue if !=
				lea		sBVC,A1			; Place string in A1
				move.b	#-1,D5			; Set no size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iBVC,-(SP)		; Push identifier to stack
				bra		printOp
				
tBVS			move.l	csscMsk,D1
				and.l	D7,D1
				cmpi.l	#$6900,D1		; Compare for bvs
				bne		tBPL			; Continue if !=
				lea		sBVS,A1			; Place string in A1
				move.b	#-1,D5			; Set no size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iBVS,-(SP)		; Push identifier to stack
				bra		printOp
				
tBPL			move.l	csscMsk,D1
				and.l	D7,D1
				cmpi.l	#$6A00,D1		; Compare for bpl
				bne		tBMT			; Continue if !=
				lea		sBPL,A1			; Place string in A1
				move.b	#-1,D5			; Set no size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iBPL,-(SP)		; Push identifier to stack
				bra		printOp
				
tBMT			move.l	csscMsk,D1
				and.l	D7,D1
				cmpi.l	#$6B00,D1		; Compare for bmi
				bne		tBGE			; Continue if !=
				lea		sBMI,A1			; Place string in A1
				move.b	#-1,D5			; Set no size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iBMI,-(SP)		; Push identifier to stack
				bra		printOp
				
tBGE			move.l	csscMsk,D1
				and.l	D7,D1
				cmpi.l	#$6C00,D1		; Compare for bge
				bne		tBLT			; Continue if !=
				lea		sBGE,A1			; Place string in A1
				move.b	#-1,D5			; Set no size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iBGE,-(SP)		; Push identifier to stack
				bra		printOp
				
tBLT			move.l	csscMsk,D1
				and.l	D7,D1
				cmpi.l	#$6D00,D1		; Compare for blt
				bne		tBGT			; Continue if !=
				lea		sBLT,A1			; Place string in A1
				move.b	#-1,D5			; Set no size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iBLT,-(SP)		; Push identifier to stack
				bra		printOp
				
tBGT			move.l	csscMsk,D1
				and.l	D7,D1
				cmpi.l	#$6E00,D1		; Compare for bgt
				bne		tBLE			; Continue if !=
				lea		sBGT,A1			; Place string in A1
				move.b	#-1,D5			; Set no size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iBGT,-(SP)		; Push identifier to stack
				bra		printOp
				
tBLE			move.l	csscMsk,D1
				and.l	D7,D1
				cmpi.l	#$6F00,D1		; Compare for ble
				bne		qqqq			; Branch to qqqq; unknown opcode
				lea		sBLE,A1			; Place string in A1
				move.b	#-1,D5			; Set no size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iBLE,-(SP)		; Push identifier to stack
				bra		printOp

; 0111 msB
csss			move.l	#$F100,D1		; Mask for moveq
				and.l	D7,D1
				cmpi.l	#$7000,D1		; Compare for moveq
				bne		qqqq			; Branch to qqqq; unknown opcode
				lea		sMOVEQ,A1		; Place string in A1
				move.b	#-1,D5			; Set no size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iMOVEQ,-(SP)	; Push identifier to stack
				bra		printOp

; 1000 msB
sccc			move.l	#$F1C0,D1		; Mask for divu.w
				and.l	D7,D1
				cmpi.l	#$80C0,D1		; Compare for divu.w
				bne		tOR				; Continue if !=
				lea		sDIVU,A1		; Place string in A1
				move.b	#$57,D5			; Place size in D5
				move.b	D5,-(SP)		; Push size to stack
				move.b	iDIVU,-(SP)		; Push identifier to stack
				bra		printOp
				
tOR				move.l	#$F000,D1		; Mask for or
				and.l	D7,D1
				cmpi.l	#$8000,D1		; Compare for or
				bne		qqqq			; Branch to qqqq; unknown opcode
				lea		sOR,A1			; Place string in A1
				move.b	#$6,D6			; Set size offset
				jsr		GetSize			; Get size of opcode
				move.b	D5,-(SP)		; Push size to stack
				move.b	iOR,-(SP)		; Push identifier to stack
				bra		printOp

; 1001 msB
sccs			move.l	#$F000,D1		; Mask for sub
				and.l	D7,d1
				cmpi.l	#$9000,D1		; Compare for sub
				bne		qqqq			; Branch to qqqq; unknown opcode
				lea		sSUB,A1			; Place string in A1
				move.b	#$6,D6			; Set size offset
				jsr		GetSize			; Get size of opcode
				move.b	D5,-(SP)		; Push size to stack
				move.b	iSUB,-(SP)		; Push identifier to stack
				bra		printOp

; 1011 msB
scss			move.l	#$F000,D1		; Mask for cmp
				and.l	D7,D1
				cmpi.l	#$B000,D1		; Compare for cmp
				bne		qqqq			; Branch to qqqq; unknown opcode
				lea		sCMP,A1			; Place string in A1
				move.b	#$6,D6			; Set size offset
				jsr		GetSize			; Get size of opcode
				move.b	D5,-(SP)		; Push size to stack
				move.b	iCMP,-(SP)		; Push identifier to stack
				bra		printOp

; 1100 msB
sscc			move.l	#$F1C0,D1		; Mask for mulsw
				and.l	D7,D1
				cmpi.l	#$C1C0,D1		; Compare for mulsw
				bne		tAND			; Continue if !=
				lea		sMULS,A1		; Place string in A1
				move.b	#$57,D6			; Place size in D6
				move.b	D5,-(SP)		; Push size to stack
				move.b	iMULS,-(SP)		; Push identifier to stack
				bra		printOp
				
tAND			move.l	#$F000,D1		; Mask for and
				and.l	D7,D1
				cmpi.l	#$C000,D1		; Compare for and
				bne		qqqq			; Branch to qqqq; unknown opcode
				lea		sAND,A1			; Place string in A1
				move.b	#$6,D6			; Set size offset
				jsr		GetSize			; Get size of opcode
				move.b	D5,-(SP)		; Push size to stack
				move.b	iAND,-(SP)		; Push identifier to stack
				bra		printOp

; 1101 msB
sscs			move.l	#$F000,D1		; Mask for add/adda
				and.l	D7,D1
				cmpi.l	#$D000,D1		; Compare for add/adda
				bra		adada

; 1110 msB
; Memory
sssc			move.l	#$FFC0,D1		; Mask for asr(mem)
				and.l	D7,D1
				cmpi.l	#$E0C0,D1		; Compare for asr(mem)
				bne		tASLm			; Continue if !=
				lea		sASR,A1			; Place string in A1
				move.b	#$57,D5			; Set W size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iASRm,-(SP)		; Push identifier to stack
				bra		printOp
				
tASLm			move.l	#$FFC0,D1		; Mask for asl(mem)
				and.l	D7,D1
				cmpi.l	#$E1C0,D1		; Compare for asl(mem)
				bne		tLSRm			; Continue if !=
				lea		sASL,A1			; Place string in A1
				move.b	#$57,D5			; Set W size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iASLm,-(SP)		; Push identifier to stack
				bra		printOp
				
tLSRm			move.l	#$FFC0,D1		; Mask for lsr(mem)
				and.l	D7,D1
				cmpi.l	#$E2C0,D1		; Compare for lsr(mem)
				bne		tLSLm			; Continue if !=
				lea		sLSR,A1			; Place string in A1
				move.b	#$57,D5			; Set W size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iLSRm,-(SP)		; Push identifier to stack
				bra		printOp
				
tLSLm			move.l	#$FFC0,D1		; Mask for lsl(mem)
				and.l	D7,D1
				cmpi.l	#$E3C0,D1		; Compare for lsl(mem)
				bne		tRORm			; Continue if !=
				lea		sLSL,A1			; Place string in A1
				move.b	#$57,D5			; Set W size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iLSLm,-(SP)		; Push identifier to stack
				bra		printOp
				
tRORm			move.l	#$FFC0,D1		; Mask for ror(mem)
				and.l	D7,D1
				cmpi.l	#$E6C0,D1		; Compare for ror(mem)
				bne		tROLm			; Continue if !=
				lea		sROR,A1			; Place string in A1
				move.b	#$57,D5			; Set W size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iRORm,-(SP)		; Push identifier to stack
				bra		printOp
				
tROLm			move.l	#$FFC0,D1		; Mask for rol(mem)
				and.l	D7,D1
				cmpi.l	#$E7C0,D1		; Compare for rol(mem)
				bne		tASRr			; Continue if !=
				lea		sROL,A1			; Place string in A1
				move.b	#$57,D5			; Set W size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iROLm,-(SP)		; Push identifier to stack
				bra		printOp
				
; Register
tASRr			move.l	#$F118,D1		; Mask for asr(reg)
				and.l	D7,D1
				cmpi.l	#$E000,D1		; Compare for asr(reg)
				bne		tASLr			; Continue if !=
				lea		sASR,A1			; Place string in A1
				move.b	#$6,D6			; Set size offset
				jsr		GetSize			; Get size of opcode
				move.b	D5,-(SP)		; Push size to stack
				move.b	iASRr,-(SP)		; Push identifier to stack
				bra		printOp
				
tASLr			move.l	#$F118,D1		; Mask for asl(reg)
				and.l	D7,D1
				cmpi.l	#$E100,D1		; Compare for asl(reg)
				bne		tLSRr			; Continue if !=
				lea		sASL,A1			; Place string in A1
				move.b	#$6,D6			; Set size offset
				jsr		GetSize			; Get size of opcode
				move.b	D5,-(SP)		; Push size to stack
				move.b	iASLr,-(SP)		; Push identifier to stack
				bra		printOp
				
tLSRr			move.l	#$F118,D1		; Mask for lsr(reg)
				and.l	D7,D1
				cmpi.l	#$E008,D1		; Compare for lsr(reg)
				bne		tLSLr			; Continue if !=
				lea		sLSR,A1			; Place string in A1
				move.b	#$6,D6			; Set size offset
				jsr		GetSize			; Get size of opcode
				move.b	D5,-(SP)		; Push size to stack
				move.b	iLSRr,-(SP)		; Push identifier to stack
				bra		printOp
				
tLSLr			move.l	#$F118,D1		; Mask for lsl(reg)
				and.l	D7,D1
				cmpi.l	#$E108,D1		; Compare for lsl(reg)
				bne		tRORr			; Continue if !=
				lea		sLSL,A1			; Place string in A1
				move.b	#$6,D6			; Set size offset
				jsr		GetSize			; Get size of opcode
				move.b	D5,-(SP)		; Push size to stack
				move.b	iLSLr,-(SP)		; Push identifier to stack
				bra		printOp
				
tRORr			move.l	#$F118,D1		; Mask for ror(reg)
				and.l	D7,D1
				cmpi.l	#$E018,D1		; Compare for ror(reg)
				bne		tROLr			; Continue if !=
				lea		sROR,A1			; Place string in A1
				move.b	#$6,D6			; Set size offset
				jsr		GetSize			; Get size of opcode
				move.b	D5,-(SP)		; Push size to stack
				move.b	iRORr,-(SP)		; Push identifier to stack
				bra		printOp
				
tROLr			move.l	#$F118,D1		; Mask for rol(reg)
				and.l	D7,D1
				cmpi.l	#$E118,D1		; Compare for rol(reg)
				bne		qqqq			; Branch to qqqq; unknown opcode
				lea		sROL,A1			; Place string in A1
				move.b	#$6,D6			; Set size offset
				jsr		GetSize			; Get size of opcode
				move.b	D5,-(SP)		; Push size to stack
				move.b	iROLr,-(SP)		; Push identifier to stack
				bra		printOp

; Unknown opcode, display as data
qqqq			jsr		HexPrint		; Perform the dark majicks
				move.b	#$9,D1			; Display tab
				move.b	#6,D0
				trap	#15
				lea		sDATA,A1		; Place string in A1
				move.b	#1,D0			; Display opcode string
				trap	#15
				move.b	#$9,D1			; Display tab
				move.b	#6,D0
				trap	#15
				move.w	(A0),A0			; Move data to A1
				jsr		HexPrint		; Print 'ze data
				rts
				
; Command return table for add's bull.
adada			move.l	#$01C0,D1		; Mask to identify add or adda
				and.l	D7,D1
				cmpi.l	#$00C0,D1		; Compare for addaw
				beq		addaw
				
				cmpi.l	#$01C0,D1		; Compare for addal
				beq		addal

addo									; Was not adda, so must be add
				move.l	D7,D1			; Move opcode to D1 for mutation
				lea		sADD,A1			; Place string in A1
				
				andi.l	#$00C0,D1		; Mask size
				
				cmpi.l	#$0000,D1		; Compare for byte
				beq		addb
				
				cmpi.l	#$0040,D1		; Compare for word
				beq		addw
				
				cmpi.l	#$0080,D1		; Compare for long
				beq		addl
				
				bra		addu			; Unknown size
				
addb			move.b	#$42,D5			; B
				bra		addf
				
addw			move.b	#$57,D5			; W
				bra		addf

addl			move.b	#$4C,D5			; L
				bra		addf

addu			move.b	#$3F,D5			; ?	Well, something funky happened...
				
addf			move.b	D5,-(SP)		; Push size to stack
				move.b	iADD,-(SP)		; Push identifier to stack
				bra		printOp

addaw			lea		sADDA,A1		; Place string in A1
				move.b	#$57,D6			; Set size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iADDA,-(SP)		; Push identifier to stack
				bra		printOp

addal			lea		sADD,A1			; Place string in A1
				move.b	#$4C,D6			; Set size
				move.b	D5,-(SP)		; Push size to stack
				move.b	iADD,-(SP)		; Push identifier to stack
				bra		printOp
				
printOp			jsr		HexPrint		; Perform the dark majicks
				
				move.b	#$9,D1			; Display tab
				move.b	#6,D0
				trap	#15

				move.b	#1,D0			; Display opcode string
				trap	#15
				
				tst.b	D5				; Test size code
				bmi		skpSize			; Skip printing size if - (use -1 to denote no size)
				
				move.b	#6,D0			; Display char
				move.b	#$2E,D1			; '.'
				trap	#15
				
				move.b	D5,D1			; Display size code
				trap	#15	
				
skpSize			move.b	#$9,D1			; Display tab
				move.b	#6,D0
				trap	#15

endsub			jsr		EA_DECODER		; Jump to whatever the EA decoder
				move.w 	(SP)+,D0		; Pop out opcode
				;tst.b	D5				; Test size code
				;bmi		returnLod		; Return to loader if no size
				move.w	(SP)+,D0		; Pop out size
returnLod		rts
				
;----------------------------------------------------------------------------------------------------------------------------

GetSize			move.l	D7,D5			; Copy machine code for manupulation
				lsr		D6,D5			; Shift D5 to offset
				andi.l	#$0003,D5		; Remove all bits but 0 and 1
				cmp.b	#$0,D5			; Compare for byte
				beq		siByte
				cmp.b	#$1,D5			; Compare for word
				beq		siWord
				cmp.b	#$2,D5			; Compare for long
				beq		siLong
				bra		siUnk			; Unknown size
				
siByte			move.b	#$42,D5			; B
				rts						; Our work here is done.
				
siWord			move.b	#$57,D5			; W
				rts						; Our work here is done.
				
siLong			move.b	#$4C,D5			; L
				rts						; Our work here is done.
				
siUnk			move.b	#$3F,D5			; ?	Well, something funky happened...
				rts						; This will probably break things.
;-END SUB--------------------------------------------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------------------------------------------
GetMSize		move.l	D7,D5			; Copy machine code for manupulation
				movea.l	SP,A2			; Get SP
				adda.l	#$4,A2			; Increment our SP
				move.b	(A2),D4			; Move identifier to D4
				cmp.b	iMOVEM,D4		; Check for MOVEM
				bne		msiae
				; Handle MOVEM
msim			lsr.l	#6,D5			; Shift to expose size
				and.l	#$1,D5			; Mask size bit
				addi.b	#3,D5			; Raise word to 3, long to 4
				bra		msconv
				; Handle MOVE, MOVEA
msiae			swap	D5
				rol.l	#4,D5			; Shift to expose size

				; Convert to char
msconv			cmp.b	#$1,D5			; Compare for byte
				beq		msiByte
				cmp.b	#$3,D5			; Compare for word
				beq		msiWord
				cmp.b	#$2,D5			; Compare for long
				beq		msiLong
				cmp.b	#$4,D5			; Compare for long MOVEM
				beq		msiLong
				bra		msiUnk			; Unknown size
				
msiByte			move.b	#$42,D5			; B
				rts						; Our work here is done.
				
msiWord			move.b	#$57,D5			; W
				rts						; Our work here is done.
				
msiLong			move.b	#$4C,D5			; L
				rts						; Our work here is done.
				
msiUnk			move.b	#$3F,D5			; ?	Well, something funky happened...
				rts						; This will probably break things.
;-END SUB--------------------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------------
HexPrint		move.b	#28,D4			; Initialize counter
salemLoop		tst.b	D4				; Test counter
				bmi		endWitchHunt	; Break loop if end reached
				move.l	A0,D1			; Copy hex number to workspace
				lsr.l	D4,D1			; Shift workspace to expose
				andi.b	#$0F,D1			; Mask off $10's place
				cmpi.b	#$9,D1			; Compare hex digit to $9
				ble		cursedNumeric	; If numeric, skip next part
				addi.b	#$7,D1			; Add $7 to hex digit if alpha
cursedNumeric	addi.b	#$30,D1			; Add $30 to hex digit to raise to ASCII
				move.b	#6,D0			; Display buffer char
				trap	#15
				subi.b	#4,D4			; Increment counter
				bra		salemLoop		; Continue
endWitchHunt	rts						; No more drownings
				
;-END SUB--------------------------------------------------------------------------------------------------------------------

				include	"./EA_Decoder.X68"

; Opcode String table
sADD			dc.b	'ADD',0
sADDA			dc.b	'ADDA',0
sADDI			dc.b	'ADDI',0
sADDQ			dc.b	'ADDQ',0
sAND			dc.b	'AND',0
sASL			dc.b	'ASL',0
sASR			dc.b	'ASR',0
sBCT			dc.b	'BCT',0
sBCF			dc.b	'BCF',0
sBT				dc.b	'BT',0
sBF				dc.b	'BF',0
sBHI			dc.b	'BHI',0
sBLS			dc.b	'BLS',0
sBHS			dc.b	'BHS',0
sBCC			dc.b	'BCC',0
sBLO			dc.b	'BLO',0
sBCS			dc.b	'BCS',0
sBNE			dc.b	'BNE',0
sBEQ			dc.b	'BEQ',0
sBVC			dc.b	'BVC',0
sBVS			dc.b	'BVS',0
sBPL			dc.b	'BPL',0
sBMI			dc.b	'BMI',0
sBGE			dc.b	'BGE',0
sBLT			dc.b	'BLT',0
sBGT			dc.b	'BGT',0
sBLE			dc.b	'BLE',0
sCLR			dc.b	'CLR',0
sCMP			dc.b	'CMP',0
sDIVU			dc.b	'DIVU',0
sJSR			dc.b	'JSR',0
sLEA			dc.b	'LEA',0
sLSL			dc.b	'LSL',0
sLSR			dc.b	'LSR',0
sMOVE			dc.b	'MOVE',0
sMOVEA			dc.b	'MOVEA',0
sMOVEM			dc.b	'MOVEM',0
sMOVEQ			dc.b	'MOVEQ',0
sMULS			dc.b	'MULS',0
sNOP			dc.b	'NOP',0
sOR				dc.b	'OR',0
sROL			dc.b	'ROL',0
sROR			dc.b	'ROR',0
sRTS			dc.b	'RTS',0
sSUB			dc.b	'SUB',0
sDATA			dc.b	'*DATA*',0

; Buffer for witchcraft (hex conversion)
HexBuffer		ds.l	1

; Opcode Identifier Table
iADDI			dc.b	$00
iMOVE			dc.b	$01
iMOVEA			dc.b	$02

iCLR			dc.b	$10
iDIVU			dc.b	$11
iMULS			dc.b	$12
iNOP			dc.b	$13
iRTS			dc.b	$14
iJSR			dc.b	$15
iMOVEM			dc.b	$16
iLEA			dc.b	$17

iADDQ			dc.b	$20

iBT				dc.b	$30
iBF				dc.b	$31
iBHI			dc.b	$32
iBLS			dc.b	$33
iBCC			dc.b	$34
iBCS			dc.b	$35
iBNE			dc.b	$36
iBEQ			dc.b	$37
iBVC			dc.b	$38
iBVS			dc.b	$39
iBPL			dc.b	$3A
iBMI			dc.b	$3B
iBGE			dc.b	$3C
iBLT			dc.b	$3D
iBGT			dc.b	$3E
iBLE			dc.b	$3F

iMOVEQ			dc.b	$40

iOR				dc.b	$50

iSUB			dc.b	$60

iCMP			dc.b	$70

iAND			dc.b	$80

iADD			dc.b	$90
iADDA			dc.b	$91

iASRm			dc.b	$A0
iASLm			dc.b	$A1
iLSRm			dc.b	$A2
iLSLm			dc.b	$A3
iRORm			dc.b	$A4
iROLm			dc.b	$A5
iASRr			dc.b	$A6
iASLr			dc.b	$A7
iLSRr			dc.b	$A8
iLSLr			dc.b	$A9
iRORr			dc.b	$AA
iROLr			dc.b	$AB

fBtMsk			dc.l	$F000
csscMsk			dc.l	$FF00


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
