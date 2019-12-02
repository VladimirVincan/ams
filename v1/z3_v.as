main:
	li a0 9
	li a1 7
	li a2 1
	jal min
	jal end

min: 
	addi t0, a0, 0
	blt t0, a1, skip_second
	addi t0, a1, 0
	skip_second: 
		blt t0, a2, skip_third
		addi t0, a2, 0
	skip_third: 
		addi a3, t0, 0 
	jalr ra

end: 
	nopll