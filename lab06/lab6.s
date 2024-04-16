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
    la s1, input_address # Carrega o input em s1

    la s0, result

    li a1, 100

    mv a7, a1
    jal save_answer
    
    jal write

    lw ra,0(sp)
    addi sp, sp, 4

    ret

sqrt:
    # Input: um número de quatro bytes, armazenado em a0
    # Saída: a raiz quadrada desse número

    li t6, 2
    div a1, a0, t6 # Calcular a primeira estimativa, y/2
    li t1, 0 # Criando a variável do índice
    li t2, 10 # Criando o número de iterações

        for_sqrt:
        # Input: número de iterações, em t0, e o número a ser extraída a raiz, em t10
        # Output: raiz quadrada desse número

        bge t1, t2, continue

        div t5, a0, a1 # y/k

        add t4, a1, t5 # k + y/k

        li t6, 2
        div t4, t4, t6 # (k + y/k) / 2

        mv a1, t4 # Guarda o resultado em a1, para ser iterado de novo
        addi t1, t1, 1 # Adiciona 1 ao índice

        j for_sqrt # Volta para o início da função
        
    ret

continue:
    ret

read:
    li a0, 0            # file descriptor = 0 (stdin)
    la a1, input_address # buffer
    li a2, 20         # size - Reads 20 bytes.
    li a7, 63           # syscall read (63)
    ecall
    ret


write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, result       # buffer
    li a2, 20         # size - Writes 20 bytes.
    li a7, 64           # syscall write (64)
    ecall
    ret

read_digit:
    # input: string toda salva em a0
    # output: 4 registradores com os 4 primeiros dígitos
    # obs: nessa função, pode variar o valor do a0. ou seja,
     # assim que ler os 4 primeiros, soma-se 5 ao ponteiro

    lbu a1, 0(s1)
    addi a1, a1, -48

    lbu a2, 1(s1)
    addi a2, a2, -48

    lbu a3, 2(s1)
    addi a3, a3, -48

    lbu a4, 3(s1)
    addi a4, a4, -48
    ret

bit_to_int:
    
    # input: 4 bytes guardado em 4 registradores diferentes
    # output: soma todos os valores e guarda em a5

    li t1, 1000
    li t2, 100
    li t3, 10
    li t4, 1

    mul a5, a1, t1
    mul a5, a2, t2
    mul a5, a3, t3
    mul a5, a4, t4

    ret

save_answer:

    # input: a7 é o número inteiro

    li t0, 1000
    div t1, a7, t0
    addi t1, t1, 48
    sb t1, 0(s0) # Guarda em s0 na memória
    rem a7, a7, t0

    li t0, 100
    div t1, a7, t0
    addi t1, t1, 48
    sb t1, 1(s0) # Guarda em s0 na memória
    rem a7, a7, t0

    li t0, 10
    div t1, a7, t0
    addi t1, t1, 48
    sb t1, 2(s0) # Guarda em s0 na memória
    rem a7, a7, t0

    li t0, 1
    mv t1, a7
    addi t1, t1, 48
    sb t1, 3(s0) # Guarda em s0 na memória
    
    ret

.bss

input_address: .skip 0x20  # buffer

result: .skip 0x20