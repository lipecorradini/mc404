.data 

numbers: .skip 40

.text

largest:

# Suponha read function que salve os bytes em numbers, sinalizado por a0
la s0, numbers
lb a1, 0(s0) # Largest

li t0, 0
li t1, 10
li t3, 4

for_main:
    
    bge t0, t1, continue
    mul t2, t0, t3 # Multiplicamos por 4 porque podemos pular 4 bytes
    addi t2, t2, s0
    lw a2, (t2) # a2 = numbers[i]
    bge a1, a2, next
    mv a1, a2

next:
    addi t0, t0, 1
    jal for_main

continue:
    ret

