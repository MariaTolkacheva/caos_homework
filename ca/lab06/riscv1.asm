.data
newline:    .asciz "\n"
plus_minus: .asciz "+-"
pipe_space: .asciz "| "
plus:       .asciz "+"
pipe:       .asciz "|"

.text
.globl main

main:
    # Allocate space for n and m on the stack
    addi sp, sp, -12   # Allocate 12 bytes for ra, s0, and s1
    sw ra, 8(sp)       # Save return address
    sw s0, 4(sp)       # Save s0 (will store n)
    sw s1, 0(sp)       # Save s1 (will store m)

    li a7, 5           # System call for read integer
    ecall
    mv s0, a0          # Store n in s0

    li a7, 5           # System call for read integer
    ecall
    mv s1, a0          # Store m in s1

    # Outer loop (i = 0 to m)
    li t0, 0           # i = 0
outer_loop:
    bge t0, s1, end_outer_loop  # if i >= m, exit outer loop

    # Inner loop 1 (j = 0 to n)
    li t1, 0           # j = 0
inner_loop1:
    bge t1, s0, end_inner_loop1  # if j >= n, exit inner loop 1

    # Print "+-"
    la a0, plus_minus  # Load address of "+-"
    li a7, 4           # System call for print string
    ecall

    addi t1, t1, 1     # j++
    j inner_loop1
end_inner_loop1:

    # Print "+" and newline
    la a0, plus        # Load address of "+"
    li a7, 4           # System call for print string
    ecall
    la a0, newline     # Load address of newline
    li a7, 4           # System call for print string
    ecall

    # Inner loop 2 (j = 0 to n)
    li t1, 0           # j = 0
inner_loop2:
    bge t1, s0, end_inner_loop2  # if j >= n, exit inner loop 2

    # Print "| "
    la a0, pipe_space  # Load address of "| "
    li a7, 4           # System call for print string
    ecall

    addi t1, t1, 1     # j++
    j inner_loop2
end_inner_loop2:

    # Print "|" and newline
    la a0, pipe        # Load address of "|"
    li a7, 4           # System call for print string
    ecall
    la a0, newline     # Load address of newline
    li a7, 4           # System call for print string
    ecall

    addi t0, t0, 1     # i++
    j outer_loop
end_outer_loop:

    # Print the final line of "+-"
    li t1, 0           # j = 0
final_loop:
    bge t1, s0, end_final_loop  # if j >= n, exit final loop

    # Print "+-"
    la a0, plus_minus  # Load address of "+-"
    li a7, 4           # System call for print string
    ecall

    addi t1, t1, 1     # j++
    j final_loop
end_final_loop:

    # Print the final "+" and newline
    la a0, plus        # Load address of "+"
    li a7, 4           # System call for print string
    ecall

    # Restore registers and return
    lw s1, 0(sp)       # Restore s1
    lw s0, 4(sp)       # Restore s0
    lw ra, 8(sp)       # Restore return address
    addi sp, sp, 12    # Deallocate stack space
    li a7, 10               # System call for exit
    ecall