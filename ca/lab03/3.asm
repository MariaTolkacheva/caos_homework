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
    mv s0, a0   # Store x in s0

    # Read y
    li a7, 5
    ecall
    mv s1, a0   # Store y in s1

    # Expression 1: x & (-1 << 2)
    li t0, -1        # Load -1 into t0 (all bits set)
    slli t0, t0, 2   # -1 << 2 (shift left, keeping sign extension)
    and t1, s0, t0   # x & (-1 << 2)
    print_int(t1)    # Print result

    # Expression 2: x | (-1 >> 30) (logical shift)
    li t0, -1        # Load -1 into t0
    srli t0, t0, 30  # Logical shift right by 30
    or t1, s0, t0    # x | (-1 >> 30)
    print_int(t1)    # Print result

    # Expression 3: Set the y-th bit of x to 1
    li t0, 1         # Load 1 into t0
    sll t0, t0, s1   # Shift left by y to create mask
    or t1, s0, t0    # x | (1 << y)
    print_int(t1)    # Print result

    # Expression 4: Reset the y-th bit of x to 0
    li t0, 1         # Load 1 into t0
    sll t0, t0, s1   # Shift left by y to create mask
    not t0, t0       # Invert mask to clear the bit
    and t1, s0, t0   # x & ~(1 << y)
    print_int(t1)    # Print result

    # Expression 5: (x == (y + 3)) ? 0 : 1
    addi t0, s1, 3   # Compute y + 3
    slt t1, s0, t0   # t1 = (x < (y + 3))
    slt t2, t0, s0   # t2 = ((y + 3) < x)
    or t3, t1, t2    # (x < (y + 3)) | ((y + 3) < x)
    print_int(t3)    # Print result

    # Expression 6: x > -5 & y < 5
    li t0, -5
    slt t1, t0, s0   # t1 = (-5 < x) -> x > -5
    li t0, 5
    slt t2, s1, t0   # t2 = (y < 5)
    and t3, t1, t2   # (x > -5) & (y < 5)
    print_int(t3)    # Print result

    # Exit program
    li a7, 10
    ecall
