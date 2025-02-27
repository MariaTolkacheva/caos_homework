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
    li t2, 0
outer_loop:
    bge t2, s0, outer_end
    lw t3, 0(t1)
    
    mv t4, sp
    li t5, 0
inner_loop:
    bge t5, t2, inner_end
    
    lw t6, 0(t4)
    
    beq t3, t6, skip_duplicate
    
    addi t4, t4, 4
    addi t5, t5, 1
    j inner_loop

inner_end:

    print_int(t3)

    newline

skip_duplicate:
    addi t1, t1, 4
    addi t2, t2, 1
    j outer_loop

outer_end:
    li a7, 10
    ecall