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
    jal read
    mv s0, a1
    
    # Lendo o cabeçalho
    addi s0, s0, 3 # Começaremos pelo 4 byte sempre

    jal getSize
    mv a1, a0
    jal getSize
        # Colunas em a1 e Linhas em a0

    mv t5, a0
    mv a0, a1
    mv a1, t5

    # Setando o Canvas
    jal setCanvasSize

    # Pulando equivalente à intensidade
    jal jumpIntensity

    # Salvando os Pixels no Canvas
    jal handleMatrix

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

getSize:
    # Saídas:
    # a0: tamanho da matriz
    # s0: ponteiro atualizado para o começo da matriz

    li t1, 32 # Barra de Espaço
    
    lb s1, 0(s0) # Primeiro dígito do tamanho
    addi s1, s1, -48
    addi s0, s0, 1

    lb s2, 0(s0) # Segundo dígito do tamanho
    beq s2, t1, dealSingle
    addi s2, s2, -48
    addi s0, s0, 1

    lb s3, 0(s0)
    beq s3, t1, dealDouble
    addi s3, s3, -48
    addi s0, s0, 1

    # Equivalente ao dealTriple
    li t1, 100
    li t2, 10

    mul s1, s1, t1
    mul s2, s2, t2
    add s1, s1, s2
    add s1, s1, s3

    addi s0, s0, 1
    mv a0, s1
    ret

dealSingle:
    # Valor em S1
    addi s0, s0, 1
    mv a0, s1
    ret

dealDouble:
    li t1, 10
    mul s1, s1, t1
    add s1, s1, s2
    addi s0, s0, 1
    mv a0, s1
    ret

jumpIntensity:
    li t1, 10 # '\n'
    addi s0, s0, 1
    lb s1, (s0)
    # Ve se o segundo é '\n'
    beq s1, t1, endHeader

    addi s0, s0, 1
    lb s1, (s0)
    # Ve se o terceiro é '\n'
    beq s1, t1, endHeader

    # Assume que o quarto é '\n'
    addi s0, s0, 1

endHeader:
    addi s0, s0, 1
    ret

handleMatrix:
    # Entradas: a0: colunas
    #         : a1: linhas

    addi sp,sp,-4
    sw ra, 0(sp)

    mv s1, a0
    mv s2, a1

    mul t2, a0, a1 # Tamanho da matriz

    li t0, 0 # Contador
    mv t3, s1 # Guardando o número de colunas
    li t5, 255 # Salvando o Alfa
    la a2, a2_buffer # Salvando o Buffer

    for:
        bge t0, t2, endFor
        rem a0, t0, t3 # Guardando o X
        div a1, t0, t3 # Guardando o Y

        lb t4, 0(s0)

        vercmc:
        li t0, 0xFF000000
        li t1, 0x00Ff0000

        

        sb t4, 3(a2) # Guardando o Vermelho
        # lb t6, 0(a2)
        sb t4, 2(a2) # Guardando o Verde
        # lb t6, 1(a2)
        sb t4, 1(a2) # Guardando o Azul
        # lb t6, 2(a2)
        sb t5, 0(a2) # Guardando o Alfa
        # lb t6, 3(a2)

        vpix:

        jal setPixel

        addi t0, t0, 1 # Atualizando Índice
        addi s0, s0, 1 # Atualizando Endereço
        j for

        # verprox:
        #    j for
         

    endFor:
        lw ra, 0(sp)
        addi sp, sp, 4
        ret

    # verprimdif:
    #     ret

setPixel:
    # li a2, 0xFF007FFF
    li a7, 2200 # syscall setPixel (2200)
    ecall
    ret

setCanvasSize:
    li a7, 2201
    ecall
    ret

open:
    la a0, input_file    # address for the file path
    li a1, 0             # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0             # mode
    li a7, 1024          # syscall open 
    ecall
    ret

read:
    la a1, input_address # buffer
    li a2, 262159
    li a7, 63           # syscall read (63)
    ecall
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, a2_buffer       # buffer
    li a2, 5           # size - Writes 20 bytes.
    li a7, 64           # syscall write (64)
    ecall
    ret

.bss

input_address: .skip 0x4000F # buffer for the whole file
a2_buffer: .skip 4

.data
input_file: .asciz "image.pgm"