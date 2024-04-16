.globl _start

_start:
    jal main
    li a0, 0
    li a7, 93 # exit
    ecall


main:

    addi sp,sp,-4
    sw ra, 0(sp)

    j read
    mv s0, a1

    j read_digit
    j write
    ret 


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

    lbu a1, 0(s0)
    lbu a2, 1(s0)
    lbu a3, 2(s0)
    lbu a4, 3(s0)

    lw ra,0(sp)
    addi sp, sp, 4

    ret


.bss

input_address: .skip 0x20  # buffer

result: .skip 0x20