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

main:
    read_int(t0)

    li t1, 0         # sum = 0
    li t2, 10        # constant 10 for modulo/division operations

    bgez t0, compute # if number is non-negative, proceed
    neg t0, t0       # make it positive

compute:
    rem t3, t0, t2   # extract last digit (num % 10)
    add t1, t1, t3   # add to sum
    div t0, t0, t2   # num = num / 10
    bnez t0, compute # repeat until num == 0

    print_int(t1)

    newline

    li a7, 10
    ecall
