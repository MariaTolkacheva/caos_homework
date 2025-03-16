.globl _start
_start:
    call main       
    li a7, 93       
    li a0, 0        
    ecall           
.macro print_int (%x)
    mv a0, %x      
    li a7, 1       
    ecall          
.end_macro

.macro print_double (%f)
    fmv.d fa0, %f  
    li a7, 3       
    ecall          
.end_macro

.macro newline
    li a7, 11      # Системный вызов для вывода символа
    li a0, '\n'    # Загружаем символ новой строки
    ecall          # Выполняем системный вызов
.end_macro

.macro read_int (%reg)
    li a7, 5       # Системный вызов для ввода целого числа
    ecall          # Выполняем системный вызов
    mv %reg, a0    # Сохраняем результат в регистр
.end_macro

.macro print_char (%char)
    li a7, 11      # Системный вызов для вывода символа
    li a0, %char   # Загружаем символ в a0
    ecall          # Выполняем системный вызов
.end_macro

pow10:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        sw      a0,-36(s0)
        li      a5,1
        sw      a5,-20(s0)
        sw      zero,-24(s0)
        j       .L2
.L3:
        lw      a4,-20(s0)
        mv      a5,a4
        slli    a5,a5,2
        add     a5,a5,a4
        slli    a5,a5,1
        sw      a5,-20(s0)
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L2:
        lw      a4,-24(s0)
        lw      a5,-36(s0)
        blt     a4,a5,.L3
        lw      a5,-20(s0)
        mv      a0,a5
        lw      ra,44(sp)
        lw      s0,40(sp)
        addi    sp,sp,48
        jr      ra
fraction_truncate:
        addi    sp,sp,-64
        sw      ra,60(sp)
        sw      s0,56(sp)
        addi    s0,sp,64
        sw      a0,-52(s0)
        sw      a1,-56(s0)
        sw      a2,-60(s0)
        lw      a4,-52(s0)
        lw      a5,-56(s0)
        div     a5,a4,a5
        sw      a5,-24(s0)
        lw      a4,-52(s0)
        lw      a5,-56(s0)
        rem     a5,a4,a5
        sw      a5,-28(s0)
        lw      a1,-24(s0)
        print_int(a1)
        print_char('.')
        lw      a0,-60(s0)
        call    pow10
        sw      a0,-32(s0)
        lw      a4,-28(s0)
        lw      a5,-32(s0)
        mul     a4,a4,a5
        lw      a5,-56(s0)
        div     a5,a4,a5
        sw      a5,-36(s0)
        lw      a5,-32(s0)
        li      a4,1717985280
        addi    a4,a4,1639
        mulh    a4,a5,a4
        srai    a4,a4,2
        srai    a5,a5,31
        sub     a5,a4,a5
        sw      a5,-20(s0)
        j       .L6
.L8:
        lw      a4,-36(s0)
        lw      a5,-20(s0)
        bge     a4,a5,.L7
		print_char('0')        
.L7:
        lw      a5,-20(s0)
        li      a4,1717985280
        addi    a4,a4,1639
        mulh    a4,a5,a4
        srai    a4,a4,2
        srai    a5,a5,31
        sub     a5,a4,a5
        sw      a5,-20(s0)
.L6:
        lw      a5,-20(s0)
        bgt     a5,zero,.L8
        lw      a5,-36(s0)
        print_int(a5)
        newline
        nop
        lw      ra,60(sp)
        lw      s0,56(sp)
        addi    sp,sp,64
        jr      ra
main:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        read_int(a5)
        sw      a5,-20(s0)
        read_int(a5)
        sw      a5,-24(s0)
        read_int(a5)
        sw      a5,-28(s0)
        lw      a2,-28(s0)
        lw      a1,-24(s0)
        lw      a0,-20(s0)
        call    fraction_truncate
        li      a5,0
        mv      a0,a5
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra