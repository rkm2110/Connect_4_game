# To see the grid connect to bitmap display using width = 8 and height = 8
# display with and display height in pixels should be set to 512 x 512
# and base address for display should be set to heap.

.data
ColorTable:	
 .word 0x0000FF 
 .word 0xFF0000 
 .word 0xE5C420 
 .word 0xFFFFFF 

CircleTable: 
	.word 2, 4, 1, 6, 0, 8, 0, 8, 0, 8, 0, 8, 1, 6, 2, 4

boardArray: .byte 0:42
prompt0: .asciiz "Welcome to Connect 4!\nPlayer 1 has first turn.\nEnter 1-7 to place the puck.\nAfter that its Player 2's turn.\n"
prompt1: .asciiz "\nPlayer 1's turn: "
prompt2: .asciiz "\nPlayer 2's turn: "
prompt3: .asciiz "Player 1 Wins!\n"
prompt4: .asciiz "Player 2 Wins!\n"
prompt5: .asciiz "Please enter a number between 1 and 7 (inclusive)\n"
prompt6: .asciiz "The column you have chosen is full. Select a different column\n"
prompt7: .asciiz "It's a Tie!\n"
prompt8: .asciiz "For game vs computer press zero for game vs human press one\n"
prompt9: .asciiz "Computer is Player 2!!"

.text

jal DrawGameBoard

la $a0, prompt8
li $v0, 4
syscall
li $v0,5
syscall

move $s6, $v0

la $a0, prompt0	
li $v0, 4
syscall

bnez $s6, main
la $a0, prompt9
li $v0,4
syscall

main:

playerOne:
la $a0, prompt1
li $v0, 4
syscall
li $v0, 5
syscall

li $a0, 1
jal StoreInput

li $a0, 1
jal DrawPlayerChip

jal WinCheck

playerTwo:

beqz $s6, comp

human:la $a0, prompt2
li $v0, 4
syscall
li $v0, 5
syscall
j ahuman

comp:add $s7,$s7,1
bne $s7,8,areset
li $s7, 0
areset: la $v0,($s7)

ahuman:

li $a0, 2
jal StoreInput

li $a0, 2
jal DrawPlayerChip

jal WinCheck

j main	



DrawPlayerChip:
	
	addiu $sp, $sp, -12
	sw $ra, ($sp)
	sw $a0, 4($sp)
	sw $v0, 8($sp)
	
	move $a2, $a0
	
	li $t0, 7
	div $v0, $t0
	mflo $t0	
	mfhi $t1

	li $t2, 50
	mul $t0, $t0, 9
	mflo $t0
	sub $t0, $t2, $t0 
	
	mul $t1, $t1, 9
	addi $t1, $t1, 1
	
	move $a0, $t1
	move $a1, $t0
	
	jal DrawCircle
	
	lw $v0, 8($sp)
	lw $a0, 4($sp)
	lw $ra, ($sp)
	addiu $sp, $sp, 4
	jr $ra

DrawGameBoard:
	addiu $sp, $sp, -4
	sw $ra, ($sp)
	
	li $a0, 0
	li $a1, 0
	li $a2, 3
	li $a3, 64
	jal DrawBox
	
	li $a0, 0
	li $a1, 0
	li $a2, 0
	li $a3, 64
	jal DrawHorz
	li $a1, 1
	jal DrawHorz
	li $a1, 2	
	jal DrawHorz
	li $a1, 3	
	jal DrawHorz
	li $a1, 4	
	jal DrawHorz
	
	li $a0, 0
	li $a1, 58
	li $a2, 0
	li $a3, 64
	jal DrawHorz
	li $a1, 59
	jal DrawHorz
	li $a1, 60	
	jal DrawHorz
	li $a1, 61	
	jal DrawHorz
	li $a1, 62	
	jal DrawHorz
	li $a1, 63	
	jal DrawHorz
 
	li $a0, 0
	li $a1, 0
	li $a2, 0
	li $a3, 64
	jal DrawVert	
	li $a0, 9
	jal DrawVert
	li $a0, 18
	jal DrawVert
	li $a0, 27
	jal DrawVert
	li $a0, 36
	jal DrawVert
	li $a0, 45
	jal DrawVert
	li $a0, 54
	jal DrawVert
	li $a0, 63
	jal DrawVert

	li $a0, 0
	li $a1, 13
	li $a2, 0
	li $a3, 64
	jal DrawHorz
	li $a1, 22
	jal DrawHorz
	li $a1, 31	
	jal DrawHorz
	li $a1, 40	
	jal DrawHorz
	li $a1, 49	
	jal DrawHorz

	lw $ra, ($sp)
	addiu $sp, $sp, 4
	jr $ra

DrawCircle:
	addiu $sp, $sp, -28
	sw $ra, 20($sp)
	sw $s0, 16($sp)
	sw $a0, 12($sp)
	sw $a2, 8($sp)
	li $s2, 0
	
CircleLoop:
	la $t1, CircleTable
	addi $t2, $s2, 0
	mul $t2, $t2, 8	
	add $t2, $t1, $t2
	lw $t3, ($t2)
	add $a0, $a0, $t3
	
	addi $t2, $t2, 4
	lw $a3, ($t2)
	sw $a1, 4($sp)
	sw $a3, 0($sp)
	sw $s2, 24($sp)
	jal DrawHorz
	
	lw $a3, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a0, 12($sp)
	lw $s2, 24($sp)
	addi $a1, $a1, 1
	addi $s2, $s2, 1
	bne $s2, 8, CircleLoop
	
	lw $ra, 20($sp)
	lw $s0, 16($sp)
	addiu $sp, $sp, 28
	jr $ra
	
DrawBox:
	addiu $sp, $sp, -24
	sw $ra, 20($sp)
	sw $s0, 16($sp)
	sw $a0, 12($sp)
	sw $a2, 8($sp)
	move $s0, $a3
	
BoxLoop:
	sw $a1, 4($sp)
	sw $a3, 0($sp)
	jal DrawHorz
	
	lw $a3, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a0, 12($sp)
	addi $a1, $a1, 1
	addi $s0, $s0, -1
	bne $zero, $s0, BoxLoop
	
	lw $ra, 20($sp)
	lw $s0, 16($sp)
	addiu $sp, $sp, 24
	jr $ra
	
DrawHorz:
	addiu $sp, $sp, -28
	sw $ra, 16($sp)
	sw $a1, 12($sp)
	sw $a2, 8($sp)
	sw $a0, 20($sp)
	sw $a3, 24($sp)
	
HorzLoop:
	sw $a0, 4($sp)
	sw $a3, 0($sp)
	jal DrawDot
	lw $a0, 4($sp)
	lw $a1, 12($sp)
	lw $a2, 8($sp)
	lw $a3, 0($sp)	
	addi $a3, $a3, -1
	addi $a0, $a0, 1
	bnez $a3, HorzLoop	
	lw $ra, 16($sp)
	lw $a0, 20($sp)
	lw $a3, 24($sp)
	addiu $sp, $sp, 28
	jr $ra

DrawVert:
	addiu $sp, $sp, -28
	sw $ra, 16($sp)
	sw $a1, 12($sp)
	sw $a2, 8($sp)
	sw $a0, 20($sp)
	sw $a3, 24($sp)
	
VertLoop:
	sw $a1, 4($sp)
	sw $a3, 0($sp)
	jal DrawDot
	lw $a1, 4($sp)
	lw $a0, 20($sp)
	lw $a2, 8($sp)
	lw $a3, 0($sp)	
	addi $a3, $a3, -1
	addi $a1, $a1, 1
	bnez $a3, VertLoop	
	lw $ra, 16($sp)
	lw $a1, 12($sp)
	lw $a3, 24($sp)
	addiu $sp, $sp, 28
	jr $ra

DrawDot:
	addiu $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a2, 0($sp)
	jal CalcAddress
	lw $a2, 0($sp)
	sw $v0, 0($sp)
	jal GetColor
	lw $v0, 0($sp)
	sw $v1, ($v0)
	lw $ra, 4($sp)
	addiu $sp, $sp, 8
	jr $ra

CalcAddress:
	sll $t0, $a0, 2
	sll $t1, $a1, 8
	add $t2, $t0, $t1
	addi $v0, $t2, 0x10040000
	jr $ra

GetColor:
	la $t0, ColorTable
	sll $a2, $a2, 2
	add $a2, $a2, $t0
	lw $v1, ($a2)
	jr $ra

StoreInput:
	addiu $v0, $v0, -8
	bltu $v0, -7, OOBError
	bgtu $v0, -1, OOBError
	
	nextCheck:
	addiu $v0, $v0, 7
	bgtu $v0, 41, ColumnFull
	lb $t1, boardArray($v0)
	bnez $t1, nextCheck
	
	sb $a0, boardArray($v0)
	
	jr $ra

	OOBError:
	move $t0, $a0
	la $a0, prompt5
	li $v0, 4
	syscall
	move $a0, $t0
	j returnToPlayer
	
	ColumnFull:
	move $t0, $a0
	la $a0, prompt6
	li $v0, 4
	syscall
	move $a0, $t0
	
	returnToPlayer:
	beq $a0, 1, playerOne
	beq $a0, 2, playerTwo
	

WinCheck:    	

     	addiu $sp, $sp, -4
     	sw $ra, ($sp)
     	
        li $t8, 7

     	li $t9, 1
	move $t2, $v0
	move $t4, $v0
        checkLeft:
     	la $t0, boardArray($t2)
     	
     	div $t2, $t8
     	mfhi $t3
     	beqz $t3, checkRight

     	lb $t1, -1($t0)
     	bne $t1, $a0, checkRight
     	addiu $t9, $t9, 1
     	addiu $t2, $t2, -1
	bgt $t9, 3, PlayerWon
     	j checkLeft

	checkRight:
	la $t0, boardArray($t4)

	div $t4, $t8
	mfhi $t3
	beq $t3, 6, endHorz

	lb $t1, 1($t0)
	bne $t1, $a0, endHorz
	addiu $t9, $t9, 1
	addiu $t4, $t4, 1
	bgt $t9, 3, PlayerWon
	j checkRight
	
	endHorz:

     	li $t9, 1
	move $t2, $v0
	move $t4, $v0
        checkUp:
     	la $t0, boardArray($t2)
     	
     	bgtu $t2, 34, checkDown
     	
     	lb $t1, 7($t0)
     	bne $t1, $a0, checkDown
     	addiu $t9, $t9, 1
     	addiu $t2, $t2, 7
	bgt $t9, 3, PlayerWon
     	j checkUp
     	
	checkDown:
	la $t0, boardArray($t4)
	
	bltu $t4, 7, endVert
	
	lb $t1, -7($t0)
	bne $t1, $a0, endVert
	addiu $t9, $t9, 1
	addiu $t4, $t4, -7
	bgt $t9, 3, PlayerWon
	j checkDown
	
	endVert:  

     	li $t9, 1
	move $t2, $v0
	move $t4, $v0
        checkUR:
     	la $t0, boardArray($t2)

     	bgtu $t2, 34, checkDL
	div $t2, $t8
	mfhi $t3
	beq $t3, 6, checkDL
     	
     	lb $t1, 8($t0)
     	bne $t1, $a0, checkDL
     	addiu $t9, $t9, 1
     	addiu $t2, $t2, 8
	bgt $t9, 3, PlayerWon
     	j checkUR
     	
	checkDL:
	la $t0, boardArray($t4)
	
	bltu $t4, 7, endFSDiag
	div $t4, $t8
	mfhi $t3
	beq $t3, 0, endFSDiag
	
	lb $t1, -8($t0)
	bne $t1, $a0, endFSDiag
	addiu $t9, $t9, 1
	addiu $t4, $t4, -8
	bgt $t9, 3, PlayerWon
	j checkDL
	
	endFSDiag:  

     	li $t9, 1
	move $t2, $v0
	move $t4, $v0
        checkUL:
     	la $t0, boardArray($t2)
     	
    	bgtu $t2, 34, checkDR
	div $t2, $t8
	mfhi $t3
	beq $t3, 0, checkDR

     	lb $t1, 6($t0)
     	bne $t1, $a0, checkDR
     	addiu $t9, $t9, 1
     	addiu $t2, $t2, 6
	bgt $t9, 3, PlayerWon
     	j checkUL
     	
	checkDR:
	la $t0, boardArray($t4)

	bltu $t4, 7, endBSDiag
	div $t4, $t8
	mfhi $t3
	beq $t3, 6, endBSDiag
	
	lb $t1, -6($t0)
	bne $t1, $a0, endBSDiag
	addiu $t9, $t9, 1
	addiu $t4, $t4, -6
	bgt $t9, 3, PlayerWon
	j checkDR
	
	endBSDiag:     	

     	li $t9, 35
     	la $t0, boardArray($t9)
     	
     	li $t2, 0
    	checkTop:
    	lb $t1, ($t0)
    	beqz $t1, endTie
    	addi $t0, $t0, 1
    	add $t2, $t2, 1	
    	beq $t2, 7, GameTie
    	j checkTop	
    
    	endTie:
	
	lw $ra, ($sp)
	addiu $sp, $sp, 4	
	jr $ra

GameTie:
	la $a0, prompt7
	li $v0, 4
	syscall
	li $v0, 10
	syscall

PlayerWon:
	beq $a0, 1 player1Win
	
	la $a0, prompt4
	li $v0, 4
	syscall
	li $v0, 10
	syscall
	
	player1Win:
	la $a0, prompt3
	li $v0, 4
	syscall
	li $v0, 10
	syscall









