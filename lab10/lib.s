.globl puts
.globl gets
.globl atoi
.globl itoa
.globl exit

.text

# -------------------------------PUTS--------------------------------------
puts:
    # Entrada: String de acordo com as normas ABI (a0)
    # Saída: String imprimida na tela

    # Salvando o Endereço de Retorno
    addi sp, sp, -4
    sw ra, 0(sp)
    mv s3, a0
    testar_entrada_puts:
    
    la s0, result # Buffer que será armazenado
    li t0, 10 # Definindo o '\0'
    li t1, 0 # Definindo a variável contadora
    li s1, 0

    # Percorrer a string até encontrar um '\0'
    loop_puts:
        beq s1, t0, end_puts
        ver_char:
        lb s1, (s3) # Salvando novo caractere em s1
        sb s1, (s0)
        addi s3, s3, 1
        addi s0, s0, 1
        addi t1, t1, 1 # Incrementando Contador
        j loop_puts
    
    end_puts:
        li t3, 10 # Trocando o '\0' por '\n'
        addi s0, s0, -1
        sb t3, (s0)

        # Função Write, escreverá todo o buffer
        li a0, 1            # file descriptor = 1 (stdout)
        la a1, result       # buffer
        mv a2, t1            # size - Writes t1 bytes.
        li a7, 64           # syscall write (64)
        ecall

        # Retomando endereço de Retorno
        lw ra, (sp)
        addi sp, sp, 4
        ret


# -------------------------------GETS--------------------------------------

gets:
    # Entrada: Endereço onde a String deve ser lida
    # Saída: Leitura da String

    # Salvando o Endereço de Retorno
    addi sp, sp, -4
    sw ra, (sp)
    avaliar_entrada_gets:
    mv s3, a0 # Endereço para ser guardado em s3
    mv s4, a0

    # Iterar pelos caracteres dando read, até ser '\0'
    la s0, input # Onde será lido
    # mv s2, a0 # Guardando o a0
    li t0, 10
    li t1, 0 # Contador
    li s1, 0
    loop_gets:
        beq s1, t0, end_gets
        # Lendo o caractere
        li a0, 0                # file descriptor = 0 (stdin)
        la a1, input            # buffer
        li a2, 1                # size - Reads 1 byte.
        li a7, 63               # syscall read (63)
        ecall

        lb s1, (s0) # Guardando o valor que foi lido em s1
        sb s1, (s3) # Guardando o valor que foi lido em result
        addi s3, s3, 1 # Atualizando endereço de result
        j loop_gets
    # 0x000123e0
    end_gets:
        li t0, 10
        addi s3, s3, -1
        sb t0, (s3)
        mv a0, s4
        testar_gets:

        # Retomando endereço de Retorno
        lw ra, (sp)
        addi sp, sp, 4
        ret


# -------------------------------ATOI--------------------------------------

atoi:

    # Salvando o Endereço de Retorno
    addi sp, sp, -4
    sw ra, (sp)

    li t1, 0              # t1 é o acumulador do número
    li t2, 1            # t2 será usado para identificar o sinal do número
    li t3, 10             # t3 é a base decimal (10)
    mv t0, a0              # movendo o buffer para t0

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
        li t5, 10       # Caractere fim de linha

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
        mv a0, t1           # Colocar o número convertido em a0

        # Retomando endereço de Retorno
        lw ra, (sp)
        addi sp, sp, 4
        ret
        

# -------------------------------ITOA--------------------------------------

itoa:

    # (int)(a0) valor a ser convertido em a0
    # (char *)(a1) string para qual será convertida
    # (*int)(a2) base


    # Salvando o Endereço de Retorno
    addi sp, sp, -4
    sw ra, (sp)


    li t0, 0 # Contador
    mv s2, a0 # Guardando o número em s2
    mv t5, a2 # Base em t5
    mv s4, a1 # Guardando o buffer
    la s1, result
    li t4, 1

    bge s2, t0, loop_out # Se for maior que t0, segue normal    
    li t4, -1 
    mul s2, s2, t4 # Torna o número positivo
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
        mv s3, t0
        li t0, 0
        bge t0, t4, add_neg
        j save_answer

    add_neg:
        li t4, 45
        sb t4, (s1) # Guarda o sinal de -
        addi s1, s1, 1 # Incrementa o buffer
        addi s3, s3, 1
        j save_answer

# Parte 2

    save_answer:
        li t3, 0
        addi s1, s1, -1
        mv s2, a1

    loop_itoa:
        # em s1 está a string invertida
        # em s2 estará o novo buffer
        lb t2, (s1)
        sb t2, (s2)
        addi s1, s1, -1
        addi s2, s2, 1
        addi s3, s3, -1
        bge t3, s3, fim_save
        j loop_itoa

    fim_save:
        li t5, 10
        sb t5, (s2)
        mv a0, a1

        # Retomando endereço de Retorno
        lw ra, (sp)
        addi sp, sp, 4
        ret

# -------------------------------EXIT--------------------------------------

exit:
    li a7, 93 # exit
    ecall
    ret


read:
    li a0, 0                # file descriptor = 0 (stdin)
    la a1, input            # buffer
    li a2, 1                # size - Reads 20 bytes.
    li a7, 63               # syscall read (63)
    ecall
    ret

.data 

.bss
result: .skip 200000
input: .skip 4
