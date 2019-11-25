li t0 6
addi s0 t0 0
addi t1 x0 1

lab1: nop 
addi t0 t0 -1
mul s0 s0 t0
bne t0, t1, lab1