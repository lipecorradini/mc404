.globl _start

_start:
    jal main
    li a0, 0
    li a7, 93 # exit
    ecall
                      # Número negativo

.text

main:

    addi sp,sp,-4
    sw ra, 0(sp)

    jal read
    mv t0, a1

    jal read_digit

    la s0, head_node

    li t1, -1
    jal func

    la s1, result
    jal save_answer

    jal write

    lw ra, 0(sp)
    addi sp, sp, 4


func:
    # Número que queremos está em a0

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
    lw s0, (s0)

    # Vendo se o endereço final não é zero
    li t2, 0
    beq s0, t2, fim_nenhum

    j func

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


read_digit:
    li t1, 0              # t1 é o acumulador do número
    li t2, 1            # t2 será usado para identificar o sinal do número
    li t3, 10             # t3 é a base decimal (10)

    # Checar se o primeiro caractere é o sinal '-'
    lb t4, 0(t0)
    lw s5, (t0)
    li t5, 45             # ASCII de '-'
    beq t4, t5, negativo

    # Caso contrário, começar a conversão a partir do primeiro caractere
    j conversao

    negativo:
        li t2, -1
        addi t0, t0, 1        # Pular o caractere '-'
        j conversao

    conversao:
        lbu t4, 0(t0)
        li t5, 10       # Ler o próximo caractere

    loop:
        beq t4, t5, fim_read
        addi t4, t4, -48        # Converter caractere para número
        mul t1, t1, t3        # Multiplicar o acumulador por 10
        add t1, t1, t4        # Adicionar o dígito ao acumulador
        addi t0, t0, 1        # Mover para o próximo caractere
        lbu t4, 0(t0)          # Ler o próximo caractere
        j loop            # Caso contrário, tornar o número negativo

    fim_read:
        mul t1, t1, t2
        mv a0, t1             # Colocar o número convertido em a0
        ret

save_answer:

    # input: a0 é o número inteiro

    li t5, 0
    sb t6, (s1)
    bge a0, t5, positive
    li t6, 45
    sb t6, (s1)
    li t6, -1
    mul a0, a0, t6
    j cont_save_ans

    positive:
    li t6, 43 # +
    sb t6, (s1)

    cont_save_ans:
    addi s1, s1, 1

    li t5, 1000
    div t6, a0, t5
    addi t6, t6, 48
    sb t6, 0(s1) # Guarda em s1 na memória
    rem a0, a0, t5

    li t5, 100
    div t6, a0, t5
    addi t6, t6, 48
    sb t6, 1(s1) # Guarda em s1 na memória
    rem a0, a0, t5

    li t5, 10
    div t6, a0, t5
    addi t6, t6, 48
    sb t6, 2(s1) # Guarda em s1 na memória
    rem a0, a0, t5

    addi a0, a0, 48
    sb a0, 3(s1) # Guarda em s1 na memória

    li t5, 10
    sb t5, 4(s1) # adicionando espaço
    verqntqdeu:
    
    ret


read: # Precisa colocar o tamanho antes
    li a0, 0
    la a1, input_address  # buffer
    li a2, 7
    li a7, 63
    ecall
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, result       # buffer
    li a2, 8           # size - Writes 20 bytes.
    li a7, 64           # syscall write (64)
    ecall
    ret


.bss
input_address: .skip 8  # buffer

result: .skip 8