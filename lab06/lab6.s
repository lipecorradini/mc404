.globl _start

_start:
    jal main
    li a0, 0
    li a7, 93 # exit
    ecall

.text


main:
    # obs: sempre quando chamar uma função, adicionar o valor que quero trabalhar em a0

    addi sp,sp,-4
    sw ra, 0(sp)
     
    jal read

    la s0, input_address # Carrega o input em s0
    la s1, result

    li t1, 0
    li t2, 4

    for_main:
        
        bge t1, t2, continue_main
        jal read_digit
        jal bit_to_int
        mv a0, a5
        jal sqrt
        mv a7, a1
        jal save_answer
        addi s0, s0, 5
        addi s1, s1, 5
        addi t1, t1, 1
        j for_main
    
    continue_main:

        li t5, 10
        sb t5, 4(s0) # adicionando \n
        jal write
        lw ra,0(sp)
        addi sp, sp, 4
        ret

read:
    li a0, 0                # file descriptor = 0 (stdin)
    la a1, input_address    # buffer
    li a2, 20               # size - Reads 20 bytes.
    li a7, 63               # syscall read (63)
    ecall
    ret


write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, result       # buffer
    li a2, 20           # size - Writes 20 bytes.
    li a7, 64           # syscall write (64)
    ecall
    ret

save_answer:

    # input: a7 é o número inteiro

    li t5, 1000
    div t6, a7, t5
    addi t6, t6, 48
    sb t6, 0(s1) # Guarda em s1 na memória
    rem a7, a7, t5

    li t5, 100
    div t6, a7, t5
    addi t6, t6, 48
    sb t6, 1(s1) # Guarda em s1 na memória
    rem a7, a7, t5

    li t5, 10
    div t6, a7, t5
    addi t6, t6, 48
    sb t6, 2(s1) # Guarda em s1 na memória
    rem a7, a7, t5

    addi a7, a7, 48
    sb a7, 3(s1) # Guarda em s1 na memória

    li t5, 10
    sb t5, 4(s1) # adicionando espaço
    
    ret

sqrt:
    # Input: um número de quatro bytes, armazenado em a0
    # Saída: a raiz quadrada desse número

    li t6, 2
    div a1, a0, t6 # Calcular a primeira estimativa, y/2
    li t3, 0 # Criando a variável do índice
    li t5, 10 # Criando o número de iterações

    for_sqrt:
        # Input: número de iterações, em t0, e o número a ser extraída a raiz, em t30
        # Output: raiz quadrada desse número

        bge t3, t5, continue
        div a6, a0, a1 # (y/k)
        add t4, a1, a6 # (k + y/k)
        div t4, t4, t6 # (k + y/k) / 2
        mv a1, t4 # Guarda o resultado em a1, para ser iterado de novo
        addi t3, t3, 1 # Adiciona 1 ao índice
        j for_sqrt # Volta para o início da função

    continue:
        ret

read_digit:
    # input: string toda salva em a0
    # output: 4 registradores com os 4 primeiros dígitos
    # obs: nessa função, pode variar o valor do a0. ou seja,
     # assim que ler os 4 primeiros, soma-se 5 ao ponteiro

    lbu a1, 0(s0)
    addi a1, a1, -48

    lbu a2, 1(s0)
    addi a2, a2, -48

    lbu a3, 2(s0)
    addi a3, a3, -48

    lbu a4, 3(s0)
    addi a4, a4, -48
    ret

bit_to_int:
    
    # input: 4 bytes guardado em 4 registradores diferentes
    # output: soma todos os valores e guarda em a5

    li t6, 1000
    mul a1, a1, t6
    li t6, 100
    mul a2, a2, t6
    li t6, 10
    mul a3, a3, t6
    li t6, 1
    mul a4, a4, t6

    li a5, 0
    add a5, a5, a1
    add a5, a5, a2
    add a5, a5, a3
    add a5, a5, a4

    ret

.bss

.data
input_address: .skip 0x20  # buffer

result: .skip 0x20