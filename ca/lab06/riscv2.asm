.data
prompt_n:   .asciz "Enter N: "          # Prompt for array size
prompt_t:   .asciz "Enter T: "          # Prompt for comparison type
prompt_arr: .asciz "Enter array: "      # Prompt for array elements
newline:    .asciz "\n"                 # Newline character

.text
.globl main

# Comparison function 1: a0 < a1
# Returns 1 in a0 if a0 < a1, otherwise 0
compare_less:
    blt a0, a1, compare_less_true
    li a0, 0
    ret
compare_less_true:
    li a0, 1
    ret

# Comparison function 2: a0 % 10 > a1 % 10
# Returns 1 in a0 if a0 % 10 > a1 % 10, otherwise 0
compare_mod:
    li t0, 10
    rem a0, a0, t0
    rem a1, a1, t0
    bgt a0, a1, compare_mod_true
    li a0, 0
    ret
compare_mod_true:
    li a0, 1
    ret

# Sorting subroutine
# Arguments:
#   a0: array size (in words)
#   a1: array address
#   a2: comparison function address
# Returns:
#   a0: array size
#   a1: array address
sort:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    sw s2, 0(sp)

    mv s0, a0            # s0 = array size
    mv s1, a1            # s1 = array address
    mv s2, a2            # s2 = comparison function address

    li t0, 0             # Outer loop counter (i)
outer_loop:
    bge t0, s0, outer_end # If i >= array size, exit loop

    li t1, 0             # Inner loop counter (j)
inner_loop:
    addi t2, s0, -1      # t2 = array size - 1
    bge t1, t2, inner_end # If j >= array size - 1, exit loop

    # Load array[j] and array[j + 1]
    slli t3, t1, 2       # t3 = j * 4 (word offset)
    add t3, s1, t3       # t3 = address of array[j]
    lw a0, 0(t3)         # a0 = array[j]
    lw a1, 4(t3)         # a1 = array[j + 1]

    # Call comparison function
    jalr ra, s2, 0       # Call comparison function
    beqz a0, no_swap     # If comparison returns 0, no swap

    # Swap array[j] and array[j + 1]
    lw t4, 0(t3)         # t4 = array[j]
    lw t5, 4(t3)         # t5 = array[j + 1]
    sw t5, 0(t3)         # array[j] = t5
    sw t4, 4(t3)         # array[j + 1] = t4

no_swap:
    addi t1, t1, 1       # j++
    j inner_loop

inner_end:
    addi t0, t0, 1       # i++
    j outer_loop

outer_end:
    mv a0, s0            # Return array size
    mv a1, s1            # Return array address

    lw ra, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)
    lw s2, 0(sp)
    addi sp, sp, 16
    ret

main:
    # Allocate space for N, T, and the array on the stack
    addi sp, sp, -128
    sw ra, 124(sp)
    sw s0, 120(sp)
    sw s1, 116(sp)
    addi s0, sp, 128

    # Prompt for N
    la a0, prompt_n
    li a7, 4
    ecall

    # Read N
    li a7, 5
    ecall
    sw a0, -124(s0)      # Store N at -124(s0)

    # Prompt for T
    la a0, prompt_t
    li a7, 4
    ecall

    # Read T
    li a7, 5
    ecall
    sw a0, -128(s0)      # Store T at -128(s0)

    # Allocate space for the array
    lw a5, -124(s0)      # Load N
    slli a5, a5, 2       # Multiply N by 4 (size of int)
    addi a5, a5, 15      # Add 15 for alignment
    srli a5, a5, 4       # Divide by 16
    slli a5, a5, 4       # Multiply by 16
    sub sp, sp, a5       # Allocate space for the array
    mv s1, sp            # Save array pointer in s1

    # Read array elements
    sw zero, -120(s0)    # Initialize loop counter (i = 0)
read_loop:
    lw a5, -120(s0)      # Load i
    lw a4, -124(s0)      # Load N
    bge a5, a4, read_done # If i >= N, exit loop

    # Read array[i]
    li a7, 5
    ecall
    slli a5, a5, 2       # Multiply i by 4 (size of int)
    add a5, s1, a5       # Calculate address of array[i]
    sw a0, 0(a5)         # Store input in array[i]

    # Increment i
    lw a5, -120(s0)
    addi a5, a5, 1
    sw a5, -120(s0)
    j read_loop

read_done:
    # Choose comparison function based on T
    lw a5, -128(s0)      # Load T
    beqz a5, use_compare_less # If T == 0, use compare_less
    la a2, compare_mod   # Else, use compare_mod
    j sort_array

use_compare_less:
    la a2, compare_less  # Use compare_less

sort_array:
    # Call sorting subroutine
    lw a0, -124(s0)      # Load N (array size)
    mv a1, s1            # Load array address
    jal ra, sort         # Call sort subroutine

    # Print sorted array
    sw zero, -116(s0)    # Initialize loop counter (i = 0)
print_loop:
    lw a5, -116(s0)      # Load i
    lw a4, -124(s0)      # Load N
    bge a5, a4, end_program # If i >= N, exit loop

    # Print array[i]
    slli a5, a5, 2       # Multiply i by 4 (size of int)
    add a5, s1, a5       # Calculate address of array[i]
    lw a1, 0(a5)         # Load array[i]
    li a7, 1             # System call for print integer
    ecall

    # Print newline
    la a0, newline
    li a7, 4
    ecall

    # Increment i
    lw a5, -116(s0)
    addi a5, a5, 1
    sw a5, -116(s0)
    j print_loop

end_program:
    # Restore registers and return
    lw ra, 124(sp)
    lw s0, 120(sp)
    lw s1, 116(sp)
    addi sp, sp, 128
    li a7, 10
    ecall