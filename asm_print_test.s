

.data
#print, zeroes, max, and direction
#alpha, bravo, gamma,delta. 
	print:		.word	1
	zeroes:		.word	1
	max:		.word	1
	direction:	.word	1

	alpha:		.word	10
	bravo:		.word	0
	gamma:		.word	-10
	delta:		.word	50

#these parts are always top.
.text
LOAD_VALUES:
#Load everything first
#$s0 = print, $s1 = zeroes, $s2 = max, $s3 = direction
#$s4 = alpha, $s5 = bravo, $s6 = gamma, $s7 = delta
	la 	$t0, print
	lw 	$s0, 0($t0)
	
	la 	$t0, zeroes
	lw 	$s1, 0($t0)
	
	la 	$t0, max
	lw 	$s2, 0($t0)
	
	la 	$t0, direction
	lw 	$s3, 0($t0)
	
	la 	$t0, alpha
	lw 	$s4, 0($t0)
	
	la 	$t0, bravo
	lw 	$s5, 0($t0)
	
	la 	$t0, gamma
	lw 	$s6, 0($t0)
	
	la 	$t0, delta
	lw 	$s7, 0($t0)


CHECK_PRINT:

	bne 	$s0, 1, CHECK_ZEROES

PRINT_PRINT:
.data
	msgAlpha: 	.asciiz "alpha"
	msgBravo: 	.asciiz "bravo"
	msgGamma: 	.asciiz "gamma"
	msgDelta: 	.asciiz "delta"
	msgColonWithSpace:	.asciiz ": "
	
.text
	#print alpha
	addi $v0, $zero, 4
	la $a0, msgAlpha
	syscall
	la $a0, msgColonWithSpace
	syscall
	addi $v0, $zero, 1
	add $a0, $zero, $zero
	add $a0, $zero,$s4
	syscall
	addi $v0, $zero, 11
	la $a0, '\n'
	syscall
	
	#print bravo
	addi $v0, $zero, 4
	la $a0, msgBravo
	syscall
	la $a0, msgColonWithSpace
	syscall
	addi $v0, $zero, 1
	add $a0, $zero, $zero
	add $a0, $zero,$s5
	syscall
	addi $v0, $zero, 11
	la $a0, '\n'
	syscall
	
	#print gamma
	addi $v0, $zero, 4
	la $a0, msgGamma
	syscall
	la $a0, msgColonWithSpace
	syscall
	addi $v0, $zero, 1
	add $a0, $zero,$zero
	add $a0, $zero,$s6
	syscall
	addi $v0, $zero, 11
	la $a0, '\n'
	syscall
	
	#print delta
	addi $v0, $zero, 4
	la $a0, msgDelta
	syscall
	la $a0, msgColonWithSpace
	syscall
	addi $v0, $zero, 1
	add $a0, $zero,$zero
	add $a0, $zero,$s7
	syscall
	addi $v0, $zero, 11
	la $a0, '\n'
	syscall
	
	#
	addi $v0, $zero, 11
	la $a0, '\n'
	syscall

CHECK_ZEROES:
#If zeroes==1, then total up all 4 of the variables (alpha, bravo, gamma,
#delta) and print out exactly how many of them are zero.
.data 
	zeroCounter:	.word 0
.text
	bne	$s1, 1, PRINT_ZEROES

CHECK_ZEROES_INDIVIDUALS:
	# Load the zeroCounter first
	la	$t0, zeroCounter
	lw	$t1, 0($t0) 

CHECK_INCREMENT_ALPHA:		
	#Check alpha
	la $t0, alpha
	lw $t3, 0($t0) 
	bne $t3, 1, CHECK_INCREMENT_BRAVO
	
	# Increment zero
	addi	$t1, $t1, 1
	
CHECK_INCREMENT_BRAVO:
	#Check alpha
	la	$t0, bravo
	lw	$t3,0($t0) 
	bne	$t3, 1, CHECK_INCREMENT_GAMMA
	
	# Increment zero
	addi	$t1, $t1, 1

CHECK_INCREMENT_GAMMA:
	#Check alpha
	la 	$t0, gamma
	lw 	$t3, 0($t0) 
	bne	$t3, 1, CHECK_INCREMENT_DELTA
	
	# Increment zero
	addi	$t1, $t1, 1

CHECK_INCREMENT_DELTA:
	#Check alpha
	la	$t0, delta
	lw	$t3, 0($t0) 
	bne	$t3, 1, PRINT_ZEROES
	
	# Increment zero
	addi	$t1, $t1, 1
	
PRINT_ZEROES:
.data
	ZeroMsgOpening:	.asciiz "There are "
	ZeroMsgClosing:	.asciiz " variables which are zero.\n"

.text
	
	addi	$v0, $zero, 4
	la	$a0, ZeroMsgOpening
	syscall
	addi	$v0, $zero, 1
	add	$a0, $zero, $t1
	syscall
	addi	$v0, $zero, 4
	la	$a0, ZeroMsgClosing
	syscall
	
	#Empty line
	addi	$v0, $zero, 11
	la	$a0, '\n'
	syscall
	
CHECK_MAX:
#If max==1, then print out the max of all 4 of the variables (alpha, bravo,
#gamma, delta).

	bne $s2, 1, CHECK_DIRECTION

CALCULATE_MAX:
.data
	curMax:		.word 0			# Will be tracked in $t1
	# The ascii strings will be tracked in $t2, will be set to alpha initially.
	# The string labels are: msgAlpha, msgBravo, msgGamme, msgDelta

.text
	sw	$s4, curMax # Save alpha value into curMax address
	la	$t0, curMax
	lw	$t1, 0($t0)
	la	$t2, msgAlpha # Associate $t2 to curMaxMsgAlpha, set to alpha because that's the start.
	
IS_CURMAX_LARGER_THAN_BRAVO:	
	# !!!---curMax is alpha---!!!
	# If alpha > bravo
	slt 	$t3, $t1, $s5
	bne 	$t3, 1, IS_CURMAX_LARGER_THAN_GAMMA
	# Update value of $t1 and curMax
	sw	$s5, curMax
	la	$t0, curMax
	lw	$t1, 0($t0)
	# Update value of $t2
	la	$t2, msgBravo
	
	

IS_CURMAX_LARGER_THAN_GAMMA:
	slt 	$t3, $t1, $s6
	bne 	$t3, 1, IS_CURMAX_LARGER_THAN_DELTA

	sw	$s6, curMax
	la	$t0, curMax
	lw	$t1, 0($t0)
	
	la	$t2, msgGamma

IS_CURMAX_LARGER_THAN_DELTA:
	slt 	$t3, $t1, $s7
	bne 	$t3, 1, PRINT_MAX

	sw	$s7, curMax
	la	$t0, curMax
	lw	$t1, 0($t0)

	la	$t2, msgDelta

PRINT_MAX:
#i.e."The max is alpha, and it has the value 10"
.data
	maxMsgOpening: .asciiz "The max is "
	maxMsgMiddle: .asciiz ", and it has the value "

.text
	
	addi	$v0, $zero, 4
	la	$a0, maxMsgOpening
	syscall
	la	$a0, 0($t2)
	syscall
	la	$a0, maxMsgMiddle
	syscall
	addi	$v0, $zero, 1
	add	$a0, $zero, $t1
	syscall
	addi	$v0, $zero, 11
	la	$a0, '.'
	syscall
	la	$a0, '\n'
	syscall
	
	la	$a0, '\n'
	syscall
	
	j CHECK_DIRECTION
	

CHECK_DIRECTION:
# If direction==1, then you will scan through the variables (alpha, bravo,
# gamma, delta) in order, and compare each one to the one before. You will then
# print out a line for each, which describes whether the value went up or down:
# i.e "alpha -> bravo: DOWN"
# "bravo -> gamma: EQUAL"
# "gamma -> delta: UP"

.data
	directionMsgMiddle:	.asciiz " -> "
	# Can call ": " by its label: msgColonWithSpace
	directionMsgEqual:	.asciiz "EQUAL\n"
	directionMsgDown:	.asciiz "DOWN\n"
	directionMsgUp:	.asciiz "UP\n"
	
.text
	bne	$s3, 1, END
	addi	$v0, $zero, 4
	la	$a0, msgAlpha
	syscall
	la	$a0, directionMsgMiddle
	syscall
	la	$a0, msgBravo
	syscall
	la	$a0, msgColonWithSpace
	syscall

# The logic goes, if a is equals to b, then head to next part.
# If not, than check is a < b. If false, then print UP and go to next part.
# Else, print DOWN.		
DIRECTION_EQUAL_ALPHA_BRAVO:
	bne	$s4, $s5, DIRECTION_LT_ALPHA_BRAVO
	la	$a0, directionMsgEqual
	syscall
	
	j DIRECTION_EQUAL_BRAVO_GAMMA # Jump to next because the next two parts are exclusive to this part.
	
DIRECTION_LT_ALPHA_BRAVO:
	slt	$t1, $s4, $s5
	bne	$t1, 1, PRINT_ALPHA_BRAVO_DOWN	
	
	la	$a0, directionMsgUp
	syscall
	
	j DIRECTION_EQUAL_BRAVO_GAMMA	# Jump to the next.
	
	
PRINT_ALPHA_BRAVO_DOWN:
	la	$a0, directionMsgDown
	syscall	
	
DIRECTION_EQUAL_BRAVO_GAMMA:
	la	$a0, msgBravo
	syscall
	la	$a0, directionMsgMiddle
	syscall
	la	$a0, msgGamma
	syscall
	la	$a0, msgColonWithSpace
	syscall

	bne	$s5, $s6, DIRECTION_LT_BRAVO_GAMMA
	la	$a0, directionMsgEqual
	syscall
	
	j DIRECTION_EQUAL_GAMMA_DELTA

DIRECTION_LT_BRAVO_GAMMA:
	slt	$t1, $s5, $s6
	bne	$t1, 1, PRINT_BRAVO_GAMMA_DOWN	
	
	la	$a0, directionMsgUp
	syscall
	
	j DIRECTION_EQUAL_GAMMA_DELTA	# Jump to the next.
	
	
PRINT_BRAVO_GAMMA_DOWN:
	la	$a0, directionMsgDown
	syscall	
	 	 
DIRECTION_EQUAL_GAMMA_DELTA:	 
	la	$a0, msgGamma
	syscall
	la	$a0, directionMsgMiddle
	syscall
	la	$a0, msgDelta
	syscall
	la	$a0, msgColonWithSpace
	syscall

	bne	$s6, $s7, DIRECTION_LT_GAMMA_DELTA
	la	$a0, directionMsgEqual
	syscall
	addi $v0, $zero, 11
	la	$a0, '\n'
	syscall
	
	j END

DIRECTION_LT_GAMMA_DELTA:
	slt	$t1, $s6, $s7
	bne	$t1, 1, PRINT_GAMMA_DELTA_DOWN	
	
	la	$a0, directionMsgUp
	syscall
	addi $v0, $zero, 11
	la	$a0, '\n'
	syscall
	
	j END
	
	
PRINT_GAMMA_DELTA_DOWN:
	la	$a0, directionMsgDown
	syscall	
	addi $v0, $zero, 11
	la	$a0, '\n'
	syscall

# These always at the end.
END:
.text
	addi	$v0, $zero, 10
	syscall
