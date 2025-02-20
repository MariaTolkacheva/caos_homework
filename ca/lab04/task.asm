.text
main:
    lui     s0, 0x10010       # 0x10010437
    xori x9, x0, 12           # 0x00c04493
    sw      s1, 0(s0)         # 0x00942023
    lui     t0, 0x30000       # 0x300002b7
    li      t1, 3             # 0x00300313
    srli x5, x5, 16           # 0x0102d293
    lw      s1, 0(s0)         # 0x00042483
    sll     x6, x6, x9        # 0x00931333
    beq     x5, x6, skip         # 0x00628463
    j       exit              # 0x0100006f

skip:
    auipc   t2, 0             # 0x00000397
    addi    t2, t2, -4        # 0xffc38393
    jalr    zero, 0(t2)       # 0x00038067

exit:
    ori    x17, zero, 10      # 0x00a06893
    ecall                     # 0x00000073
