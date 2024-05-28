.globl _start

_start:
  jal open_and_read # open e read o arquivo passado
  
  la a0, conteudo
  addi a0, a0, 3 # pula os tres primeiros caracteres "P5\n"
  la a1, largura
  la a2, altura
  jal read_number
  addi t1, a0, 0 # a funcao read_number retorna em a0 o numero de bytes pulados ate começar o vetor que representa a matriz de fato. salvo esse valor em t1

  la a2, largura
  la a3, altura
  jal set_canvas_size

  la a0, conteudo
  add a0, a0, t1 # movo meu endenreço do conteudo para o inicio do vetor que representa a matriz
  la a1, largura
  la a2, altura
  jal print

  li a0, 0
  li a7, 93 # exit
  ecall

print:
  addi a5, a0, 0        // vetor
  lh s1, 0(a1)          // max largura
  lh s2, 0(a2)          // max altura
  li a3, 255            // alfa
  la a4, pixel

  li t1, 0              // altura - y

for_altura:
  li t2, 0              // largura - x

for_largura:
  lb t6, 0(a5)
  addi a5, a5, 1

  sb a3, 0(a4)
  sb t6, 1(a4)
  sb t6, 2(a4)
  sb t6, 3(a4)

  mv a0, t2
  mv a1, t1
  lw a2, 0(a4)
  li a7, 2200           // syscall setPixel (2200)
  ecall

  addi t2, t2, 1
  blt t2, s1, for_largura

  addi t1, t1, 1
  blt t1, s2, for_altura

  ret

set_canvas_size:
  lh a0, 0(a2)
  lh a1, 0(a3)
  li a7, 2201
  ecall

  ret

read_number:
  li t1, 0
  li t2, 10
  li t4, 32
  li t5, 0
  lb t3, 0(a0) 

  diferente_espaco_largura:
    mul t1, t1, t2
    addi t3, t3, -48
    add t1, t1, t3
    addi a0, a0, 1
    addi t5, t5, 1
    lb  t3, 0(a0)
    bne t3, t4, diferente_espaco_largura

  sh t1, 0(a1)

  addi a0, a0, 1
  addi t5, t5, 1  

  li t1, 0
  lb t3, 0(a0)
  li t4, 10

  diferente_espaco_altura:
    mul t1, t1, t2
    addi t3, t3, -48
    add t1, t1, t3
    addi a0, a0, 1
    addi t5, t5, 1
    lb  t3, 0(a0)
    bne t3, t4, diferente_espaco_altura

  sh t1, 0(a2)

  addi a0, a0, 1 //estou no alfa, preciso ignora-lo
  addi t5, t5, 1
  li t4, 10
  lb t3, 0(a0)

  ignora_alfa:
    addi a0, a0, 1
    addi t5, t5, 1
    lb  t3, 0(a0)
    bne t3, t4, ignora_alfa

  addi a0, t5, 4 # ingnorando o alfa e os 3 chars "P5\n" inciais
  ret   

open_and_read:
  la a0, input_file    # address for the file path
  li a1, 0             # flags (0: rdonly, 1: wronly, 2: rdwr)
  li a2, 0             # mode
  li a7, 1024          # syscall open 
  ecall

  la a1, conteudo
  li a2, 300000        # size
  li a7, 63            # syscall read (63)
  ecall
  
  ret

.data

input_file: .string "image.pgm"

.bss

conteudo: .skip 300000

largura: .skip 2

altura: .skip 2

pixel: .skip 4