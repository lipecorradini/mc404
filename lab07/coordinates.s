.globl _start

_start:
    jal main
    li a0, 0
    li a7, 93 # exit
    ecall

.text 

# Xc: s6
# Yb: a5
# ta: t1
# tb: t2
# tc: t3
# tr: t4
# da: a1
# db: a2
# dc: a3 
# x: s4
# y: s5

main:

    addi sp,sp,-4
    sw ra, 0(sp)

    la s0, input_address
    la s1, result

    jal read_coordinates
    jal read_times
    parando:
    jal calculating_distances
    jal calculating_x_y

    mv a7, s4
    jal save_answer

    addi s1, s1, 5
    
    mv a7, s5
    jal save_answer

    jal write

    lw ra,0(sp)
    addi sp, sp, 4

    ret

read_coordinates:

    addi sp,sp,-4
    sw ra, 0(sp)

    la s0, input_address
    li a2, 12
    jal read

    li t1, 1 # Multiplicador
    li t3, -1
    li t4, 45
    lb t2, 0(s0) # Lê o sinal
    bne t2, t4, if_read_coordinates # Se for positivo, pula
    mul t1, t1, t3 # Se o sinal for negativo, multiplica por -1

    if_read_coordinates:
    
    addi s0, s0, 1 # Ajusta o ponteiro
    jal read_digit # Número INT em a5
    mul a5, a5, t1 # Multiplicando pelo sinal, e guardando Xc em s6
    mv s6, a5
    li t1, 1

    addi s0, s0, 5

    lb t2, 0(s0)
    bne t2, t4, if_read_coordinates_2
    mul t1, t1, t3 # Se o sinal for negativo

    if_read_coordinates_2:

    addi s0, s0, 1
    jal read_digit # Número INT em a5
    mul a5, a5, t1 # Multiplicando pelo sinal, e yb está em a6
    mv a6, a5
    
    lw ra,0(sp)
    addi sp, sp, 4
    ret

read_times:

    addi sp,sp,-4
    sw ra, 0(sp)
    la s2, times
    
    la s0, input_address
    li a2, 20
    jal read

    li t1, 0
    li t2, 4

    loop_read_times:
        
    bge t1, t2, end_loop_read_times
    jal read_digit
    sw a5, (s2)
    addi s0, s0, 5 # Atualizando ponteiros da entrada
    addi s2, s2, 4 # Atualizando ponteiros da saída
    addi t1, t1, 1
    j loop_read_times
    
    end_loop_read_times:

    la s2, times
    lw t4, (s2) # tr: t4
    addi s2, s2, 4
    lw t1, (s2) # ta: t1
    addi s2, s2, 4
    lw t2, (s2) # tb: t2
    addi s2, s2, 4
    lw t3, (s2) # tc: t3

    debug:

    lw ra, 0(sp)
    addi sp, sp, 4

    ret

calculating_distances:
    
    sub a1, t4, t1
    sub a2, t4, t2
    sub a3, t4, t3

    # retorna as distancias em a1, a2 e a3
    li t5, 300000000
    mul a1, a1, t5 # da
    mul a2, a2, t5
    mul a3, a3, t5

    ret

calculating_x_y:
    # Retorna x em s4
    
    mul s4, a1, a1
    mul t2, a3, a3 
    sub s4, s4, t2 # da² - dc²
    mul t2, a4, a4
    sub s4, s4, t2 # (da² - dc²) - xc²
    add t2, a4, a4
    div s4, s4, t2 # ((da² - dc²) - xc²)/(2xc)

    # Retorna y em s5
    
    mul s5, a1, a1 # da²
    mul t2, a5, a5 # yb²
    add s5, s5, t2 # da² + yb²
    mul t2, a2, a2 # db²
    sub s5, s5, t2 # (da² + yb²) - db²
    add t2, a5, a5 # 2yb
    div s5, s5, t2 # ((da² + yb²) - db²)/(2yb)

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

read: # Precisa colocar o tamanho antes
    
    li a0, 0
    la a1, input_address  # buffer
    li a7, 63
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
    la a1, result       # buffer
    li a2, 20           # size - Writes 20 bytes.
    li a7, 64           # syscall write (64)
    ecall
    ret


.bss

times: .skip 40
result: .skip 40
input_address: .skip 40
