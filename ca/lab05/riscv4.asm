	.macro print_int (%x)
   li a7, 1
   mv a0, %x
   ecall
   .end_macro

   .macro newline
   li a7, 11
   li a0, '\n'
   ecall
   .end_macro
   
   .macro read_int (%reg)
    li a7, 5
    ecall
    mv %reg, a0
	.end_macro

.text
    .globl main

main:

    read_int(s0)
    
    slli t0, s0, 2
    sub sp, sp, t0
    
    mv t1, sp
    li t2, 0
input_loop:
    bge t2, s0, input_end

    li a7, 5
    ecall
    sw a0, 0(t1)
    
    addi t1, t1, 4
    addi t2, t2, 1
    j input_loop

input_end:

    mv t1, sp
    add t1, t1, t0
    li t2, 0
loop:
    blez s0, reverse_end

    addi t1, t1, -4
    addi s0, s0, -1
    
    lw t3, 0(t1)
    
    andi t4, t3, 1
    bnez t4, loop
    
    mv a0, t3
    li a7, 1
    ecall
    
    newline

    j loop

reverse_end:

    newline

    li a7, 10
    ecall