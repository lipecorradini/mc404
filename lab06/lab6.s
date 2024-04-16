.globl _start

_start:
    jal main
    li a0, 0
    li a7, 93 # exit
    ecall


main:
    # obs: sempre quando chamar uma função, adicionar o valor que quero trabalhar em a0

    # Criar um for 4
        # Dentro do for, ler o i-ésimo número
        # Converter para inteiro
        # Chamar a função de raiz quadrada
        # Guardar resposta num buffer
        # Atualizar ponteiros utilizados


sqrt:
    # Input: um número de quatro bytes, armazenado em a0
    # Saída: a raiz quadrada desse número


    div {u} a1, a0, 2 # Calcular a primeira estimativa, y/2
    li t1, 0 # Criando a variável
    li t2, 10 # Criando o número de iterações

    addi sp,sp,-4 
    sw ra, 0(sp)# Guardando o endereço de retorno
        
    lw ra,0(sp)
    addi sp, sp, 4
    ret

continue:
    ret

for_sqrt:
    # Input: número de iterações, em t0, e o número a ser extraída a raiz, em t10
    # Output: raiz quadrada desse número

    bge t1, t2, continue

    addi a2, a0, 0 # Guarda k em a2

    div {u} t5, a1, a2 # y/k
    addi t4, a2, t5 # k + y/k
    li t7, 2
    div{u} t4, t4, t7 # (k + y/k) / 2

    mv a0, t4 # Guarda o resultado em a0, para ser iterado de novo
    addi t1, t1, 1 # Adiciona 1 ao índice

    lw ra,0(sp)
    addi sp, sp, 4

    j for_sqrt # Volta para o início da função

read:
    li a0, 0            # file descriptor = 0 (stdin)
    la a1, input_address # buffer
    li a2, 20           # size - Reads 20 bytes.
    li a7, 63           # syscall read (63)
    ecall
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, result       # buffer
    li a2, 20           # size - Writes 20 bytes.
    li a7, 64           # syscall write (64)
    ecall
    ret

read_digit:
    # input: string toda salva em a0
    # output: 4 registradores com os 4 primeiros dígitos
    # obs: nessa função, pode variar o valor do a0. ou seja,
     # assim que ler os 4 primeiros, soma-se 5 ao ponteiro

    lbu a1, 0(a0)
    lbu a2, 1(a0)
    lbu a3, 2(a0)
    lbu a4, 3(a0)

    lw ra,0(sp)
    addi sp, sp, 4

    ret

char_to_int:
    # input: quatro numeros em forma de caracteres
    # output: os valores em int de cada número

    addi sp,sp,-4
    sw ra, 0(sp)

    add a1, a1, -48
    add a2, a2, -48
    add a3, a3, -48
    add a4, a4, -48

    lw ra,0(sp)
    addi sp, sp, 4

    ret

bit_to_int:
    
    # input: 4 bytes guardado em 4 registradores diferentes
    # output: soma todos os valores e guarda em a5

    addi sp,sp,-4
    sw ra, 0(sp)

    mul a5, a1, 1000
    mul a5, a2, 100
    mul a5, a3, 10
    mul a5, a4, 1

    lw ra,0(sp)
    addi sp, sp, 4

    ret

.bss

input_address: .skip 0x20  # buffer

result: .skip 0x20