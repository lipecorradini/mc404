.globl _start

_start:
    jal main
    li a0, 0
    li a7, 93 # exit
    ecall


main:
    addi sp,sp,-4
    sw ra, 0(sp)

    jal open

    # Lendo o arquivo inteiro
    li a0, input_file
    li a2, 262159
    jal read
    mv s0, a0
    
    # Lendo o cabeçalho
    jal getSize

    jal setCanvasSize

    jal handleMatrix

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

getSize:
    # Saídas:
    # a0: tamanho da matriz
    # s0: ponteiro atualizado para o começo da matriz

    addi s0, s0, 3 # Começaremos pelo 3 byte sempre
    
    lb s1, 0(s0) # Primeiro dígito do tamanho
    addi s1, s1, -48
    addi s0, s0, 1

    lb s2, 0(s0) # Segundo dígito do tamanho
    beq s2, 32, dealSingle
    addi s2, s2, -48
    addi s0, s0, 1

    lb s3, 0(s0)
    beq s3, 32, dealDouble
    addi s3, s3, -48
    addi s0, s0, 1

    # Equivalente ao dealTriple
    li t1, 100
    li t2, 10

    mul s1, s1, t1
    mul s2, s2, t2
    add s1, s1, s2
    add s1, s1, s3

    addi s0, s0, 9
    mv a0, s1
    ret

dealSingle:
    # Valor em S1
    addi s0, s0, 7 # Pula o resto da linha e o 255, que será padrão
    mv a0, s1
    ret

dealDouble:
    li t1, 10
    mul s1, s1, 10
    addi s1, s1, s2
    addi s0, s0, 8 # Pula o resto da linha e o 255
    mv a0, s1
    ret

handleMatrix:
    # Entradas: a0: n

    addi sp,sp,-4
    sw ra, 0(sp)

    mul a1, a0, a0 # Tamanho da matriz

    li t0, 0
    mv t2, a1 # t2 o valor máximo
    mv t3, a0
    la a2, a2_buffer
    li t5, 255 # Salvando o Alfa

    for:
        bge t0, t2, endFor
        rem a0, t0, t3 # Guardando o X
        div a1, t0, t3 # Guardando o Y

        lb t4, 0(s0)

        sb t4, 0(a2) # Guardando o Vermelho
        sb t4, 1(a2) # Guardando o Verde
        sb t4, 2(a2) # Guardando o Azul
        sb t5, 3(a2) # Guardando o alfa

        jal setPixel

        addi t0, t0, 1 # Atualizando Índice
        addi s0, s0, 1 # Atualizando Endereço
        j for

    endFor:
        lw ra, 0(sp)
        addi sp, sp, 4
        ret


setPixel:
    li a7, 2200 # syscall setPixel (2200)
    ecall

setCanvasSize:
    mv a1, a0
    li a7, 2201
    ecall

open:
    la a0, input_file    # address for the file path
    li a1, 0             # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0             # mode
    li a7, 1024          # syscall open 
    ecall

read:
    la a1, input_adress # buffer
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


.bss

input_address: .skip 0x4000F # buffer for the whole file
input_file: .asciz "image.pgm"
a2_buffer: .skip 32

result: .skip 0x20