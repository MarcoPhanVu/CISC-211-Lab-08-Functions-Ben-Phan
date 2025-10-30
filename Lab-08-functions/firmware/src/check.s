asmUnpack:   
    
        PUSH {R4-R11, LR}   
            ASR     R3, R0, 16
            STR     R3, [R1]    

            LSL     R3, R0, 16
            ASR     R3, R3, 16
            STR     R3, [R2]
        POP {R4-R11, PC}
        BX LR 

asmAbs:  
    PUSH {R4-R11, LR}
        CMP     R0, 0
        BGE     pos_val

        RSB     R0, R0, 0   
        MOV     R3, 1
        STR     R3, [R2]
        B       store_abs

        pos_val:
            MOV     R3, 0
            STR     R3, [R2]
        store_abs:
            STR     R0, [R1]
    POP {R4-R11, PC}
    BX LR
    
asmMult:
    PUSH {R4, LR}
        
        CMP     R0, 0           
        BEQ     Prod_Zebra
        CMP     R1, 0
        BEQ     Prod_Zebra

        B       Prod_Normal

        Prod_Zebra: 
            MOV     R3, 0
            LDR     R4, =final_Product
            STR     R3, [R4]

            B       Done

        Prod_Normal:
            MOV     R3, 0
            @ LDR R3, =0x03FF0000

        Mult_Loop:
            CMP     R1, 0
            BEQ     Done            

            TST     R1, 1           
            ADDNE   R3, R3, R0      

            LSL     R0, R0, 1       
            LSR     R1, R1, 1
            B      Mult_Loop

        Done:
            MOV     R0, R3
            LDR     R4, =init_Product
            STR     R0, [R4]
    POP {R4, PC}
    BX Lr


asmFixSign:   
    PUSH {R4-R11, LR} 
        EOR     R3, R1, R2
        CMP     R3, 1
        BNE     Send_Prod

        RSB     R0, R0, 0       

        Send_Prod:
    POP {R4-R11, PC}
    BX LR

asmMain:
    PUSH {R4-R11, LR}
    LDR     R1, =a_Multiplicand     
    LDR     R2, =b_Multiplier
    BL      asmUnpack

    LDR     R0, =a_Multiplicand
    LDR     R0, [R0]                
    LDR     R1, =a_Abs              
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

    POP {R4-R11, PC}
    
.end   









Index to access array elements
Base address points to the start of array
Assembler uses "," for elements when using .word directive
EQ use Z Flag
The mantissa stored as an unsigned fraction representing the bits after the binary point,
with an implicit leading 1 for normal numbers (and implicit 0 for subnormals).
MOV immediate can only encode certain constants —
those that fit into an 8-bit value rotated right by an even number of bits (0–30).