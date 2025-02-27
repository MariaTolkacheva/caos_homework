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


main:
    read_int(t0)
    read_int(t1)
    read_int(t2)
    read_int(t3)
    add t0, t0, t2
    add t1, t1, t3
    print_int(t0)
    newline
    print_int(t1)