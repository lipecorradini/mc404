.globl _start

_start:
    jal main
    end:
    li a0, 0
    li a7, 93 # exit
    ecall
    ret

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

    jal see_output_size

    mv a3, a0
    la s2, result
    jal save_answer

    mv a2, a3
    addi a2, a2, 1

    jal write

    lw ra, 0(sp)
    addi sp, sp, 4
    jal end
    ret

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

    # Vendo se chegou na somalo correta
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

    loop_in:
        beq t4, t5, fim_read
        addi t4, t4, -48        # Converter caractere para número
        mul t1, t1, t3        # Multiplicar o acumulador por 10
        add t1, t1, t4        # Adicionar o dígito ao acumulador
        addi t0, t0, 1        # Mover para o próximo caractere
        lbu t4, 0(t0)          # Ler o próximo caractere
        j loop_in            # Caso contrário, tornar o número negativo

    fim_read:
        mul t1, t1, t2
        mv a0, t1             # Colocar o número convertido em a0
        ret
        
see_output_size:
    # Input: número em a0
    # Output: número de casas decimais do número em a0
    #       : número invertido salvo em s1

    li t0, 0
    mv s2, a0
    li t5, 10
    la s1, buff
    li t4, 1
    bge a0, t0, loop_out # Se for maior que t0, segue normal    
    li t4, -1 
    mul a0, a0, t4 # Torna o número positivo
    mv s2, a0
    addi t0, t0, 1

    loop_out:
    addi t0, t0, 1 # Incrementando Contador
    rem s3, s2, t5 # Pega o resto da divisão
    div s2, s2, t5 # Pega a divisão
    addi s3, s3, 48 # Transformando em caractere
    sb s3, (s1) # Guardando no Buffer
    addi s1, s1, 1 # Incrementando o Buffer
    beqz s2, fim_loop # Se a divisão for zero, termina

    j loop_out

    fim_loop:
        mv a0, t0
        li t0, 0
        bge t0, t4, add_neg
        ret

    add_neg:
        li t4, 45
        sb t4, (s1) # Guarda o sinal de -
        addi s1, s1, 1 # Incrementa o buffer
        addi a0, a0, 1
        ret

save_answer:

    # input: número de casas do número em a0
    #        : número invertido em s1 
    # output: número guardado em s2

    li t1, -1
    li t3, 0
    addi s1, s1, -1
    loop:
        lb t2, (s1)
        sb t2, (s2)
        addi s1, s1, -1
        addi s2, s2, 1
        addi a0, a0, -1
        bge t3, a0, fim_save
        j loop

    fim_save:
        li t5, 10
        sb t5, (s2)
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
    # li a2, 8           # size - Writes 20 bytes.
    li a7, 64           # syscall write (64)
    ecall
    ret


.bss
input_address: .skip 8  # buffer

result: .skip 8

buff: .skip 8