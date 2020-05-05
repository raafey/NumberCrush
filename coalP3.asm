;-----------------------------------------
; Muhammad Raafey Tariq - i16-0259
; Abubakar Ijaz	- i16-0123
; Section - E
; COAL Project Phase: 3
;-----------------------------------------

.model small
.stack 200h
.data
	rand db 0						; used to store the random number generated
	prime db 1						; used in generating random numbers
	i dw 0							; used while indexing through loops
	j dw 0							; used while indexing through loops
	x dw 0							; used in determining x axis of our block
	y dw 79					    	; used in determining y axis of our block
	charX db 0						; x axis for drawing character
	charY db 0						; y axis for drawing character
	char db 0						; character that we are drawing
	idx db 0						; variable used in indexing
	msg1 db "+-------- Number Crush-------+", 10, "$"	; string
	msg2 db "| Press 1) level 1           |", 10, "$"	; string
	msg3 db "| Press 2) level 2           |", 10, "$"	; string
	msg7 db "| Press 3) level 3           |", 10, "$"	; string
	msg6 db "| Press 4) level 1, 2 & 3    |", 10, "$"	; string
	msg4 db "+----------------------------+", 10, "$"	; string
	msg5 db "Enter option please : $"; string
	msgScore db "Score : $"			; string
	msgMoves db "Moves : $"			; string
	msgName db "Name : $"			; string
	msgInput db "Please Enter your name : $"	; string
	msgOver db "G A M E  O V E R$"	; string
	msgLevel db "Level : "			; string
	_name db 15 dup(?)				; string to input name of user
	indx db 0						; used in indexing
	row db 0						; used in indexing
	col db 0						; used in indexing
	idx2 dw 0						; used in indexing
	score dw 0						; used to hold the current score
	color db 9						; used while selecting color of our numbers
	mouseX dw 0						; stores the value of x axis in pixels of the mouse click
	mouseY dw 0						; stores the value of y axis in pixels of the mouse click
	count dw 0						; used in drop proc 
	button dw 0						; stores the current mouse button pressed
	gridX dw 0						; stores the index of the x-axis 
	gridY dw 0						; stores the index of the y-axis
	oldGridX dw 0					; stores the index of the x-axis of the previous click
	oldGridY dw 0					; stores the index of the x-axis of the previous click
	number dw 0						; variable used in printing multi digit
	temp dw 0						; temped variable used in swapping
	nclicks db 0					; stores number of times right mouse button is clicked
	prevButton dw 0					; holds previous mouse click
	nMoves db 0						; current number of moves a user makes
	totalMoves db 15				; total moves a user is allowed
	flag db 0						; variable used in restricting swap
	flag2 db 0						; variable used while incrementing combos
	flag3 db 0						; variable used while incrementing combos
	flag4 db ?						; variable used while checking for blockers in the grid
	nameX db 0						; variable used for x axis position of name
	nameY db 0						; variable used for y axis position of name
	nX dw 0							; temp var used in restrict proc
	nY dw 0						    ; temp var used in restrict proc
	oX dw 0							; temp var used in restrict proc
	oY dw 0							; temp var used in restrict proc
	allow db 0						; variable used in mouse click for level 2
	swapNum db 0 					; variable used to store the number which had a combo of 4 or more
	pass db 0						; variable used in full game play of level 1 then level 2
	level db 0						; current level of the game
	rowIdx db 0						; used in addBlocker macro
	colIdx db 0						; used in multiply macro
	grid db 100 dup(?)				; our grid of 10x10
	t db 10
	t2 db 10
.code
	;----------------------------------------------
	;	macro that places a blocker at given indexes
	;----------------------------------------------
	addBlocker macro rowIdx, colIdx
		mov ax, 0
		mov al, rowIdx
		mov bl, 10
		mul bl
		add al, colIdx
		mov ah, 0
		mov si, ax					; calculating location to place blocker
		mov grid[si], 'X'			; placing blocker in that location
	endM
	
	main proc
		mov ax, @data
		mov ds, ax
		
		call mainMenu				; main game function
		
		mov ah, 0
		int 16h
		
		mov ah, 4ch
		int 21h
	main endP
	
	;----------------------------------------------
	;	procedure for main menu
	;----------------------------------------------
	mainMenu proc
		call inputName
		call fillGrid				; filling grid with random values
	loop1:
		mov dx, offset msg1					; displaying message
		mov ah, 09
		int 21h
		mov dx, offset msg2					; displaying message
		mov ah, 09
		int 21h
		mov dx, offset msg3					; displaying message
		mov ah, 09
		int 21h
		mov dx, offset msg7					; displaying message
		mov ah, 09
		int 21h
		mov dx, offset msg6					; displaying message
		mov ah, 09
		int 21h
		mov dx, offset msg4					; displaying message
		mov ah, 09
		int 21h
		mov dx, offset msg5					; displaying message
		mov ah, 09
		int 21h
		
		mov ah, 01							; taking input of option
		int 21h
		sub al, 48
		
		cmp al, 1							; if option is 1
		je l1
		cmp al, 2							; if option 2
		je l2
		cmp al, 3
		je l3
		cmp al, 4							; if option 4
		je l4
		
		mov dl, 10							; next line
		mov ah, 02
		int 21h
		
		jmp loop1							; prompt user for input again if input is incorrect
		l1:
			mov level, 1					; set level as 1
			jmp playLevel
		l2:
			mov level, 2					; set level as 2
			call fillGrid
			jmp playLevel
		l3:
			mov level, 3					; set level as 3
			call placeObstacles
		playLevel:
			call Game
			jmp return
		l4:
			call LevelOneTwoThree				; level one then two
		return:
			call GameOver					; game over screen
			ret
	mainMenu endP
	
	;----------------------------------------------
	;	procedure that places obstacles in the grid
	;----------------------------------------------
	placeObstacles proc
		addBlocker 2, 0
		addBlocker 0, 2
		addBlocker 0, 4
		addBlocker 2, 4
		addBlocker 1, 7
		addBlocker 3, 6	
		addBlocker 4, 7
		addBlocker 5, 9		
		addBlocker 5, 3
		addBlocker 6, 6	
		addBlocker 7, 2
		addBlocker 7, 4
		addBlocker 8, 5			
		ret
	placeObstacles endP
	
	;----------------------------------------------
	;	procedure for level 1, 2 & 3 of the game
	;----------------------------------------------
	LevelOneTwoThree proc
		mov level, 1
		l1:
			call Game					; calling our game proc
		
			cmp pass, 1					; if pass is two jump to label: levelTwo
			je levelTwo
										; else level is 3
			mov score, 0				; reset score
			mov level, 3				; set level as 3
			mov prime, 1				; reset random seed to 1
			call fillGrid				; re fill grid
			call placeObstacles			; place obstacles
			mov nMoves, 0				; reset moves
			call Game					; call Game function
			jmp exit
			
			levelTwo:
				mov score, 0				; resetting score
				mov level, 2				; set level as 2
				call fillGrid
				mov nMoves, 0
				jmp l1
			exit:
		ret
	LevelOneTwoThree endP
	
	;----------------------------------------------
	;	main game procedure
	;----------------------------------------------
	Game proc
		mov nMoves, 0
		call newWindow					; creating a new window
		call DrawBoard					; drawing our game board
		l2:
			mov indx, 0
			l4:
				call checkCombo					; checking for combos
				call Drop						; function to drop new numbers from in case of crush
				call replaceZeros
				inc indx
				cmp indx, 3
				jb l4
			
			call newWindow					; creating a new window
			call DrawBoard					; drawing our game board
			
			call MouseClick					; function to integrate mouse and swapping
			
			call checkCombo					; checking for combos
			call Drop						; function to drop new numbers from in case of crush
			call replaceZeros
			
			cmp button, 1					; checks for incrementing nMoves only if the move is correct
			jne skip
			cmp flag2, 1
			je increment
			cmp flag3, 1
			je increment
			jmp skip
			increment:
				inc nMoves
			skip:
			mov al, totalMoves
			cmp nMoves, al					; keeps executing until user runs out of moves
			jb l2
		inc pass
		ret
	Game endP
	
	;----------------------------------------------
	;	procedure to input name of user
	;----------------------------------------------
	InputName proc 
		mov dx, offset msgInput			; displaying string
		mov ah, 09
		int 21h
		
		mov dx, offset _name			; taking input of name
		mov ah, 3Fh
		int 21h
		ret
	InputName endP

	;----------------------------------------------
	;	procedure to generate Random numbers
	;----------------------------------------------
	generateRandom proc uses ax bx	; uses linear congruential generator formula to generate random numbers
		mov ax, 0
		mov al, prime				; multiply prime num with 13 and then take its mod by 128
		mov bl, 13
		mul bl
		mov bl, 128
		div bl
		mov prime, ah				; replace prime with result of calculation
		mov al, ah
		mov ah, 0
		mov bl, 5					; taking mod by 5 to get random number b/w 0-4
		div bl
		cmp level, 2
		je levelTwo
		increment:
			inc ah	
			jmp skip
		levelTwo:
			cmp ah, 4
			je skip
			jmp increment
		skip:
		mov rand, ah				; copy to rand
		ret
	generateRandom endP
	
	;----------------------------------------------------------
	;	procedure that fills up the grid with random integers
	;----------------------------------------------------------	
	fillGrid proc uses cx si ax		
		mov cx, 100
		mov si, offset grid
		l1:
			mov i, cx
			call generateRandom		; generate a random number
			mov cx, i
			mov al, rand
			mov [si], al			; copy it to the current index
			inc si
			loop l1
		ret
	fillGrid endP
	
	;----------------------------------------------------------
	;	procedure that checks combos and replaces with zeros
	;----------------------------------------------------------		
	checkCombo proc
		call vertical			; call to proc that checks vertical
		call horizontal			; call to proc that checks horizontal
		ret
	checkCombo endP
	
	;----------------------------------------------------------
	;	procedure that checks combos of 3, 4, 5 vertically
	;----------------------------------------------------------	
	vertical proc
		mov si,offset grid
		mov flag2, 0
		mov i, 0
		loopi:
			mov j, 0
			loopj:
				mov ah, [si]
				mov bh, [si]
				cmp ah, [si+10]
				jne labelout
				cmp ah, [si+10+10]
				jne labelout
				mov ah, 0
				mov [si], ah				; combos of 3 set as 0
				mov [si+10], ah
				mov [si+10+10], ah
				
				mov flag2, 1
				add score, 3
				
				mov ch,'X'
				
				cmp [si+1],ch				;compares to see if there is obstacle to the right of first index
				jne labelPopX1
				mov [si+1],ah
				jmp labelPopX
				
				labelPopX1:
				cmp [si-10],ch				;compares to see if there is obstacle above the first index
				jne labelPopX2
				mov [si-10],ah
				jmp labelPopX
				
				labelPopX2:
				cmp [si-1],ch				;compares to see if there is obstacle to the left of first index
				jne labelPopX3
				mov [si-1],ah
				jmp labelPopX
				
				labelPopX3:
				cmp [si+10+1],ch			;compares to see if there is obstacle to the right of second index
				jne labelPopX4
				mov [si+10+1],ah
				jmp labelPopX
				
				labelPopX4:
				cmp [si+10-1],ch			;compares to see if there is obstacle to the left of second index
				jne labelPopX5
				mov [si+10-1],ah
				jmp labelPopX
				
				labelPopX5:
				cmp [si+10+10+1],ch			;compares to see if there is obstacle to the right of third index
				jne labelPopX6
				mov [si+10+10+1],ah
				jmp labelPopX
				
				labelPopX6:
				cmp [si+10+10-1],ch			;compares to see if there is obstacle to the left of third index
				jne labelPopX7
				mov [si+10+10-1],ah
				jmp labelPopX
				
				labelPopX7:
				cmp [si+10+10+10],ch			; compares to see if there is obstacle below the third index
				jne labelPopX
				mov [si+10+10+10],ah
				
				labelPopX:
				
				cmp [si+10+10+10], bh		; if 4 set as 0
				jne labelout
				mov [si+10+10+10], ah
				
				cmp [si+10+10+10+10],ch 		;compares to see if there is obstacle below the fourth index
				jne labelPopX8
				mov [si+10+10+10+10],ah
				jmp labelPopXend
				
				labelPopX8:
				cmp [si+10+10+10+1],ch			;compares to see if there is obstacle to the right of the fourth index
				jne labelPopX9
				mov [si+10+10+10+1],ah
				jmp labelPopXend
				
				labelPopX9:
				cmp [si+10+10+10-1],ch			;compares to see if there is obstacle to the left of the fourth index
				jne labelPopXend
				mov [si+10+10+10-1],ah
				
				labelPopXend:
				mov bl, 66
				mov [si], bl
				
				cmp [si+10+10+10+10], bh	; if 5 set as 0
				jne labelout
				mov [si+10+10+10+10], ah
				
				cmp [si+10+10+10+10+10],ch 		;compares to see if there is obstacle below the fifth index
				jne labelPopX10
				mov [si+10+10+10+10+10],ah
				jmp labelPopXend2
				
				labelPopX10:
				cmp [si+10+10+10+10+1],ch			;compares to see if there is obstacle to the right of the fifth index
				jne labelPopX11
				mov [si+10+10+10+10+1],ah
				jmp labelPopXend2
				
				labelPopX11:
				cmp [si+10+10+10+10-1],ch			;compares to see if there is obstacle to the left of the fifth index
				jne labelPopXend2
				mov [si+10+10+10+10-1],ah
				
				labelPopXend2:
				cmp [si+10+10+10+10+10], bh	; if 6 set as 0
				jne labelout
				mov [si+10+10+10+10+10], ah
				
				cmp [si+10+10+10+10+10+10],ch 		;compares to see if there is obstacle below the sixth index
				jne labelPopX12
				mov [si+10+10+10+10+10+10],ah
				jmp labelout
				
				labelPopX12:
				cmp [si+10+10+10+10+10+1],ch			;compares to see if there is obstacle to the right of the sixth index
				jne labelPopX13
				mov [si+10+10+10+10+10+1],ah
				jmp labelout
				
				labelPopX13:
				cmp [si+10+10+10+10+10-1],ch			;compares to see if there is obstacle to the left of the sixth index
				jne labelout
				mov [si+10+10+10+10+10-1],ah
				
			labelout:
				inc si
				inc j
				cmp j, 10
				jne loopj
			
			inc i
			cmp i,8
			jne loopi
		ret
	vertical endp
	
	;----------------------------------------------------------
	;	procedure that checks combos of 3, 4, 5 horizontally
	;----------------------------------------------------------	
	horizontal proc
		mov si, offset grid
		mov flag3, 0
		mov i,0
		loopi:
			mov j,0
			loopj:
				mov ah, [si]
				mov bh, [si]
				cmp ah, [si+1]
				jne labelout
				cmp ah, [si+2]
				jne labelout
				
				mov ah, 0					; if horizontal combo of 3 found
				mov [si], ah
				mov [si+1], ah
				mov [si+2], ah				; set as zero
				
				add score, 3
				mov flag3, 1
				
				mov ch,'X'
				
				cmp [si-10],ch				;compares to see if there is obstacle above the first index
				jne labelPopY1
				mov [si-10],ah
				jmp labelPopY
				
				labelPopY1:
				cmp [si-1],ch				;compares to see if there is obstacle to the right of the first index
				jne labelPopY2
				mov [si-1],ah
				jmp labelPopY
				
				labelPopY2:
				cmp [si+10],ch				;compares to see if there is obstacle below the first index
				jne labelPopY3
				mov [si+10],ah
				jmp labelPopY
				
				labelPopY3:
				cmp [si+1-10],ch			;compares to see if there is obstacle above second index
				jne labelPopY4
				mov [si+1-10],ah
				jmp labelPopY
				
				labelPopY4:
				cmp [si+10+1],ch			;compares to see if there is obstacle below the second index
				jne labelPopY5
				mov [si+10+1],ah
				jmp labelPopY
				
				labelPopY5:
				cmp [si+1+1-10],ch		   ;compares to see if there is obstacle above the third index
				jne labelPopY6
				mov [si+1+1-10],ah
				jmp labelPopY
				
				labelPopY6:
				cmp [si+1+1+10],ch			;compares to see if there is obstacle below the third index
				jne labelPopY7
				mov [si+1+1+10],ah
				jmp labelPopY
				
				labelPopY7:
				cmp [si+1+1+1],ch			; compares to see if there is obstacle to the right of the third index
				jne labelPopY
				mov [si+1+1+1],ah
				
				labelPopY:
				
				cmp [si+3], bh				; further check for combo of 4
				jne labelout
				mov [si+3], ah
				
				cmp [si+1+1+1+1],ch 		;compares to see if there is obstacle after fourth index
				jne labelPopY8
				mov [si+1+1+1+1],ah
				jmp labelPopYend
				
				labelPopY8:
				cmp [si+1+1+1+10],ch			;compares to see if there is obstacle below the fourth index
				jne labelPopY9
				mov [si+1+1+1+10],ah
				jmp labelPopYend
				
				labelPopY9:
				cmp [si+1+1+1-10],ch			;compares to see if there is obstacle above the fourth index
				jne labelPopYend
				mov [si+1+1+1-10],ah
				
				labelPopYend:

				mov bl, 66					; placing bomb 'B'

				mov [si],bl
				
				cmp [si+4], bh				; for combo of 5
				jne labelout			
				mov [si+4], ah
				
				cmp [si+1+1+1+1+1],ch 		;compares to see if there is obstacle after the fifth index
				jne labelPopY10
				mov [si+1+1+1+1+1],ah
				jmp labelPopYend2
				
				labelPopY10:
				cmp [si+1+1+1+1+10],ch			;compares to see if there is obstacle below the fifth index
				jne labelPopY11
				mov [si+1+1+1+1+10],ah
				jmp labelPopYend2
				
				labelPopY11:
				cmp [si+1+1+1+1-10],ch			;compares to see if there is obstacle above the fifth index
				jne labelPopYend2
				mov [si+1+1+1+1-10],ah
				
				labelPopYend2:
				
				cmp [si+5], bh				; for combo of 6
				jne labelout			
				mov [si+5], ah
				
				cmp [si+1+1+1+1+1+1],ch 		;compares to see if there is obstacle after the sixth index
				jne labelPopY12
				mov [si+1+1+1+1+1+1],ah
				jmp labelout
				
				labelPopY12:
				cmp [si+1+1+1+1+1+10],ch			;compares to see if there is obstacle below the sixth index
				jne labelPopY13
				mov [si+1+1+1+1+1+10],ah
				jmp labelout
				
				labelPopY13:
				cmp [si+1+1+1+1+1-10],ch			;compares to see if there is obstacle above the sixth index
				jne labelout
				mov [si+1+1+1+1+1-10],ah
				
			labelout:
				inc si
				inc j
				cmp j, 10
				jne loopj
				
			inc i
			cmp i, 10
			jne loopi
		ret
	horizontal endp
	
	;--------------------------------------------------------------------------------
	;	procedure that traverses the array to search for the number swapped with bomb
	;--------------------------------------------------------------------------------
	Detonate proc uses si
		mov cx, 100
		mov al, swapNum
		mov ah, 0
		mov si, offset grid
		l1:
			cmp [si], al				; if num found
			jne skip
			mov [si], ah				; set element to 0
			add score, 1
			skip:
			inc si
			loop l1
		ret
	Detonate endp

	;----------------------------------------------------------
	;	procedure that drops characters after crushing
	;----------------------------------------------------------		
	Drop proc
		mov j, 0						; col idx
		loopj:
			mov i, 0					; row idx
			mov count, 0				; set count as 0
			loopi:
				mov ax, 0
				mov ax, i
				mov bh, 10
				mul bh
				add ax, j
				mov si, ax				; caculate address of the desired index
				
				cmp grid[si], 0			; if element is 0 then skip
				je skip
				
				cmp grid[si], 'X'		; if blocker is encountered skip it
				je skip
				
				inc count				; else increment count 
				mov al, grid[si]
				mov ah, 0
				push ax					; and push the element in stack
				
				skip:
				inc i
				cmp i, 10
				jb loopi				; loop again
			
			call fillColZero			; procedure that fills current column with zeros
			mov cx, count				; move count of elements pushed to cx
			mov i, 9
			loopi2:						; this loop pops all elements pushed starting from bottom of the current col
				mov ax, i
				mov bh, 10
				mul bh
				add ax, j
				mov bx, ax				; save calculated address to bx
				mov si, bx
				cmp grid[si], 'X'		; if blocker is encountered skip it
				je blocker
				
				mov ax, 0
				pop ax					; pop element that was pushed
				mov ah, 0
				mov grid[si], al		; copy popped element
				jmp skip2
				blocker:
					inc cx				; incrementing value of cx as blocker is encountered
				skip2:
				dec i
				loop loopi2
			
			inc j
			cmp j, 10
			jb loopj
		ret
	Drop endP

	;----------------------------------------------------------
	;	procedure that fills column with zero
	;----------------------------------------------------------			
	fillColZero proc
		mov i, 0
		mov cx, 10
		l1:
			mov ax, i
			mov bh, 10
			mul bh
			add ax, j
			mov si, ax					; calculate address
			cmp grid[si], 'X'			; if blocker encountered skip it
			je skip
			mov grid[si], 0				; place zero at that location of grid
			skip:
			inc i
			loop l1
		ret
	fillColZero endP

	;--------------------------------------------------------------------------------
	;	procedure used to generate random numbers in grid where cavities are created
	;--------------------------------------------------------------------------------			
	replaceZeros proc
		mov cx, 100
		mov si, 0
		li:
			cmp grid[si], 0				; if not zero then skip
			jne skip
			call generateRandom			; else generate a random number
			mov al, rand				
			mov grid[si], al			; copy to the index where there is a zero
			skip:
			inc si
			loop li
		ret
	replaceZeros endP

	;----------------------------------------------------------
	;	procedure that print grid in console
	;----------------------------------------------------------			
	printGrid proc
		mov si, offset grid
		mov i, 0
		loopi:
			mov j,0
			loopj:
				mov dl, [si]			; print element at current index
				cmp dl, 'X'
				je skip
				add dl, 48
				skip:
				mov ah, 02
				int 21h
				
				mov dl, ' '				; print space
				mov ah, 02
				int 21h
				
				inc si
				inc j
				cmp j, 10
				jne loopj

			mov dl, 10					; next line
			mov ah, 02
			int 21h
			
			inc i
			cmp i, 10
			jne loopi
		ret
	printGrid endP

	;----------------------------------------------------------
	;	procedure to create a window of 640x480
	;----------------------------------------------------------			
	newWindow proc
		mov ah, 0
		mov al, 12h
		int 10h
		ret
	newWindow endP

	;----------------------------------------------------------
	;	procedure to set the color of an element
	;----------------------------------------------------------			
	SetColor proc
		mov si, idx2					; contains index position
		mov al, grid[si]				; copy element to al
		cmp al, 1						; if 1 go to one
		je one
		cmp al, 2						; if 2 go to two
		je two
		cmp al, 3						; if 3 go to three
		je three
		cmp al, 4						; if 4 go to four
		je four
		cmp al, 'B'
		je bomb
		cmp al, 'X'
		je blocker
		
		mov color, 11					; else set color as 15
		jmp return
		one:
			mov color, 13				
			jmp return
		two:
			mov color, 14
			jmp return
		three:
			mov color, 9
			jmp return
		four:
			mov color, 10
			jmp return
		bomb:
			mov color, 6
			jmp return
		blocker:
			mov color, 12
		return:
			ret
	SetColor endP

	;-----------------------------------------------------------------
	;	procedure to draw a tile/box, takes x and y as starting point
	;-----------------------------------------------------------------			
	DrawBox proc
		mov i, 0
		loop1:							; print left vertical line 
			mov ah, 0ch
			mov al, 03
			mov cx, x
			mov dx, y
			add dx, i
			int 10h
			inc i
			cmp i, 40
			jne loop1
			
		mov i, 0
		loop2:							; print upper horizontal line 
			mov ah, 0ch
			mov al, 03
			mov cx, x
			mov dx, y
			add cx, i
			int 10h
			inc i
			cmp i, 64
			jne loop2
			
		mov i, 0
		loop3:							; print right vertical line 
			mov ah, 0ch
			mov al, 03
			mov cx, x
			add cx, 64
			mov dx, y
			add dx, i
			int 10h
			inc i
			cmp i, 40
			jne loop3
			
		mov i, 0
		loop4:							; print right vertical line 
			mov ah, 0ch
			mov al, 03
			mov cx, x
			mov dx, y
			add dx, 40
			add cx, i
			int 10h
			inc i
			cmp i, 64
			jne loop4
		call DrawChar					; call to function that draws a char in the middle of the box
		ret
	DrawBox endP

	;-----------------------------------------------------------------
	;	procedure to draw our entire board
	;-----------------------------------------------------------------	
	DrawBoard proc
		mov nameX, 0
		mov nameY, 0
		call displayScore				; calling proc that displays Score string
		call displayMoves				; calling proc that displays moves string
		call displayName				; calling proc that displays name of the user
		call displayLevel				; calling proc that displays current level
		mov si, 0
		cmp level, 2
		je levelTwo
		
		mov row, 0
		mov y, 80						; setting starting position of grid as 0, 80
		loop1:
			mov x, 0					
			mov col, 0					
			loop2:
				mov ax, 0
				mov al, row
				mov bl, 10
				mul bl
				add al, col				; calculating index position
				mov idx2, ax			; mov to idx2
				call SetColor			; choose color of element according to value of element
				call DrawBox			; call to proc that draws a box
				inc col
				add x, 64
				cmp x, 640
				jne loop2				; inner loop
			inc row		
			add y, 40
			cmp y, 480
			jne loop1					; outer loop
		
		jmp return
		
		levelTwo:
			mov row, 0
			mov y, 80			; setting starting position of grid as 0, 80
			loop3:
				cmp y, 240
				je _skip
				cmp y, 280
				je _skip
				mov x, 192					
				mov col, 3					
				loop4:
					mov ax, 0
					mov al, row
					mov bl, 10
					mul bl
					add al, col				; calculating index position
					mov idx2, ax			; mov to idx2
					call SetColor			; choose color of element according to value of element
					call DrawBox			; call to proc that draws a box
					inc col
					add x, 64
					cmp x, 448
					jne loop4				; inner loop
				_skip:
				inc row		
				add y, 40
				cmp y, 480
				jne loop3					; outer loop
				
			mov row, 3
			mov y, 200			; setting starting position of grid as 0, 200
			loop5:
				mov x, 0					
				mov col, 0					
				loop6:
					mov ax, 0
					mov al, row
					mov bl, 10
					mul bl
					add al, col				; calculating index position
					mov idx2, ax			; mov to idx2
					call SetColor			; choose color of element according to value of element
					call DrawBox			; call to proc that draws a box
					inc col
					add x, 64
					cmp x, 192
					jne loop6				; inner loop
				inc row		
				add y, 40
				cmp y, 360
				jne loop5					; outer loop
			
			mov row, 3
			mov y, 200			; setting starting position of grid as 448, 200
			loop7:
				mov x, 448					
				mov col, 7					
				loop8:
					mov ax, 0
					mov al, row
					mov bl, 10
					mul bl
					add al, col				; calculating index position
					mov idx2, ax			; mov to idx2
					call SetColor			; choose color of element according to value of element
					call DrawBox			; call to proc that draws a box
					inc col
					add x, 64
					cmp x, 640
					jne loop8				; inner loop
				inc row		
				add y, 40
				cmp y, 360
				jne loop7					; outer loop
		return:
			ret
	DrawBoard endP

	;-------------------------------------------------------------------------------------------------
	;	procedure to draw a tile/box, takes x and y as starting point and idx2 as location of element
	;-------------------------------------------------------------------------------------------------	
	DrawChar proc
		mov si, idx2
		mov ax, x
		mov bl, 8
		div bl
		mov charX, al					; copy x-axis position of the char to charX
		mov ax, y
		mov bl, 16
		div bl
		mov charY, al					; copy y-axis position of the char to charX
		
										; setting centre position of the char
		mov ah, 02h
		mov dl, charX					
		add dl, 3
		mov dh, charY
		add dh, 1
		int 10h
		
		mov ah, 09						; printing char
		mov al, grid[si]
		cmp al, 'B'
		je ignore
		cmp al, 'X'
		je ignore
		add al, 48
		ignore:
			mov bh, 0
			mov bl, color					; set color of char
			mov cx, 1
			int 10h
		ret
	DrawChar endP

	;-----------------------------------------------------------------
	;	procedure to print msgScore string 
	;-----------------------------------------------------------------		
	displayScore proc
		mov idx, 0
		mov si, 0
		loop1:						; keeps printing a character until end of string
			mov ah, 02
			mov dl, 65
			add dl, idx
			add dl, nameX
			mov dh, 2
			add dh, nameY
			mov bh, 0
			int 10h
			
			inc idx
			
			mov ah, 09
			mov al, msgScore[si]
			mov bh, 0
			mov bl, 03
			mov cx, 1
			int 10h
			
			inc si
			cmp si, 8
			jne loop1
		
		mov ax, score
		mov number, ax
		mov al, idx
		mov charX, al
		add charX, 65
		mov al, nameX
		add charX, al
		mov charY, 2
		mov al, nameY
		add charY, al
		call printMulti
		ret
	displayScore endP

	;-----------------------------------------------------------------
	;	procedure to print msgName string & _name string
	;-----------------------------------------------------------------		
	displayName proc				
		mov idx, 0
		mov si, 0
		loop1:						; keeps printing a character until end of string
			mov ah, 02
			mov dl, 1
			add dl, idx
			add dl, nameX
			mov dh, 2
			add dh, nameY
			mov bh, 0
			int 10h
			
			inc idx
			
			mov ah, 09
			mov al, msgName[si]
			mov bh, 0
			mov bl, 03
			mov cx, 1
			int 10h
			
			inc si
			cmp si, 8
			jne loop1
			
		mov si, 0
		loop2:						; keeps printing a character until ascii of enter is encountered
			cmp _name[si], 13
			je l1
			mov ah, 02
			mov dl, 0
			add dl, idx
			add dl, nameX
			mov dh, 2
			add dh,	nameY
			mov bh, 0
			int 10h
			
			inc idx
			
			mov ah, 09
			mov al, _name[si]
			mov bh, 0
			mov bl, 03
			mov cx, 1
			int 10h
			
			mov cl, _name[si]
			inc si
			jmp loop2
			l1:
		ret
	displayName endP

	;-----------------------------------------------------------------
	;	procedure to print msgMoves string
	;-----------------------------------------------------------------	
	displayMoves proc
		mov idx, 0
		mov si, 0
		loop1:					; keeps printing a character until end of string
			mov ah, 02
			mov dl, 35
			add dl, idx
			mov dh, 2
			mov bh, 0
			int 10h
			
			inc idx
			
			mov ah, 09
			mov al, msgMoves[si]
			mov bh, 0
			mov bl, 03
			mov cx, 1
			int 10h
			
			inc si
			cmp si, 8
			jne loop1
		
		mov ax, 0
		mov al, nMoves
		mov number, ax
		mov charx, 35
		mov al, idx
		add charX, al
		mov charY, 2
		call printMulti
		
		mov ah, 02
		mov dl, 37
		add dl, idx
		mov dh, 2
		mov bh, 0
		int 10h

		mov ah, 09
		mov al, '/'
		mov bh, 0
		mov bl, 03
		mov cx, 1
		int 10h
		
		mov ax, 0
		mov al, totalMoves
		mov number, ax
		mov charx, 38
		mov al, idx
		add charX, al
		mov charY, 2
		call printMulti
				ret
	displayMoves endP

	;----------------------------------------------------------------------------------------------
	;	procedure to print multidigit numbers on a screen, takes number, charx & chary as parameter
	;----------------------------------------------------------------------------------------------					
	printMulti proc								; this method enables 				
		mov ax, number							; move num to ax
		cmp number, 10
		jb one
		cmp number, 100
		jb two
		cmp number, 1000
		jb three
		mov cl, 4								; if three digit mov cl, 3
		jmp exec
		one:
			mov cl, 1							; if single digit mov cl, 1
			jmp exec
		two:	
			mov cl, 2							; if two digit mov cl, 1
			jmp exec
		three:
			mov cl, 3
		exec:
		mov ch, 0
		mov bl, 10
		mov row, cl
		pushInStack:
			div bl								; div value in ax by 10
			mov dx, 0							
			mov dl, ah			
			push dx								; push the remainder
			mov ah, 0
			loop pushInStack					
			
		mov i, 0
		mov bl, row
		mov bh, 0
		mov j, bx								; loop runs according to the number of digits
		print:
			pop dx								; now popping the values					
			mov char, dl
			add char, 48
												; displaying the characters
			mov ah, 02
			mov dl, charX
			mov dh, charY
			mov bh, 0
			int 10h
			
			mov ah, 09
			mov al, char
			mov bh, 0
			mov bl, 03
			mov cx, 1
			int 10h
			inc charX
			inc i
			mov bx, j
			cmp i, bx
			jne print
		
		ret
	printMulti endP

	;-----------------------------------------------------------------
	;	procedure to get button, x axis and y axis of mouse 
	;-----------------------------------------------------------------	
	GetCoordinates proc
		mov ax, 03
		int 33h
		mov button, bx
		mov mouseX, cx
		mov mouseY, dx
		ret
	GetCoordinates endP
	
	;---------------------------------------------------------------------------------
	;	procedure to convert pixels inti indexes, takes mouseX & mouseY as parameter
	;---------------------------------------------------------------------------------
	GetIndex proc
		mov ax, mouseX
		mov bl, 64
		div bl
		mov ah, 0
		mov gridX, ax			; since each tile is 64 pixels in width we divide by 64 to get index
		
		mov ax, mouseY	
		sub ax, 79
		mov bl, 40
		div bl
		mov ah, 0
		mov gridY, ax			; since starting pixel value of tiles in 79 we sub 79 then divide by length of tile i.e. 40
		
		ret
	GetIndex endP

	;------------------------------------------------------------------------------------------
	;	procedure to swap two elements, tales gridX, gridY, oldGridX & oldGridY as parameter
	;------------------------------------------------------------------------------------------	
	Swap proc					
		mov si, 0
		mov ax, gridY
		mov bh, 10
		mul bh
		add ax, gridX
		mov temp, ax			; calculating current index of grid
		
		mov ax, oldGridY
		mov bh, 10
		mul bh
		add ax, oldGridX
		mov di, ax
		mov si, ax				; calculating previous index of grid
								; swapping values
		mov bl, grid[si]	
		mov si, temp
		mov bh, grid[si]
		mov si, ax
		mov grid[si], bh
		mov si, temp
		mov grid[si], bl
		
		mov si, temp
		cmp grid[si], 'B'		; checking for B
		je explode1
		cmp grid[di], 'B'
		je explode2
		
		jmp return
		explode1:				; detonate all occurances of the swapped character
			mov al, grid[di]
			mov swapNum, al
			call Detonate
			mov al, 0			; remove B
			mov grid[si], al
			jmp return
		explode2:
			mov al, grid[si]
			mov swapNum, al
			call Detonate
			mov al, 0
			mov grid[di], al
		return:
		ret
	Swap endP

	;-----------------------------------------------------------------
	;	procedure to Draw a a filled tile where user clicks
	;-----------------------------------------------------------------	
	DrawClick proc
		call GetIndex			; getting indexes for the current mouse position
		mov ax, gridX
		mov bl, 64
		mul bl
		mov x, ax				; getting starting pixel position of x-axis
		mov ax, gridY
		add ax, 2
		mov bl, 40
		mul bl
		mov y, ax				; getting starting pixel position og y-axis
		
		call DrawFilledRect		; calling proc that displays filled rectangle
		ret
	DrawClick endP
	
	;----------------------------------------------------------------------
	;	procedure to Draw a filled tile, takes x and y as starting indexes
	;----------------------------------------------------------------------
	DrawFilledRect proc
		mov i, 0
		loop1:
			mov j, 0
			loop2:
				mov ah, 0ch
				mov al, 03
				mov cx, x
				mov dx, y
				add cx, j
				add dx, i
				int 10h
				inc j
				cmp j, 64
				jne loop2
			inc i	
			cmp i, 40
			jne loop1
		ret
	DrawFilledRect endP

	;-----------------------------------------------------------------
	;	procedure to swap and display selected tile at mouse click
	;-----------------------------------------------------------------	
	MouseClick proc
		mouse:
			mov ax, 1						; show mouse pointer
			int 33h
			
			call GetCoordinates				; get mouse coordinates
			cmp mouseY, 79					; ignore if y pixels are less than 79
			jb again
			
			call checkBlocker
			cmp flag4, 1
			je again
			
			cmp level, 2					; if level is two go to levTwo
			je levTwo
			jmp levOne						; else jump to levOne
			
			levTwo:
				call checkBounds			; check bouds for level 2 and allow moves accordingly
				cmp allow, 0
				je again
			
			levOne:
			cmp button, 0
			jne s
			mov prevButton, 0				; checking status of previous click
			s:
			cmp prevButton, 1
			je again
			cmp button, 1					; if button is not pressed jump to again
			jne again
			mov bx, button
			mov prevButton, bx
			
			call DrawClick					; else call draw click
			inc nclicks						; increment number of clicks
			
			cmp nclicks, 2					; if no. of clicks equals 2 jump to swap elements 
			je swapElements
											; else copy current indexes to old indexes
			mov ax, gridX
			mov oldGridX, ax
			mov ax, gridY
			mov oldGridY, ax
			jmp again						; jump to again
			
			swapElements:
				call restrict
				cmp flag, 1
				jne return
				call Swap					; swap entries
				jmp return
			again:
				jmp mouse
		return:
				mov nclicks, 0				; set nClicks as zero, ready for another swap
				mov oldGridX, 0
				mov oldGridY, 0
				mov gridX, 0
				mov gridY, 0
			ret
	MouseClick endP
	
	;-----------------------------------------------------------------
	;	procedure that displays message game over
	;-----------------------------------------------------------------	
	displayGameOver proc
		mov idx, 0
		mov si, 0
		loop1:					; keeps printing a character until end of string
			mov ah, 02
			mov dl, 33
			add dl, idx
			mov dh, 9
			mov bh, 0
			int 10h
			
			inc idx
			
			mov ah, 09
			mov al, msgOver[si]
			mov bh, 0
			mov bl, 12
			mov cx, 1
			int 10h
			
			inc si
			cmp si, 16
			jne loop1
		ret
	displayGameOver endP
	
	displayLevel proc
		mov idx, 0
		mov si, 0
		loop1:					; keeps printing a character until end of string
			mov ah, 02
			mov dl, 1
			add dl, idx
			mov dh, 0
			mov bh, 0
			int 10h
			
			inc idx
			
			mov ah, 09
			mov al, msgLevel[si]
			mov bh, 0
			mov bl, 12
			mov cx, 1
			int 10h
			
			inc si
			cmp si, 8
			jne loop1
			
		mov ah, 02
		mov dl, idx
		inc dl
		mov dh, 0
		mov bh, 0
		int 10h
			
		mov ah, 09
		mov al, level
		add al, 48
		mov bh, 0
		mov bl, 12
		mov cx, 1
		int 10h
		
		ret
	displayLevel endP
	
	;-----------------------------------------------------------------
	;	procedure that displays the end screen after game is over
	;-----------------------------------------------------------------	
	GameOver proc
		call newWindow					; creating new window
		call displayGameOver			; displaying game over string
		mov nameX, 33					; setting coordinates for next string
		mov nameY, 10
		call displayName				; displaying user name then setting coordinates again
		mov nameY, 12
		mov nameX, 49
		call displayScore				; displaying score
		ret
	GameOver endP
	
	;-----------------------------------------------------------------
	;	procedure that sets a flag if two swaps are next to each other
	;-----------------------------------------------------------------	
	restrict proc uses ax
		mov ax, gridX				; copying old and current indexes of clicks to temp variables
		mov nX, ax
		mov ax, gridY
		mov nY, ax
		mov ax, oldGridX
		mov oX, ax
		mov ax, oldGridY
		mov oY, ax
		mov flag, 0					; setting flag as 0
		
		mov ax, oX
		cmp ax, nX					; if oldX and currentX are equal go to checkY
		je checkY
		
		mov ax, oY					; if oldY and currentY are equal go to checkX
		cmp ax, oY
		je checkX
		
		jmp return
		checkY:
			mov ax, oY
			cmp ax, nY				; if oy less than ny
			jb SMY
			
			sub ax, nY				; else sub ny from oy and set its flag
			jmp setFlag
			SMY:
				sub nY, ax			; sub oy from ny and move to ax and set its flag
				mov ax, nY
				jmp setFlag			
		
		checkX:
			mov ax, oX
			cmp ax, nX				; if ox less than nx
			jb SMX
			
			sub ax, nX				; else sub nx from ox and set flag
			jmp setFlag
			SMX:
				sub nX, ax
				mov ax, nX			; sub ox from nx and move to ax and set its flag
		setFlag:
			cmp ax, 1
			jne return
			mov flag, 1
			jmp return
		return:
			ret
	restrict endP
	
	;----------------------------------------------------------------------------------------------
	;	procedure that checks bounds when clicking, if allow is set to 1 then user can perform swap 
	;----------------------------------------------------------------------------------------------	
	checkBounds proc
		mov allow, 0
		cmp mouseX, 0
		jae c1
		jmp n1
		c1:
			cmp mouseX, 192
			jbe c2
			jmp n1
		c2:
			cmp mouseY, 200
			jb return
		n1:
			cmp mouseX, 448
			ja c3
			jmp n2
		c3:
			cmp mouseX, 640
			jbe c4
			jmp n2
		c4:
			cmp mouseY, 200
			jb return
		n2:
			cmp mouseX, 192
			ja c5
			jmp n3
		c5:
			cmp mouseX, 448
			jbe c6
			jmp n3
		c6:
			cmp mouseY, 240
			ja c7
			jmp n3
		c7:
			cmp mouseY, 320
			jbe return
		n3:
			cmp mouseX, 0
			jae c8
			jmp n4
		c8:
			cmp mouseX, 192
			jb c9
			jmp n4
		c9:
			cmp mouseY, 360
			ja c10
			jmp n4
		c10:
			cmp mouseY, 480
			jbe return
		n4:
			cmp mouseY, 360
			ja c11
			jmp set
		c11:
			cmp mouseY, 480
			jbe c12
			jmp set
		c12:
			cmp mouseX, 448
			ja c13
			jmp set
		c13:
			cmp x, 640
			jbe return
		set:
			mov allow, 1
		return:
		ret
	checkBounds endP
	
	;-----------------------------------------------------------------------------
	;	procedure that checks if there is a blocker or not while clicking to swap
	;----------------------------------------------------------------------------
	checkBlocker proc
		mov flag4, 0
		call GetIndex
		mov ax, 0
		mov ax, gridY
		mov bl, 10
		mul bl
		mov ah, 0
		add ax, gridX
		mov si, ax
		cmp grid[si], 'X'
		jne return
		mov flag4, 1
		return:
			ret
	checkBlocker endP
end