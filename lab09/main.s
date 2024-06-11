.globl _start

_start:
    jal main
    li a0, 0
    li a7, 93 # exit
    ecall

.text

main:

    addi sp,sp,-4
    sw ra, 0(sp)

    call read
    lw s4, input_address

    jal read_digit # Falta completar

    la s0, head_node

    li t1, -1
    jal recursion

    lw ra, 0(sp)
    addi sp, sp, 4


recursion:
    
    addi sp,sp,-4
    sw ra, 0(sp)

    # Lendo 1 número
    lw a1, (s0)
    addi s0, s0, 4

    # Lendo 2 número
    lw a2, (s0)
    addi s0, s0, 4

    # Lendo 3 número
    lw a3, (s0)
    addi s0, s0, 4

    # Computando a soma dos 3
    li s1, 0
    add s1, s1, a1
    add s1, s1, a2
    add s1, s1, a3

    # Atualizando o contador
    addi t1, t1, 1

    # Vendo se chegou na soma correta
    beq a0, s1, fim_normal
    
    # Atualizando o endereço para ser do novo nó
    la s0, (s0)

    # Vendo se o endereço final não é zero
    beq s0, 0, fim_nenhum

    j recursion

fim_nenhum:
    li a0, -1
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

fim_normal:
    mv a0, t1
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, result       # buffer
    li a2, 20           # size - Writes 20 bytes.
    li a7, 64           # syscall write (64)
    ecall
    ret

read: # Precisa colocar o tamanho antes
    li a0, 0
    la a1, input_address  # buffer
    li a7, 63
    ecall
    ret


.bss
input_address: .skip 0x20  # buffer

result: .skip 0x20