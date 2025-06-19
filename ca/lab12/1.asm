.macro print_int (%x)
        li      a7, 1
        mv      a0, %x
        ecall
    .end_macro

    .macro print_hex(%x)
        mv      a0, %x
        li      a7, 34
        ecall
    .end_macro

    .macro CASE_SEG(%val, %seg)
        li      a1, %val
        bne     a0, a1, 1f
        li      a0, %seg
        jalr    zero, 0(ra)
    1:
    .end_macro

    .macro CONV_CASE(%val, %seg)
        li      a1, %val
        bne     a0, a1, 1f
        li      a0, %seg
        jalr    zero, 0(ra)
    1:
    .end_macro

.text
main:
    lui     s0, 0xffff0       # MMIO base address
    li      s1, 0             # counter
    li      s2, 0             # previous key value
    li      s3, 20            # counter limit
    li      a3, 0             # first/second digit toggle

loop:
    li      t0, 1
    sb      t0, 0x12(s0)
    lb      t1, 0x14(s0)
    bnez    t1, keyb

    li      t0, 2
    sb      t0, 0x12(s0)
    lb      t1, 0x14(s0)
    bnez    t1, keyb

    li      t0, 4
    sb      t0, 0x12(s0)
    lb      t1, 0x14(s0)
    bnez    t1, keyb

    li      t0, 8
    sb      t0, 0x12(s0)
    lb      t1, 0x14(s0)
    bnez    t1, keyb

    li      s2, 0
    j       loop

keyb:
    beq     t1, s2, loop
    mv      s2, t1
    andi    t2, t1, 15
    srli    t3, t1, 4

    mv      a0, t2
    jal     conv
    mv      t2, a0

    mv      a0, t3
    jal     conv
    mv      t3, a0

    addi    t2, t2, -1
    li      t4, 4
    mul     t2, t2, t4
    add     t2, t2, t3
    addi    t2, t2, -1

    li      t4, 10
    bge     t2, t4, other

condition:
    mv      a0, t2
    jal     to_seg
    mv      t3, a0

    beqz    a3, write_first
    sb      t3, 0x10(s0)
    li      a3, 0
    j       end_write

write_first:
    addi    t3, t3, 128
    sb      t3, 0x11(s0)
    li      a3, 1

end_write:
    addi    s1, s1, 1
    ble     s1, s3, loop

end:
    li      a7, 10
    ecall

other:
    li      t3, 6             
    sb      t3, 0x11(s0)
    li      a3, -1
    rem     t2, t2, t4
    j       condition

to_seg:
    li      a1, 0
    bne     a0, a1, case0
    li      a0, 63            
    jalr    zero, 0(ra)

case0:
    li      a1, 1
    bne     a0, a1, case1
    li      a0, 6             
    jalr    zero, 0(ra)

case1:
    li      a1, 2
    bne     a0, a1, case2
    li      a0, 91
    jalr    zero, 0(ra)

case2:
    li      a1, 3
    bne     a0, a1, case3
    li      a0, 79            
    jalr    zero, 0(ra)

case3:
    li      a1, 4
    bne     a0, a1, case4
    li      a0, 102           
    jalr    zero, 0(ra)

case4:
    li      a1, 5
    bne     a0, a1, case5
    li      a0, 109         
    jalr    zero, 0(ra)

case5:
    li      a1, 6
    bne     a0, a1, case6
    li      a0, 125          
    jalr    zero, 0(ra)


case6:
    li      a1, 7
    bne     a0, a1, case7
    li      a0, 7             
    jalr    zero, 0(ra)

case7:
    li      a1, 8
    bne     a0, a1, case8
    li      a0, 127           
    jalr    zero, 0(ra)

case8:
    li      a0, 111           
    jalr    zero, 0(ra)

conv:
    li      a1, 1
    bne     a0, a1, cond1
    jalr    zero, 0(ra)

cond1:
    li      a1, 2
    bne     a0, a1, cond2
    li      a0, 2
    jalr    zero, 0(ra)

cond2:
    li      a1, 4
    bne     a0, a1, cond4
    li      a0, 3
    jalr    zero, 0(ra)

cond4:
    li      a0, 4
    jalr    zero, 0(ra)
