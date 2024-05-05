.globl _start

_start:
    jal main
    li a0, 0
    li a7, 93 # exit
    ecall

main:

    addi sp,sp,-4
    sw ra, 0(sp)
    # Código aqui

    jal read_coordinates
    la s0, coordinates_in
    la s3, coordinates_out
    jal coordinates_to_int # 0(s3): Xc; 1(s3): Yb

    lw a7, 0(s3)
    jal save_answer
    jal write

    jal read_times
    la s1, times_in
    la s2, times_out
    jal times_to_int # retorna os tempos em posições distintas de s2(talvez seja mais inteligente separar em registradores mesmo)

    # a partir daqui, ja deveríamos ter os números inteiros guardados nos registradores, cada um ocupando 4 bytes

    lw ra,0(sp)
    addi sp, sp, 4


times_to_int:

    li t1, 0
    li t2, 4

    loop_times_to_int:
        
        bge t1, t2, end_loop_times_to_int
        jal read_digit
        sw a5, (s2)
        addi s1, s1, 5 # Atualizando ponteiros da entrada
        addi s2, s2, 5 # Atualizando ponteiros da saída, ns se ta certo
        addi t1, t1, 1
        j loop_times_to_int
    
    end_loop_times_to_int:
        ret


coordinates_to_int:

    li t1, 1 # Multiplicador
    li t3, -1
    li t4, 45
    lb t2, 0(s0) # Lê o sinal
    bne t2, t4, if_coordinates_to_int # Se for positivo, pula
    mul t1, t1, t3 # Se o sinal for negativo

    if_coordinates_to_int:
        addi s0, s0, 1 # Ajusta o ponteiro
        jal read_digit # Número INT em a5
        mul a5, a5, t1 # Multiplicando pelo sinal
        sw a5, 0(s3) # Xc guardado em 0(s0), verificar se funciona
        li t1, 1

        addi s0, s0, 5

        lb t2, 0(s0)
        bne t2, t4, if_coordinates_to_int_2
        mul t1, t1, t3 # Se o sinal for negativo

    if_coordinates_to_int_2:

        addi s0, s0, 1 # Precisa?
        addi s3, s3, 4
        jal read_digit # Número INT em a5
        mul a5, a5, t1 # Multiplicando pelo sinal
        sw a5, 0(s3) # Yb guardado em 1(s3)
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

    jal bit_to_int
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




read_coordinates:
    li a0, 0            # file descriptor = 0 (stdin)
    la a1, coordinates_in  # buffer
    li a2, 12           # size -
    li a7, 63           # syscall read (63)
    ecall
    ret

read_times:
    li a0, 0            # file descriptor = 0 (stdin)
    la a1, coordinates_out       # buffer
    li a2, 20           # size - Reads 20 bytes.
    li a7, 63           # syscall read (63)
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

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, coordinates_out       # buffer
    li a2, 20           # size - Writes 20 bytes.
    li a7, 64           # syscall write (64)
    ecall
    ret


.bss

coordinates_in: .skip 12 # buffer
coordinates_out: .skip 20

times_in: .skip 0x20
times_out: .skip 18

result: .skip 0x20