.globl _start

_start:
    jal main
    li a0, 0
    li a7, 93 # exit
    ecall


main:
    # Criar um for 4
        # Dentro do for, ler o i-ésimo número
        # Converter para inteiro
        # Chamar a função de raiz quadrada
        # Guardar resposta num buffer
        # Atualizar ponteiros utilizados


read:
    li a0, 0            # file descriptor = 0 (stdin)
    la a1, input_adress # buffer
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

    ret

char_to_int:
    # input: quatro numeros em forma de caracteres
    # output: os valores em int de cada número

    add a1, a1, -48
    add a2, a2, -48
    add a3, a3, -48
    add a4, a4, -48

    ret

bit_to_int:
    
    # input: 4 bytes guardado em 4 registradores diferentes
    # output: soma todos os valores e guarda em a5
    mul a5, a1, 1000
    mul a5, a2, 100
    mul a5, a3, 10
    mul a5, a4, 1

    ret

.bss

input_address: .skip 0x20  # buffer

result: .skip 0x20