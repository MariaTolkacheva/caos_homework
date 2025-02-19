.data
newline: .asciz "\n"

.macro print_int(%reg)
    li a7, 1
    mv a0, %reg
    ecall
    li a7, 11
    li a0, '\n'
    ecall
.end_macro

.text
main:
    # Read x
    li a7, 5
    ecall
    addi s0, a0, 0   # Store x in s0

    # Read y
    li a7, 5
    ecall
    addi s1, a0, 0   # Store y in s1

    # Expression 1: (x >> 2) + ((y - 1) << 3)  (logical shift)
    srli t0, s0, 2    # Logical right shift x by 2
    addi t1, s1, -1   # y - 1
    slli t2, t1, 3    # Left shift (y - 1) by 3
    add  t3, t0, t2   # (x >> 2) + ((y - 1) << 3)
    print_int(t3)     # Print result

    # Expression 2: (x << y) - 10
    li t0, 10         # Load constant 10 into t0
    sll t1, s0, s1    # x << y (variable shift)
    sub  t0, t1, t0   # (x << y) - 10
    print_int(t0)     # Print result

    # Expression 3: (x >> y) + 10 (arithmetic shift)
    sra t0, s0, s1    # Arithmetic right shift x by y
    addi t0, t0, 10   # (x >> y) + 10
    print_int(t0)     # Print result

    # Expression 4: ((x << 2) - y + 5) >> 1 (arithmetic shift)
	slli t0, s0, 2    # x << 2
	sub  t0, t0, s1   # (x << 2) - y
	addi t0, t0, 5    # (x << 2) - y + 5
	srai  t0, t0, 1    # ((x << 2) - y + 5) >> 1 (arithmetic shift)
	print_int(t0)     # Print result

    # Expression 5: x * 6 - y * 3 (using shifts, adds, and subs)
    slli t0, s0, 2    # x * 4
    slli t1, s0, 1    # x * 2
    add  t0, t0, t1   # x * 4 + x * 2
    slli t1, s1, 1    # y * 2
    add  t1, t1, s1   # y * 3
    sub  t0, t0, t1   # x * 6 - y * 3
    print_int(t0)     # Print result

    # Exit program
    li a7, 10
    ecall
