.data
place:
    .byte 0x3F, 0x06, 0x5B, 0x4F
    .byte 0x66, 0x6D, 0x7D, 0x07
    .byte 0x7F, 0x6F, 0x77, 0x7C
    .byte 0x39, 0x5E, 0x79, 0x71

blank: 
    .byte 0x00

success: 
    .string "FOUND\n"

stop: 
    .string "STOPPED\n"


.macro scan_key(%row)
    li   t0, %row
    sb   t0, 0x12(s1)
    lb   t1, 0x14(s1)
    bnez t1, process_key
.end_macro

.macro exit
    li   a7, 10
    ecall
.end_macro


.macro print_hex(%reg)
    mv   a0, %reg
    li   a7, 34
    ecall
.end_macro

.macro read_int
    li   a7, 5
    ecall
.end_macro

.text
.globl main

main:
    read_int
    mv   s0, a0
    lui  s1, 0xffff0
    mv   s2, zero
    mv   s3, zero
    mv   s4, zero

    la   t0, blank
    lb   t1, 0(t0)
    sb   t1, 0x10(s1)
    sb   t1, 0x11(s1)

entry_loop:
    print_hex(s2)
    li      a0, '\n'
    li      a7, 11
    ecall

    mv   s2, zero
    mv   s4, zero

wait_key:
    scan_key(1)
    scan_key(2)
    scan_key(4)
    scan_key(8)

    mv   s3, zero
    j    wait_key

process_key:
    beq  t1, s3, wait_key
    mv   s3, t1

    andi t2, t1, 0x0F
    srli t3, t1, 4

    li   t4, 0
find_row:
    andi t5, t2, 1
    bnez t5, row_ready
    srli t2, t2, 1
    addi t4, t4, 1
    j    find_row

row_ready:
    li   t6, 0
find_col:
    andi t5, t3, 1
    bnez t5, col_ready
    srli t3, t3, 1
    addi t6, t6, 1
    j    find_col

col_ready:
    slli t4, t4, 2
    add  a0, t4, t6

    slli s2, s2, 4
    add  s2, s2, a0

    la   t4, place
    add  t5, t4, a0
    lb   t5, 0(t5)
    sb   t5, 0x10(s1)

    addi s4, s4, 1
    li   t0, 8
    blt  s4, t0, wait_key

    beqz s2, show_stopped
    beq  s2, s0, show_found
    j    entry_loop

show_stopped:
    la   a0, stop
    li   a7, 4
    ecall 
    exit

show_found:
    la   a0, success
    li   a7, 4
    ecall 
    exit


