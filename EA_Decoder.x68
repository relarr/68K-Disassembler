 *-----------------------------------------------------------
* Title      : EA_DECODER
* Written by : Erick Larrea
* Date       : 02/12/2017
*-----------------------------------------------------------  

                
    
***************************************************************************************
*                   Subroutines for EA
***************************************************************************************
EA_DECODER
    
GET_OPCODE
    move.l      SP,A0
    adda.l      #4,A0
    move.b		(A0),D0
    move        d0,a5

    move.l      d7,d3
    
    cmpi.b        #$00,d0
    beq         ADDI
    cmpi.b        #$01,d0
    beq         MOVE_EA
    cmpi.b        #$02,d0
    beq         MOVE_EA
    cmpi.b        #$10,d0
    beq         MOVEMLEACLRJSR
    cmpi.b        #$11,d0
    beq         DIVUOR
    cmpi.b        #$12,d0
    beq         MULSAND
    cmpi.b        #$13,d0
    beq         NOP   
    cmpi.b        #$14,d0  
    beq         RTS
    cmpi.b        #$15,d0
    beq         MOVEMLEACLRJSR
    cmpi.b        #$16,d0
    beq         MOVEM
    cmpi.b        #$17,d0
    beq         MOVEMLEACLRJSR
    cmpi.b        #$20,d0
    beq         ADDQ_SUBI
    cmpi.b        #$34,d0
    beq         BCCBGTBLE
    cmpi.b        #$3E,d0
    beq         BCCBGTBLE
    cmpi.b        #$3F,d0
    beq         BCCBGTBLE
    cmpi.b        #$40,d0
    beq         MOVEQ
    cmpi.b        #$50,d0
    beq         DIVUOR
    cmpi.b        #$60,d0
    beq         SUB
    cmpi.b        #$70,d0
    beq         CMP
    cmpi.b        #$80,d0
    beq         MULSAND
    cmpi.b        #$90,d0
    beq         ADD
    cmpi.b        #$91,d0
    beq         ADD
    cmpi.b        #$A0,d0
    beq         COMPARE2
    cmpi.b        #$A1,d0
    beq         COMPARE2      
    cmpi.b        #$A2,d0
    beq         COMPARE2 
    cmpi.b        #$A3,d0
    beq         COMPARE2  
    cmpi.b        #$A4,d0
    beq         COMPARE2 
    cmpi.b        #$A5,d0
    beq         COMPARE2
    cmpi.b        #$A6,d0
    beq         COMPARE2
    cmpi.b        #$A7,d0
    beq         COMPARE2
    cmpi.b        #$A8,d0
    beq         COMPARE2
    cmpi.b        #$A9,d0
    beq         COMPARE2
    cmpi.b        #$AA,d0
    beq         COMPARE2
    cmpi.b        #$AB,d0
    beq         COMPARE2


SOURCE_MODE
    ; shift the proper bits to the right end to check the source mode
    move        d3,d7
    move.b      TEN,d4              ; TEN bits to be logically shifted left              
    move.b      THIRTEEN,d5         ; THIRTEEN bits to be logically shifted right
    lsl.w       d4,d7               ; left shift the machine code
    lsr.w       d5,d7               ; right shift the machine code
    rts
    
SOURCE_REGISTER
    ; shift the proper bits to the right end to check the source register   
    move        d3,d1
    move.b      THIRTEEN,d4         ; THIRTEEN bits to be logically shifted leftand right
    lsl.w       d4,d1               ; left shift the machine code
    lsr.w       d4,d1               ; right shift the machine code
    rts
    
IMMEDIATE_INFO
    ; grab the immediate data information for move
    move        d3,d6
    move.b      THIRTEEN,d4         ; THIRTEEN bits to be logically shifted left and right
    lsl.w       d4,d6               ; left shift the machine code
    lsr.w       d5,d6               ; right shift the machine code 
    rts
    
SHIFT_8_14
    move        d3,d7               ; left and right shift the machine code 8 and 14 bits respectively
    move.b      EIGHT,d4
    move.b      FOURTEEN,d5
    lsl.w       d4,d7
    lsr.w       d5,d7
    rts
    
SHIFT_8_12
    move        d3,d7               ; 
    move.b      EIGHT,d4
    move.b      TWELVE,d5
    lsl.w       d4,d7
    lsr.w       d5,d7
    rts
    
SHIFT_7_13                          ; shift SEVEN and THIRTEEN
    move        d3,d7
    move.b      SEVEN,d4
    move.b      THIRTEEN,d5
    lsl.w       d4,d7
    lsr.w       d5,d7
    rts
    
SHIFT_7_10
    move        d3,d7
    move.b      SEVEN,d4
    move.b      TEN,d5
    lsl.w       d4,d7
    lsr.w       d5,d7
    rts
    
SHIFT_6_13
    move        d3,d7
    move.b      SIX,d4
    move.b      THIRTEEN,d5
    lsl.w       d4,d7
    lsr.w       d5,d7
    rts
    
SHIFT_4_13 
    move        d3,d1                       
    move.b      FOUR,d4             ; FOUR bits to be logically shifted left
    move.b      THIRTEEN,d5         ; THIRTEEN bits to be logically shifted right
    lsl.w       d4,d1               ; left shift the machine code
    lsr.w       d5,d1               ; right shift the machine code
    rts
    
SHIFT_4_12
    move        d3,d1
    move.b      FOUR,d4
    move.b      TWELVE,d5
    lsl.w       d4,d1
    lsr.w       d5,d1
    rts
    
SHIFT_2_12
    move        d3,d1
    move.b      TWELVE,d4
    lsr.w       d4,d1
    rts
    
SHIFT_4_10
    move        d3,d7
    move.b      FOUR,d4
    move.b      TEN,d5
    lsl.w       d4,d7
    lsr.w       d5,d7
    rts
    
SHIFT_13
    move        d3,d1
    move.b      THIRTEEN,d4
    lsl.w       d4,d1
    lsr.w       d4,d1
    rts  
    
SHIFT_12
    move        d3,d1
    move.b      TWELVE,d4
    lsl.w       d4,d1
    lsr.w       d4,d1
    rts
    
SHIFT_8
    move        d3,d7
    move.b      EIGHT,d4
    lsl.w       d4,d7
    lsr.w       d4,d7
    rts
        
OPMODE
    move        d3,d6
    move.b      SEVEN,d4
    move.b      THIRTEEN,d5
    lsl.w       d4,d6
    lsr.w       d5,d6
    rts   

NOP
    rts    


RTS
    rts    
MOVE_EA
    jsr         SOURCE_MODE
    jsr         SOURCE_REGISTER
    jsr         IMMEDIATE_INFO
    jsr         COMPARE             ; jump to subroutine COMPARE
    jsr         PRINT_COMMA         ; jump to subroutine PRINT_COMMA
    jsr         SHIFT_7_13
    jsr         SHIFT_4_13 
    jsr         COMPARE             ; jump to subroutine COMPARE
 
      rts
    
MOVEQ   
    move.w      (a2),d7             ; copy the current machine code
    move.b      d7,d1               ; copy the byte from d7,d1
    lea         POUND_SIGN,a1       ; load POUND_SIGN into a1
    
    move.b      #14,d0              ; task 14 to display
    trap        #15                 ; display
    move.b      #3,d0               ; task 3 to print hex as decimal
    trap        #15                 ; display
    
    jsr         PRINT_COMMA         ; jump to subroutine PRINT_COMMA
    jsr         SHIFT_7_13
    jsr         SHIFT_4_13
    jsr         COMPARE             ; jump to subroutine COMPARE
    rts
    
ADDI
    move.w      #7,d7
    move.w      #4,d6
    
    jsr         COMPARE
    jsr         PRINT_COMMA
    
    jsr         SOURCE_MODE
    jsr         IMMEDIATE_INFO
    jsr         SHIFT_13
    
    cmpi.b      #%0001,d6
    beq         INCREASE_ADDI
FINALIZE
    jsr         COMPARE
    rts  

INCREASE_ADDI
    move.l      $FFFFFC,a2
    adda        #2,a2
    bra         FINALIZE 
  
ADD
    move        d3,d7
    btst        #8,d7
    beq         DR_ADDSUBAND
    
    bra         EA_ADDSUBAND
    
ADDQ_SUBI
    lea         POUND_SIGN,a1       ; load POUND_SIGN into a1
    move.b      #14,d0              ; task 14 to display
    trap        #15                 ; display

    jsr         SHIFT_4_13
    
    cmpi.b      #%0000,d1           ; check if the data is for 8
    beq         PRINT_EIGHT         ; if yes, branch to the label PRINT_EIGHT
    move.b      #3,d0               ; task 3 to print hex as decimal
    trap        #15                 ; display

    jsr         PRINT_COMMA         ; jump to the subroutine PRINT_COMMA
    
    jsr         SOURCE_MODE

    jsr         SHIFT_13
    
    jsr         COMPARE             ; jump to the subroutine COMPARE
    rts

SUB
    move.w      d3,d7
    btst        #8,d7               ; check for the porper syntax
    beq         DR_ADDSUBAND
    
    bra         EA_ADDSUBAND

MULSAND
    jsr         SHIFT_7_13
    
    cmpi        #%111,d7
    bne         AND
    bra         MULS

AND
    move.w      d3,d7       
    btst        #8,d7               ; check for the proper syntax
    beq         DR_ADDSUBAND
    
    bra         EA_ADDSUBAND
            
DR_ADDSUBAND
    jsr         SOURCE_MODE         ; jump to SOURCE_MODE
    
    jsr         SHIFT_4_13          ; shift the proper bits
    move        d1,d6
    jsr         SHIFT_13            ; shift 13 bits
    
    jsr         COMPARE             ; jump to COMPARE
    jsr         PRINT_COMMA         ; jump to PRINT_COMMA
    
    move        #0,d7
    
    jsr         IMMEDIATE_INFO
    jsr         SHIFT_4_13
    jsr         COMPARE             ; jump to COMPARE
    
    rts
    
EA_ADDSUBAND
    move        #0,d7
    jsr         SHIFT_4_13          ; shift the proper bits
    
    jsr         COMPARE             ; jump to COMpARE
    jsr         PRINT_COMMA         ; jump to PRINT_COMMA 
    
    jsr         SOURCE_MODE         ; jump to SOURCE_MODE
    jsr         IMMEDIATE_INFO      ; jump to IMMEDIATE_INFO
    jsr         SHIFT_13
    
    jsr         COMPARE             ; jump to COMPARE
    rts
    

MULS
    jsr         SOURCE_MODE         ; jumpt to COMPARE
    jsr         SOURCE_REGISTER     ; jump to SOURCE_REGISTER
    
    jsr         IMMEDIATE_INFO      ; jump to IMMEDIATE_INFO
    
    jsr         COMPARE             ; jump to COMPARE
    jsr         PRINT_COMMA         ; jump to PRINT_COMMA
    
    jsr         SHIFT_4_13          ; shift the proper bits
    jsr         DRD                 ; jump to DRD
    rts
 
DIVUOR
    jsr         SHIFT_7_13
    cmpi        #%011,d7
    beq         DIVU
    bra         OR

DIVU
    jsr         SOURCE_MODE         ; shift the proper bits
    jsr         SOURCE_REGISTER
    
    jsr         IMMEDIATE_INFO
    
    jsr         COMPARE
    jsr         PRINT_COMMA
    
    jsr         SHIFT_4_13
    jsr         DRD                 ; jumpt to DRD
    rts
    
OR
    cmpi        #%000,d7            ; check for the correct syntax
    beq         EATODN
    cmpi        #%001,d7
    beq         EATODN
    cmpi        #%010,d7
    beq         EATODN
    bra         DNTOEA
    
EATODN
    jsr         SOURCE_MODE         ; shift the proper bits
    jsr         SHIFT_13
    
    jsr         COMPARE
    jsr         PRINT_COMMA
    
    clr         d7
    move        #0,d7
    jsr         SHIFT_4_13
    
    jsr         COMPARE
    rts
    
DNTOEA

    clr         d7
    move        #0,d7
    jsr         SHIFT_4_13          ; shift the proper bits

    jsr         COMPARE
    jsr         PRINT_COMMA

    jsr         SOURCE_MODE
    jsr         SHIFT_13

    jsr         COMPARE             ; jump to COMPARE
    rts
    
MOVEMLEACLRJSR
    jsr         SHIFT_6_13          ; shift the proper bits
    cmpi        #%001,d7
    beq         MOVEM               ; jump to MOVEM
    
    jsr         SHIFT_7_13
    cmpi        #%111,d7
    beq         LEA
    
    jsr         SHIFT_4_12          ; shift the proper bits
    cmpi        #%0010,d1
    beq         CLR
    cmpi        #%1110,d1
    beq         JSR                 ; branch to JSR
    
MOVEM
    jsr         SOURCE_MODE         ; shift the proper bits
    jsr         SHIFT_13
    
    move.b      d7,MODE             ; save d7 into MODE
    move.b      d1,REGISTER         ; save d1 into REGISTER
    
    move.l      $FFFFFC,a2          ; copy the machine code
    movea.l     a2,a0
    move        (a0),d3
    move        d3,MACHINE_CODE
    
    btst        #6,d3
    beq         WORD_SIZE           ; branch to WORD_SIZE
    
WORD_SIZE
    move.b      #1,MOVEM_SIZE       
    
DIRECT
    btst        #10,d3
    beq         SKIP                ; branch to SKIP
    
    clr.l       d2
    clr.l       d3                  ; clear registers
    clr.l       d4
    
    move.b      MODE,d2             ; move variables to proper registers
    move.b      REGISTER,d3
    move.b      MOVEM_SIZE,d4
    
    adda        #2,a2               ; increment
    
    move.b      MODE,d7
    move.b      REGISTER,d1
    
    jsr         COMPARE
    
    suba        #2,a2
    movea.l     a2,a0
    
    jsr         PRINT_COMMA         ; jump to PRINT_COMMA
    bra         SKIP                ; branch to SKIP
    
SKIP
    adda.l      #2,a0               ; increment
    
    clr.l       d6
    move        (a0),d6
    
    clr.l       d7
    
MOVEMLOOP1
    move.b      #15,d7              ; save in variables for later use
    move.b      #17,MONE
    move.b      #17,MTWO
    move.b      #0,MTHREE
    
MOVEMLOOP2
    btst        d7,d6
    bne         MOVEMLOOP3          ; branch to the next loop
    
    cmpi.b      #17,MONE
    beq         MOVEMLOOP5          ; branch to the next loop
    
    jsr         PRINT
    bra         MOVEMLOOP5          ; branch to the next loop
    
MOVEMLOOP3
    cmpi.b      #7,d7
    bne         MOVEMLOOP4          ; branch to the next loop
    
    cmpi.b      #17,MONE
    beq         MOVEMLOOP4
    
    jsr         PRINT
    
MOVEMLOOP4
    move.b      d7,MTWO
    
    cmpi.b      #17,MONE
    bne         MOVEMLOOP5          ; branch to the next loop
    
    move.b      d7,MONE
    bra         MOVEMLOOP5
    
MOVEMLOOP5
    sub.b       #1,d7
    
    cmpi.b      #0,d7
    bge         MOVEMLOOP2          ; branch to the next loop
    
    cmpi.b      #17,MONE
    beq         MOVEMEA
    jsr         PRINT               ; jumpt to PRINT
    
MOVEMEA
    move.w      MACHINE_CODE,d3     ; save the machine code for later use
    btst        #10,d3
    bne         EASKIP              ; branch to EASKIP
    
    clr.l       d2
    clr.l       d3                  ; clear registers
    clr.l       d4
    
    move.b      REGISTER,d1
    move.b      MOVEM_SIZE,d6
    move.b      MODE,d7
    
    jsr         PRINT_COMMA
    
    adda        #2,a2
    jsr         COMPARE
    suba        #2,a2
    
EASKIP
    adda.l      #2,a2               ; increment
    move        #2,d2
    rts
   
PRINT
    move.b      MTHREE,d5
    cmpi.b      #1,d5
    blt         MOVEMSTART
    
    lea         SLASH,a1            ; print the slash
    move.b      #14,d0
    trap        #15
    
MOVEMSTART
    move.b      MODE,d0
    cmpi.b      #4,d0
    beq         PRINT2
    
    move.b      MONE,d5
    cmpi.b      #7,d5
    bgt         RETMOVEM
    jsr         PRINT6
    bra         NEXT
    
RETMOVEM
    jsr         PRINT4                ; return to PRINT4
    
NEXT
    move.b      MTWO,d0
    cmp.b      MONE,d0
    beq         PRINT5
    
    LEA         MINUS,a1
    move.b      #14,d0
    trap        #15
    
    move.b      MTWO,d5
    cmpi.b      #7,d5
    bgt         RETMOVEM2
    
    jsr         PRINT6
    bra         PRINT5
    
RETMOVEM2
    jsr         PRINT4
    
PRINT5
    move.b      #17,MONE
    move.b      #17,MTWO
    move.b      #1,MTHREE
    rts
    
PRINT2
    move.b      MONE,d5
    cmpi.b      #7,d5
    bgt         MOVEMOP
    
    jsr         MOVEMOPTS
    jsr         PRINT4

    bra         NEXT2

MOVEMOP
    sub.b       #8,d5
    jsr         MOVEMOPTS
    jsr         PRINT6

NEXT2
    move.b      MTWO,d0
    cmp.b      MONE,d0
    beq         PRINT5

    lea         MINUS,a1
    move.b      #14,d0
    trap        #15

    move.b      MTWO,d5
    cmpi.b      #7,d5
    bgt         MOVEMOP2

    jsr         MOVEMOPTS
    jsr         PRINT4
    bra         PRINT5

MOVEMOP2
    sub.b       #8,d5
    jsr         MOVEMOPTS
    jsr         PRINT6

    bra         PRINT5
    
PRINT6
    lea         DATA_REGISTER,a1
    move.b      #14,d0
    trap        #15
    
    bra         PRINT7
    
PRINT4
    lea         ADDRESS_REGISTER,a1
    move.b      #14,d0
    trap        #15
    
    bra         PRINT7
    
PRINT7
    cmpi.b      #8,d5
    blt         SKIP2
    sub.b       #8,d5
    
SKIP2
    move.l      d5,d1
    move.b      #3,d0
    trap        #15
    
    rts
    
MOVEMOPTS
    cmpi.b      #0,d5
    bne         OPT1
    move.b      #7,d5
    rts
    
OPT1
    cmpi.b      #1,d5
    bne         OPT2
    move.b      #6,d5
    rts
    
OPT2
    cmpi.b      #2,d5
    bne         OPT3
    move.b      #5,d5
    rts
    
OPT3
    cmpi.b      #3,d5
    bne         OPT4
    move.b      #4,d5
    rts
    
OPT4
    cmpi.b      #4,d5
    bne         OPT5
    move.b      #3,d5
    rts
    
OPT5
    cmpi.b      #5,d5
    bne         OPT6
    move.b      #2,d5
    rts
    
OPT6
    cmpi.b      #6,d5
    bne         OPT7
    move.b      #1,d5
    rts
    
OPT7
    move.b      #0,d5
    rts

LEA
    jsr         SOURCE_MODE
    jsr         SHIFT_13
    
    jsr         COMPARE
    jsr         PRINT_COMMA
    
    move        #1,d7
    jsr         SHIFT_4_13
    
    jsr         COMPARE
    rts
    
CLR
    jsr         SOURCE_MODE
    jsr         SHIFT_13
    jsr         IMMEDIATE_INFO
    jsr         COMPARE
    rts
    
JSR
    jsr         SOURCE_MODE
    jsr         SHIFT_13
    jsr         COMPARE
    rts
    
LSL
    jsr         SHIFT_8_14
    cmpi.b      #%11,d7
    beq         MEMORY
    
    move.w      (a2),d7
    btst        #5,d7
    beq         BITFIVEZERO
    
    bra         BITFIVEONE
   
MEMORY
    jsr         SOURCE_MODE
     
    jsr         SHIFT_13
    move        d1,d6

    jsr         COMPARE
    rts
   
BITFIVEZERO
    lea         DOLLAR_SIGN,a1
    move.b      #14,d0
    trap        #15
    
    jsr         SHIFT_4_13
    cmp.b       #0,d1
    beq         ZEROCASE
    
CASE
    move.b      #3,d0
    trap        #15
    
    jsr         PRINT_COMMA
    jsr         SHIFT_13
    
    move.w      #0,d7
    jsr         COMPARE
    
    rts
    
ZEROCASE
    move.w      #8,d1
    bra         CASE
    
BITFIVEONE
    move.w      #0,d7
    jsr         SHIFT_4_13

    jsr         COMPARE
    jsr         PRINT_COMMA
    
    jsr         SHIFT_13
    move.w      #0,d7
    
    jsr         COMPARE
    rts
    
PRINT_EIGHT
    move.b      #%1000,d1           ; move 8 in binary to d1
    move.b      #3,d0               ; task 3 to print hex as decimal
    trap        #15                 ; display
    
    jsr         PRINT_COMMA         ; jump to the subroutine PRINT_COMMA
    
    move.w      (a2),d7             ; copy the current machine code into d7

    jsr         SOURCE_MODE
    
    jsr         SHIFT_13
   
    jsr         COMPARE             ; jump to subroutine COMPARE
    rts

COMPARE
    cmpi.b      #%0000,d7           ; check if the type of source mode is for data register direct
    beq         DRD                 ; if equal, branch to the label DRD(data register direct)
    cmpi.b      #%0001,d7           ; check if the type of source mode is for address register direct(for source only)
    beq         ARD                 ; if equal, branch to the label ARD(address register direct)
    cmpi.b      #%0010,d7           ; check if the type of source mode is for address register indirect
    beq         ARI                 ; if equal, branch to the label ARI
    cmpi.b      #%0011,d7           ; check if the type of source mode is for ARI with post increment
    beq         ARIPI               ; if equal, branch to the label ARIPI
    cmpi.b      #%0100,d7           ; check if the type of source mode is for ARI with pre decrement
    beq         ARIPD               ; if equal, branch to the label ARIPD
    cmpi.b      #%0111,d7           ; check if the type of source mode is for immediate or absolute addressing 
    beq         IMMABS              ; branch to the label IMMABS
 
COMPARE2
    move.w      (a2),d7
    jsr         SHIFT_4_10          ; jump to SHIFT_4_10
    
    andi.b      #%00111111,d7       
    
    cmpi.b      #%00001111,d7
    beq         LSL                 ; check for LSL
    cmpi.b      #%00001011,d7
    beq         LSR                 ; chech for LSR
    cmpi.b      #%00000011,d7
    beq         ASR                 ; check for ASR
    cmpi.b      #%00000111,d7
    beq         ASL                 ; check for ASL
    cmpi.b      #%00011111,d7
    beq         ROL                 ; check for ROL
    cmpi.b      #%00011011,d7
    beq         ROR                 ; check for ROR
    
    jsr         SHIFT_7_10        
    andi.b      #%00100011,d7
    
    cmpi.b      #%00100001,d7
    beq         LSL                 ; check for LSL
    cmpi.b      #%00000001,d7
    beq         LSR                 ; check for LSR
    cmpi.b      #%00000000,d7
    beq         ASR                 ; chech for ASR
    cmpi.b      #%00100000,d7
    beq         ASL                 ; check for ASL
    cmpi.b      #%00100011,d7
    beq         ROL                 ; check for ROL
    cmpi.b      #%00000011,d7
    beq         ROR                 ; check for ROR

LSR
    jsr         SHIFT_8_14          ; shift the proper bits
    cmpi.b      #%11,d7
    beq         MEMORY              ; branch to memory
    
    move.w      (a2),d7
    btst        #5,d7
    beq         BITFIVEZERO         ; branch to BITFIVEZERO
    
    bra         BITFIVEONE          ; branch to BITFIVEONE

ASR     
    jsr         SHIFT_8_14          ; shift the proper bits
    cmpi.b      #%11,d7
    beq         MEMORY              ; branch to MEMORY
    
    move.w      (a2),d7
    btst        #5,d7
    beq         BITFIVEZERO         ; branch to BITFIVEZERO
    
    bra         BITFIVEONE          ; branch to BITFIVEONE

ASL     
    jsr         SHIFT_8_14          ; shift the proper bits
    cmpi.b      #%11,d7
    beq         MEMORY              ; branch to MEMORY
    
    move.w      (a2),d7
    btst        #5,d7
    beq         BITFIVEZERO         ; branch to BITFIVEZERO
    
    bra         BITFIVEONE          ; branch to BITFIVEONE

ROL
    jsr         SHIFT_8_14          ; shift the proper bits
    cmpi.b      #%11,d7
    beq         MEMORY              ; brancjh to MEMORY
        
    move.w      (a2),d7
    btst        #5,d7
    beq         BITFIVEZERO         ; branch to BITFIVEZERO
    
    bra         BITFIVEONE          ; branch to BITFIVEONE
    
ROR
    jsr         SHIFT_8_14          ; shift the proper bits
    cmpi.b      #%11,d7
    beq         MEMORY              ; branch to MEMORY
    
    move.w      (a2),d7
    btst        #5,d7
    beq         BITFIVEZERO         ; branch to BITFIVEZERO
    
    bra         BITFIVEONE          ; branch to BITFIVEONE
   
CMP
    jsr         SOURCE_MODE         ; shift the proper bits
    jsr         SHIFT_13
    move        d1,d6
    
    jsr         COMPARE             ; jump to COMPARE
    jsr         PRINT_COMMA         ; jump to PRINT_COMMA
    
    move        #0,d7
    jsr         SHIFT_4_13          ; shift the proper bits
    
    jsr         COMPARE             ; jump to COMPARE
    rts
    

BCCBGTBLE
    clr.l       d2
    jsr         SHIFT_8_12          ; shift the proper bits
    jsr         SHIFT_12
    
    cmpi.b      #%0000,d7
    beq         EXTRA_WORD          ; branch to EXTRA_WORD
    
    bra         CONT                ; branch to CONT
    
EXTRA_WORD
    cmpi        #%0000,d1
    beq         INCREASE_ADDRESS    ; branch to INCREASE_ADDRESS
    
INCREASE_ADDRESS
    move        #2,d2               ; move 2 to update the memory address in the loader
    
CONT
    move        d3,d7
    cmpi.b      #$00,d7             ; check for the correct displacement
    beq         SIXTEEN
    cmpi.b      #$FF,d7
    beq         THIRTYTWO
  
SIXTEEN
    move.l      $FFFFFC,a2          ; copy machine code
    movea       a2,a0
    adda        #2,a0               ; increment


    jsr         SHIFT_8             ; shift 8 bits

    adda        d7,a0
    
    move        a0,d7
    move        #8,d6
    
    jsr         PRINT_ADDRESS       ; jump to PRINT_ADDRESS
    adda        #2,a2
    
    rts
    
THIRTYTWO
    move.l      $FFFFFC,a2          ; copy the machine code
    movea       a2,a0
    adda        #2,a0
    
    jsr         SHIFT_8             ; shift 8 bits
        
    adda        d7,a0
    
    move        a0,d7
    move        #8,d6
    
    jsr         PRINT_ADDRESS       ; jump to PRINT_ADDRESS
    adda        #4,a2
    
    rts

PRINT_ADDRESS
    lea         HEXS,a6             ; load list of HEXS in a6
    mulu        #4,d6
    
    move.l      #32,d4
    sub.l       d6,d4
    move.l      #28,d3
    
ADDR_LOOP                           ; print the hex memory address
    move.l      d7,d5
    lsl.l       d4,d5
    lsr.l       d3,d5
    
    mulu        #2,d5
    lea         0(a6,d5),a1
    move.b      #14,d0
    trap        #15
    
    add.b       #4,d4
    cmpi.b      #32,d4
    bne         ADDR_LOOP           ; if not equal, keep looping
    
    rts

DRD
    lea         DATA_REGISTER,a1    ; load DATA_REGISTER into a1
    move.b      #14,d0              ; task 14 to display
    trap        #15                 ; display
    
    move.b      #3,d0               ; task 3 to print hex as decimal (the data register number)
    trap        #15                 ; display
    rts                             ; return

ARD
    lea         ADDRESS_REGISTER,a1 ; load ADDRESS_REGISTER into a1
    move.b      #14,d0              ; task 14 to display
    trap        #15                 ; display

    move.b      #3,d0               ; taks 3 to print hex as decimal (the address register number)
    trap        #15                 ; display
    
    cmpi.b      #%0010,d7           ; check for address register indirect
    beq         PRINT_CPARENS       ; branch to the label PRINT_CPARENS
    cmpi.b      #%0011,d7           ; check for address register indirect with post increment
    beq         PRINT_CPARENSPI     ; branch to the label PRINT_CPARENSPI
    cmpi.b      #%0100,d7           ; check for address register indirect with pre decrement
    beq         PRINT_CPARENS       ; branch to the label PRINT_CPARENS       
    rts                             ; return
    
ARI
    lea         OPARENS,a1          ; load OPARENS into a1
    move.b      #14,d0              ; task 14 to display
    trap        #15                 ; display
    bra         ARD                 ; branch to the label ARD to print the address register
    
ARIPI
    lea         OPARENS,a1          ; load OPARENS into a1
    move.b      #14,d0              ; task 14 to display
    trap        #15                 ; display
    bra         ARD                 ; branch to the label ARD to print the address register
  
ARIPD
    lea         MINUS,a1            ; load MINUS into a1
    move.b      #14,d0              ; task 14 to display
    trap        #15                 ; display
    
    lea         OPARENS,a1          ; load OPARENS into a1
    move.b      #14,d0              ; task 14 to display
    trap        #15                 ; display
    bra         ARD                 ; branch to tha label ARD to print the address register
    
IMMABS       
    cmpi.b      #%0100,d6           ; check if the source register is for immediate data          
    beq         IMMEDIATE_DATA      ; if equal, branch to the label IMMEDIATE_DATA
    cmpi.b      #%0000,d6           ; check if the source register is for absolute addressing word
    beq         ABSOLUTE            ; if equal, branch to the label ABSOLUTE
    cmpi        #%0001,d6           ; check if the source register is for absolute addressing long
    beq         ABSOLUTE            ; if equal, branch to the label ABSOLUTE
    cmpi        #%0111,d6           
    beq         ABSOLUTE
    
IMMEDIATE_DATA
    lea         POUND_SIGN,a1       ; load the POUND_SIGN into a1
    move.b      #14,d0              ; task 14 to display
    trap        #15                 ; display
    
    lea         DOLLAR_SIGN,a1
    move.b      #14,d0
    trap        #15
    
    clr         d7                  ; clear d7
       
SIZE
    ; shift the proper bits to the right end to check the size of the operand
    
    move        a5,d0
    cmpi.b      #$01,d0
    beq         MOVE_SIZE
    
    jsr         SHIFT_13
    move        d1,d6
    jsr         SHIFT_4_13
    
    cmpi.b      #%0000,d1
    beq         SIZE_BYTE
    cmpi.b      #%0011,d1
    beq         SIZE_BYTE
    cmpi.b      #%0001,d6
    beq         SIZE_LONG
    cmpi.b      #%0000,d6
    beq         SIZE_BYTE
    cmpi.b      #%0001,d1
    beq         SIZE_LONG
    cmpi.b      #%0100,d6
    beq         SIZE_LONG
    
MOVE_SIZE
    jsr         SHIFT_2_12
    
    cmpi.b      #%0001,d1
    beq         SIZE_BYTE
    cmpi.b      #%0011,d1
    beq         SIZE_LONG
    cmpi.b      #%0010,d1
    beq         SIZE_LONG
    
    bra         SIZE_LONG
 
ABSOLUTE
    lea         DOLLAR_SIGN,a1      ; load DOLLAR_SIGN into a1
    move.b      #14,d0              ; task 14 to display
    trap        #15                 ; display
   
    
    jmp         SIZE 
    
SIZE_BYTE
    move.l      $FFFFFC,a2
    move.w      (a2),d1             ; copy the current machine code into d2
    
    lea         HEXS,a6
    move        #4,d6
    mulu.w      #4,d6
    
    move.l      #32,d3
    sub.l       d6,d3
    move.l      #28,d4
    
LOOP3
    move.l      (a2),d5
    lsl.l       d3,d5
    lsr.l       d4,d5
    
    mulu        #2,d5
    lea         0(a6,d5),a1
    move.b      #14,d0
    trap        #15
    
    add.b       #4,d3
    cmp.b       #32,d3
    bne         LOOP3

    suba        #2,a2               ; subtract 2 to go back to the correct machine code
    move        d1,d3
    move        #2,d2
    rts                             ; return
    
SIZE_WORD
    move.l      $FFFFFC,a2
    adda        #2,a2               ; add 2 for word
    move.w      (a2),d1             ; copy the current machine code into d2

    lea         HEXS,a6
    move        #8,d6
    mulu.w      #4,d6
    
    move.l      #32,d2
    sub.l       d6,d2
    move.l      #28,d4
    
LOOP
    move.w      (a2),d5
    lsl.l       d2,d5
    lsr.l       d4,d5
    
    mulu        #2,d5
    lea         0(a6,d5),a1
    move.b      #14,d0
    trap        #15
    
    add.b       #4,d2
    cmp.b       #32,d2
    bne         LOOP
    
    suba        #2,a2               ; subtract 2 to go back to the correct machine code
    rts                             ; return
    
SIZE_LONG
    move.l      $FFFFFC,a2
    adda        #2,a2               ; add 4 for long
    move.l      (a2),d1             ; copy the current machine code into d2
    
    lea         HEXS,a6
    move        #8,d6
    mulu.w      #4,d6
    
    move.l      #32,d2
    sub.l       d6,d2
    move.l      #28,d4
    
LOOP2
    move.l      (a2),d5
    lsl.l       d2,d5
    lsr.l       d4,d5
    
    mulu        #2,d5
    lea         0(a6,d5),a1
    move.b      #14,d0
    trap        #15
    
    add.b       #4,d2
    cmp.b       #32,d2
    bne         LOOP2
    
    clr.l       d1                  ; clear d1
    clr.l       d2
    clr.l       d6
    move.b      d2,d1               ; copy d2 to d1
    
    suba        #2,a2               ; subtract 4 to go back to the correct machine code
    
    move        #4,d2
    rts                             ; return

PRINT_COMMA
    lea         COMMA,a1            ; load COMMA into a1
    move.b      #14,d0              ; task 14 to display
    trap        #15                 ; display
    rts                             ; return
    
PRINT_CPARENS
    lea         CPARENS,a1          ; load CPARENS into a1
    move.b      #14,d0              ; task 14 to display
    trap        #15                 ; display
    rts                             ; return
    
PRINT_CPARENSPI
    lea         CPARENS,a1          ; load CPARENS into a1
    move.b      #14,d0              ; task 14 to display
    trap        #15                 ; display
    
    lea         PLUS,a1             ; load PLUS into a1
    move.b      #14,d0              ; task 14 to display
    trap        #15                 ; display
    rts                             ; return

***************************************************************************************
*                                      Messages
***************************************************************************************
NEW_LINE            DC.B    CR,LF,0

POUND_SIGN          DC.B    '#',0
DOLLAR_SIGN         DC.B    '$',0
DATA_REGISTER       DC.B    'D',0
ADDRESS_REGISTER    DC.B    'A',0
COMMA               DC.B    ',',0
OPARENS             DC.B    '(',0
CPARENS             DC.B    ')',0
PLUS                DC.B    '+',0
MINUS               DC.B    '-',0
SLASH               DC.B    '/',0

***************************************************************************************
*                                      Constants
***************************************************************************************

THIRTEEN            DC.B     13
TEN                 DC.B     10
TWELVE              DC.B     12
FOUR                DC.B     4
SEVEN               DC.B     7
SIX                 DC.B     6
THREE               DC.B     3
NINE                DC.B     9
EIGHT               DC.B     8
FOURTEEN            DC.B     14


HEXS                DC.B    '0',0
                    DC.B    '1',0
                    DC.B    '2',0
                    DC.B    '3',0
                    DC.B    '4',0
                    DC.B    '5',0
                    DC.B    '6',0
                    DC.B    '7',0
                    DC.B    '8',0
                    DC.B    '9',0
                    DC.B    'A',0
                    DC.B    'B',0
                    DC.B    'C',0
                    DC.B    'D',0
                    DC.B    'E',0
                    DC.B    'F',0

***************************************************************************************
*                                      Storage
***************************************************************************************

MODE                DS.W     1
REGISTER            DS.W     1
MACHINE_CODE        DS.W     1
MOVEM_SIZE          DS.B     1

MONE                DS.B     1
MTWO                DS.B     1
MTHREE              DS.B     1


CR      EQU     $0D     ; carriage return
LF      EQU     $0A     ; line feed






*~Font name~Courier~
*~Font size~15~
*~Tab type~1~
*~Tab size~4~