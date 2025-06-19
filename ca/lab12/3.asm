.eqv   BASE    0x10010000
.text
.globl main

.macro newline
    li      a0, '\n'
    li      a7, 11
    ecall
.end_macro

.macro CALC_ADDR
    slli  t3, a0, 7
    add   t3, t3, a1
    slli  t3, t3, 2
    add   t3, t3, s6
.end_macro

.macro DRAW_PIXEL
    CALC_ADDR
    sw    s1, 0(t3)
.end_macro

.macro NEXT_ROW
    addi  a0, a0, 1
.end_macro

.macro NEXT_COL
    addi  a1, a1, 1
.end_macro

main:
    li   a7, 5
    ecall
    mv   s0, a0
    li   a7, 5
    ecall
    mv   s1, a0
    li   s6, BASE
    li   s2, 32
    li   s3, 32
    li   s4, 95
    li   s5, 95

    li   t0, 0
top_border:
    bge  t0, s0, m_bott
    add  t1, s3, t0
    mv   a0, t1
    mv   a1, s2
l_top:
    bgt  a1, s4, inc_top_i
    DRAW_PIXEL
    NEXT_COL
    j    l_top
inc_top_i:
    addi t0, t0, 1
    j    top_border

m_bott:
    li   t0, 0
bottom_border:
    bge  t0, s0, m_left
    sub  t1, s5, t0
    mv   a0, t1
    mv   a1, s2
bottom_border_x:
    bgt  a1, s4, i_bot
    DRAW_PIXEL
    NEXT_COL
    j    bottom_border_x
i_bot:
    addi t0, t0, 1
    j    bottom_border

m_left:
    li   t0, 0
left_border:
    bge  t0, s0, m_right
    add  t2, s2, t0
    mv   a1, t2
    mv   a0, s3
left_loop:
    bgt  a0, s5, l_plus
    DRAW_PIXEL
    NEXT_ROW
    j    left_loop
l_plus:
    addi t0, t0, 1
    j    left_border

m_right:
    li   t0, 0
right_border:
    bge  t0, s0, end
    sub  t2, s4, t0
    mv   a1, t2
    mv   a0, s3
right_loop:
    bgt  a0, s5, r_plus
    DRAW_PIXEL
    NEXT_ROW
    j    right_loop
r_plus:
    addi t0, t0, 1
    j    right_border

end:
    li   a7, 10
    ecall
