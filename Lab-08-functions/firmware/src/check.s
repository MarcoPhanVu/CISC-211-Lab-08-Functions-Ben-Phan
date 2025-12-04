asmUnpack:   
    /*** STUDENTS: Place your asmUnpack code BELOW this line!!! **************/
        PUSH {R4 - R11, LR}   /* not touching R4-R11*/
            ASR     R3, R0, 16
            STR     R3, [R1]    /*R1, R2 stores address, not the actual values*/

            LSL     R3, R0, 16
            ASR     R3, R3, 16
            STR     R3, [R2]
        POP {R4 - R11, LR}
        BX LR /* return to the base of stack frame(mainFunc instead of asmUnpack)
   
asmAbs:  
    /*** STUDENTS: Place your asmAbs code BELOW this line!!! **************/
    PUSH {R4 - R11, LR}
        CMP     R0, 0
        BGE     pos_val

        RSB     R0, R0, 0   /* no need flags */
        MOV     R3, 1
        STR     R3, [R2]
        B       store_abs

        pos_val:
            MOV     R3, 0
            STR     R3, [R2]
        store_abs:
            STR     R0, [R1]
    POP {R4 - R11, LR}
    BX LR 

asmMult:
    /*** STUDENTS: Place your asmMult code BELOW this line!!! **************/
    PUSH {R4 - R11, LR}
        /* if either multiplicand/er == 0 -> product == 0*/
        CMP     R0, 0           /*R0, R1 already hold values*/
        BEQ     Prod_Zebra
        CMP     R1, 0
        BEQ     Prod_Zebra

        B       Prod_Normal

        Prod_Zebra: /*set final prod, signs = 0*/
            MOV     R3, 0
            LDR     R4, =final_Product
            STR     R3, [R4]
            /* SHOULD NOT FIDDLE WITH SIGNS
            LDR     R5, =b_Sign
            LDR     R6, =a_Sign
            STR     R3, [R5]
            STR     R3, [R6]
            */
            B       Done

        Prod_Normal:
            MOV     R3, 0

        Mult_Loop:
            CMP     R1, 0
            BEQ     Done            /* Multiplier == 0*/

            TST     R1, 1           /*if rightmost bit == 1*/
            ADDNE   R3, R3, R0      /*Add multiplier to cand*/

            LSL     R0, R0, 1       /* a << 1, b >> 1*/
            LSR     R1, R1, 1
            B      Mult_Loop

        Done:
            MOV     R0, R3
            LDR     R4, =init_Product
            STR     R0, [R4]
    POP {R4 - R11, LR}
    BX LR

asmFixSign:   
    PUSH {R4 - R11, LR} /*every values loaded*/
        EOR     R3, R1, R2      /*Neg if diff*/
        CMP     R3, 1
        BNE     Send_Prod

        RSB     R0, R0, 0       /*not using SUBS since 1st operand must be a register*/

        Send_Prod:
    POP {R4 - R11, LR}
    BX LR

asmMain:   
    
    /*** STUDENTS: Place your asmMain code BELOW this line!!! **************/
    PUSH {R4-R11, LR}

    LDR     R1, =a_Multiplicand     /*ADDRESS*/
    LDR     R2, =b_Multiplier
    BL      asmUnpack

    LDR     R0, =a_Multiplicand     /*load a's address*/
    LDR     R0, [R0]                /*load a*/
    LDR     R1, =a_Abs              /*adress*/
    LDR     R2, =a_Sign
    BL      asmAbs

    LDR     R0, =b_Multiplier
    LDR     R0, [R0]
    LDR     R1, =b_Abs
    LDR     R2, =b_Sign
    BL      asmAbs

    LDR     R0, =a_Abs
    LDR     R0, [R0]
    LDR     R1, =b_Abs
    LDR     R1, [R1]
    BL      asmMult

    LDR     R0, =init_Product
    LDR     R0, [R0]
    LDR     R1, =a_Sign
    LDR     R1, [R1]
    LDR     R2, =b_Sign
    LDR     R2, [R2]
    BL      asmFixSign

    LDR     R4, =final_Product
    STR     R0, [R4]

    POP {R4-R11, LR}
    BX LR

.end









Index to access array elements
Base address points to the start of array
Assembler uses "," for elements when using .word directive
EQ use Z Flag
The mantissa stored as an unsigned fraction representing the bits after the binary point,
with an implicit leading 1 for normal numbers (and implicit 0 for subnormals).
MOV immediate can only encode certain constants —
those that fit into an 8-bit value rotated right by an even number of bits (0–30).




LDR r5, =0x20000166
LDR r6, =0xA1B1
STRH r6, [r5]
LDRSB r4, [r5], 1