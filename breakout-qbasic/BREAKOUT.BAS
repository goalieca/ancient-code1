'---------------------------------'
'-- Breakout 2001, Ryan Dickie ---'
'-- June "No more school" 2001 ---'
'----- (c) 2001 Ryan Dickie ------'
'---------------------------------'
'---------------------------------'

'written in Qbasic. Hopefully MS-Dos doesn't disappear
'too soon; otherwise, I can't play this!!!!
'At least WinXP has an emulator. I hope it runs on it
'but it looks like it runs on RC1 (and RC2)

'Press ESC during game to PAUSE

'it may appear that round edges are smaller than the square edges but
'it is just an illusion because they are both the same!!!

DEF SEG = 0 'for keyboard buffer (clearing)
RANDOMIZE TIMER     'make numbers more random!
SCREEN 12 '640 x 480 screen mode, 16 colors

sounds = 1'means sound is on

DIM highscore.name AS STRING * 4  'sets max characters to 4

cheat$ = "OFF"
paddle.cheat$ = "OFF"
speed.cheat$ = "OFF"
lives.cheat$ = "OFF"

rand.d = 6
paddle.width = 75 'can make this whatever i want.
scheme.name$ = "default"
custom.colour = 1

DIM box.x(150) ' x,y location of brick
DIM box.y(150)
DIM brick.hit(120) 'how many hits left a brick has

DIM paddle(300) 'used to store images
DIM ball(75)
DIM brick(100)

'intro screen

CLS 'only here if run more than once in a Qbasic session

PRINT "BREAKOUT 2001"
PRINT "By Ryan Dickie"
COLOR 12
PRINT "15 LEVELS!!!"
COLOR 15
PRINT ""
PRINT "Press any key to continue"

SLEEP

level = 1 'present level
lives = 5
Score = 0
menuitem.selected = 1
number.of.menuitems = 8
colour.temp = 1
square.edges = 0



back.to.menu: 'this is were the program starts


IF lives.cheat$ = "OFF" THEN
lives = 5
ELSE
lives = cheat.lives
END IF


'the following code clears the keyboard buffer
POKE &H41A, PEEK(&H41C)

'menuitem 2 is just sound so no point doing all this
'menuitem 3 is just level picker
IF menuitem.selected <> 2 AND menuitem.selected <> 3 THEN
	IF lives.cheat$ = "ON" THEN lives = cheat.lives

	'gets highscore and name from the file
	OPEN "topscore.dat" FOR INPUT AS 1
	LINE INPUT #1, highscore.name
	INPUT #1, highscore
	CLOSE 1

	GOSUB colour.scheme.loader

	'means uses scheme rather than hand picked
	IF custom.colour = 1 THEN
		OPEN "Colour.dat" FOR INPUT AS 1
		DO
		LINE INPUT #1, scheme$
		IF scheme$ = scheme.name$ THEN
			INPUT #1, paddle.colour
			INPUT #1, ball.colour
			INPUT #1, box.colour
			EXIT DO
		END IF
		LOOP
		CLOSE 1
	END IF

	WAIT &H3DA, 8 'this is to stop preload images
	'from appearing for a split second caused by
	'draw and store images

	GOSUB draw.and.store.images
	CLS
	IF menuitem.selected <> 5 AND menuitem.selected <> 7 THEN
		menuitem.selected = 1
		menux = 250
		menuy = 258
	END IF
	PUT (menux, menuy), ball
END IF

COLOR 15
LOCATE 4, 26: PRINT "Breakout 2001 By Ryan Dickie"
LOCATE 5, 29: PRINT "(c) Ryan Dickie 2001"
COLOR level
COLOR 12

n = (40 - (LEN("15 LEVELS!") \ 2) - 1)
LOCATE 7, n: PRINT "15 LEVELS!"

'number of digits
IF highscore > 999999 THEN
p = 7
ELSE p = 6
END IF

'centres on screen
n = (40 - ((LEN(highscore.name) + 11 + p) \ 2) - 1)
LOCATE 8, n: PRINT "HIGHSCORE:"; highscore.name; highscore

COLOR 9
LOCATE 17, 35: PRINT "Play"
IF sounds = 1 THEN LOCATE 18, 35: PRINT "Sound ON "
IF sounds = 0 THEN LOCATE 18, 35: PRINT "Sound OFF"
LOCATE 19, 35: PRINT "Level"; level; " "
LOCATE 20, 35: PRINT "Cheats "; cheat$
IF custom.colour = 1 THEN LOCATE 21, 35: PRINT UCASE$(scheme.name$); " Colours                      "

n = (40 - ((LEN("CUSTOM Colours")) \ 2) - 1)
IF custom.colour = 0 THEN LOCATE 21, 35: PRINT "CUSTOM Colours                              "
LOCATE 22, 35: PRINT "Customize Colours"


IF square.edges = 0 AND scheme.name$ <> "old pong" THEN LOCATE 23, 35: PRINT "Round Edges "
IF square.edges = 1 OR scheme.name$ = "old pong" THEN LOCATE 23, 35: PRINT "Square Edges"

LOCATE 24, 35: PRINT "Exit"



DO
temp$ = INKEY$
SELECT CASE temp$
CASE CHR$(0) + CHR$(72): GOSUB menu.up
CASE CHR$(0) + CHR$(80): GOSUB menu.down
CASE CHR$(13): GOTO select.item
CASE CHR$(0) + CHR$(77): GOTO select.item
CASE CHR$(0) + CHR$(75): GOTO select.item
END SELECT
LOOP


start.to.play:
CLS


'--------------------------'
'--Head do Loop below------'
'--------------------------'
'--------------------------'

head.do.loop:
DO
SELECT CASE level
CASE 1: GOSUB level1
CASE 2: GOSUB level2
CASE 3: GOSUB level3
CASE 4: GOSUB level4
CASE 5: GOSUB level5
CASE 6: GOSUB level6
CASE 7: GOSUB Level7
CASE 8: GOSUB Level8
CASE 9: GOSUB Level9
CASE 10: GOSUB Level10
CASE 11: GOSUB Level11
CASE 12: GOSUB Level12
CASE 13: GOSUB Level13
CASE 14: GOSUB Level14
CASE 15: GOSUB Level15
END SELECT
LOOP WHILE level < 16

'-------------------------------'
'---If it exits the above loop--'
'---Then the game is passed-----'
'-------------------------------'
'-------------------------------'
GOTO beat.game


completed.level:
CLS
PRINT "Level Complete!"
PRINT "Bonus of "; (level - 1) * 10000; " added to score!"
Score = Score + ((level - 1) * 10000)
PRINT "score: "; Score
lives = lives + 3
PRINT "Lives: "; lives; " +3up!"
PRINT "Press enter to Continue!"
DO
POKE &H41A, PEEK(&H41C) 'clear keyboard buffer
temp = INP(&H60)
LOOP WHILE temp <> 28 '28 is scancode for enter
CLS
GOTO head.do.loop


beat.game:
CLS
PRINT "You won!"
IF cheat$ = "ON" THEN PRINT "You cheated!"

''''''''''''''''''''''''''''''
'''' animation goes here '''''
''''''''''''''''''''''''''''''
''''''''''''''''''''''''''''''

PRINT "Press enter to continue."
DO
POKE &H41A, PEEK(&H41C)
temp = INP(&H60)
LOOP UNTIL temp = 28
GOSUB highscore
level = 1
GOTO back.to.menu

highscore:
IF Score > highscore AND cheat$ = "OFF" THEN
COLOR 12
PRINT "New HIGHSCORE"; Score
INPUT "Your Name"; highscore.name
OPEN "topscore.dat" FOR OUTPUT AS 1
PRINT #1, UCASE$(highscore.name) 'prints in uppercase
PRINT #1, Score
CLOSE 1
END IF
RETURN


''''''''''''''''''''''''''''''''''''''''
''' This is the games main loop....'''''
''' Actually a sub that is called upon''
''' by level1 or level2 etc. '''''''''''
''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''

mainloop:

POKE &H41A, PEEK(&H41C) 'empty keyboard buffer
temp = INP(&H60)  'reads key from buffer

'wait for v-sync 60Hz in this screen mode in DOS thus 1/60th of a second delay,also smooths image
WAIT &H3DA, 8

PUT (x, 465), paddle   'erase the images
PUT (ball.x, ball.y), ball 'of the paddle and the ball

SELECT CASE temp
CASE 1: GOSUB pause
CASE 75: GOSUB paddle.left
CASE 77: GOSUB paddle.right
END SELECT

IF r = 1 THEN GOSUB ball.right ELSE GOSUB ball.left
IF d = 0 THEN GOSUB ball.up ELSE GOSUB ball.down

PUT (ball.x, ball.y), ball 'draws images
PUT (x, 465), paddle
IF box.y(last.brick) + 11 > ball.y THEN GOSUB check.ball  'saves lots of loops

IF boxes.left = 0 THEN level = level + 1
RETURN

'this is just because it saves memory and code
random.right:
rand.r = INT(RND * 5) + 2
RETURN


paddle.left:
x = x - 8
IF x < 1 THEN x = 1
leftspeed = leftspeed + 1
rightspeed = 0
RETURN

paddle.right:
x = x + 8
IF x + paddle.width > width.level THEN x = width.level - paddle.width
rightspeed = rightspeed + 1
leftspeed = 0
RETURN

ball.down:

ball.y = ball.y + rand.d
IF ball.y + 10 >= 464 AND ball.x + 10 >= x AND ball.x <= x + paddle.width THEN
	IF sounds = 1 THEN SOUND 400, .5
	d = 0 'd stands for down, 0 is false

'this puts paddle speed into ball movement
IF rightspeed > 0 THEN
	rand.r = rightspeed \ 2  ' \  (not / ) is integer divide
	r = 1
	IF rand.r > 7 THEN rand.r = 7
	END IF
IF leftspeed > 0 THEN
	rand.r = leftspeed \ 2
	IF rand.r > 7 THEN rand.r = 7
	r = 0
	END IF
END IF

IF rand.r < 3 THEN rand.r = 3
IF ball.y > 469 THEN
	GOSUB lost.life  'what it sounds like
END IF
RETURN

ball.up:
ball.y = ball.y - rand.d  'rand.d is amount to move up or down
IF ball.y < 20 THEN
	ball.y = 20
	IF sounds = 1 THEN SOUND 400, .5
	d = 1
	GOSUB random.right
END IF
RETURN

ball.left:
ball.x = ball.x - rand.r
IF ball.x < 1 THEN
	IF sounds = 1 THEN SOUND 400, .5
	ball.x = 1
	r = 1
	GOSUB random.right
END IF
RETURN

ball.right:
ball.x = ball.x + rand.r
IF ball.x + 10 > width.level THEN
	IF sounds = 1 THEN SOUND 400, .5
	ball.x = width.level - 10    'ball is 10 wide
	r = 0
	GOSUB random.right
END IF
RETURN


menu.up:
IF menuitem.selected = 1 THEN menuitem.selected = number.of.menuitems + 1
menuitem.selected = menuitem.selected - 1
PUT (menux, menuy), ball
menuy = menuy - 16
IF menuitem.selected = number.of.menuitems THEN menuy = 258 + (16 * (number.of.menuitems - 1))
PUT (menux, menuy), ball
RETURN

menu.down:
IF menuitem.selected = number.of.menuitems THEN menuitem.selected = 0
menuitem.selected = menuitem.selected + 1
PUT (menux, menuy), ball
menuy = menuy + 16
IF menuitem.selected = 1 THEN menuy = 258
PUT (menux, menuy), ball

RETURN

'this is for main menu.
select.item:
SELECT CASE menuitem.selected
CASE 1:
	GOTO start.to.play
CASE 2:
	IF sounds = 0 THEN sounds = 1 ELSE sounds = 0
CASE 3:
	IF temp$ = CHR$(0) + CHR$(75) THEN level = level - 1
	IF temp$ = CHR$(0) + CHR$(77) THEN level = level + 1
	IF level = 0 THEN level = 15
	IF level = 16 THEN level = 1
CASE 4:
	GOSUB cheats
CASE 5:
	IF temp$ = CHR$(0) + CHR$(75) THEN colour.temp = colour.temp - 1
	IF temp$ = CHR$(0) + CHR$(77) THEN colour.temp = colour.temp + 1
	IF colour.temp = 0 THEN colour.temp = number.of.schemes
	IF colour.temp > number.of.schemes THEN colour.temp = 1
	scheme.name$ = temp.names$(colour.temp)
	custom.colour = 1
CASE 6: GOSUB colour.picker
CASE 7:
	IF square.edges = 1 THEN
		square.edges = 0
	ELSE
		square.edges = 1
	END IF

CASE number.of.menuitems: 'this is exit. always last
	END
END SELECT
GOTO back.to.menu

cheat.menu:
number.of.cheats = 3
CLS
PRINT "If any cheat is on then any new highscores are invalid."
PRINT ""
PRINT "1.) Change paddle Size "; paddle.cheat$
PRINT "2.) Change Ball Speed "; speed.cheat$
PRINT "3.) More lives "; lives.cheat$
PRINT "4.) Turn off a cheat."
PRINT "5.) Go back to menu"
PRINT ""
PRINT "Please make a selection."
PRINT ""
RETURN


cheats:
GOSUB cheat.menu:
DO
POKE (&H41A), PEEK(&H41C)
temp = INP(&H60)
SELECT CASE temp 'same a switch(temp){  };

CASE 2:
	DO
	INPUT "What paddle size would you like? (20 - 200 : 75 is Normal)"; paddle.width
	LOOP WHILE paddle.width < 20 OR paddle.width > 200
	IF paddle.width <> 75 THEN paddle.cheat$ = "ON"

	'in case cheat was already on this code below would turn it off
	IF paddle.width = 75 THEN paddle.cheat$ = "OFF"

	GOSUB cheat.menu
CASE 3:
	DO
	INPUT "What vertical ball speed would you like? (1 - 6 : 6 is Normal)"; rand.d
	LOOP WHILE rand.d > 6 OR rand.d < 1
	IF rand.d < 6 THEN speed.cheat$ = "ON"
	IF rand.d = 6 THEN speed.cheat$ = "OFF"
	GOSUB cheat.menu
CASE 4:
	DO
	INPUT "How many lives would you like? (1 - 100 : 5 is Normal)"; cheat.lives
	LOOP WHILE cheat.lives < 1 OR cheat.lives > 100
	IF cheat.lives <> 5 THEN lives.cheat$ = "ON"
	IF cheat.live = 5 THEN lives.cheat$ = "OFF"
	GOSUB cheat.menu
CASE 5:
	IF cheat$ = "ON" THEN
		DO
		INPUT "Which cheat you you like to turn off"; cheat.off
		IF cheat.off = 1 THEN paddle.width = 75: paddle.cheat$ = "OFF"
		IF cheat.off = 2 THEN rand.d = 6: speed.cheat$ = "OFF"
		IF cheat.off = 3 THEN lives = 5: lives.cheat$ = "OFF"
		LOOP WHILE cheat.off < 1 OR cheat.off > number.of.cheats
		GOSUB cheat.menu
	ELSE
		LOCATE number.of.cheats + 7, 1: PRINT "There are No Cheats to Turn Off!"
	END IF
END SELECT
IF paddle.cheat$ = "OFF" AND speed.cheat$ = "OFF" AND lives.cheat$ = "OFF" THEN
cheat$ = "OFF"
ELSE
cheat$ = "ON"
END IF
LOOP WHILE temp <> 6 'number +1 is scancode eg: esc=1 , 1=2, 2=3
RETURN

lost.life:
lives = lives - 1
PUT (x, 465), paddle
IF sounds = 1 THEN
FOR n = 620 TO 300 STEP -10
SOUND n, .75
NEXT n
END IF
IF lives > 0 THEN
PUT (x, 465), paddle
GOTO get.ready.to.launch
END IF


lost.game:
CLS
GOSUB highscore
COLOR 15
PRINT "You lost!"
PRINT "Press Enter to Continue."
DO
POKE &H41A, PEEK(&H41C)
temp = INP(&H60)
LOOP UNTIL temp = 28
level = 1
GOTO back.to.menu



get.ready.to.launch:
GOSUB print.score
COLOR 15
x = (width.level / 2) - (paddle.width / 2)
'apparently / means dividend is integer and not float, rounded
PUT (x, 465), paddle
ball.x = x + ((paddle.width / 2) - 6)

'if the answer is 1 then the number is 1.
IF paddle.width MOD 2 = 1 THEN ball.x = ball.x - 1
'it means it is odd thus the ball.x is over to the right by one because of
'the rounding from the integer division

ball.y = 453
PUT (ball.x, ball.y), ball
d = 0
r = INT(RND * 2) + 1   'left or right
GOSUB random.right    'horizontal speed
	

LOCATE 23, 30: PRINT "Press UP to Launch!"
'the following code clears the keyboard buffer
POKE &H41A, PEEK(&H41C)

DO
temp$ = INKEY$
LOOP WHILE temp$ <> CHR$(0) + CHR$(72)

LOCATE 23, 30: PRINT "                   "
SELECT CASE level

'each label if just before the section that calls the main loop
'in each level
CASE 1: GOTO 1
CASE 2: GOTO 2
CASE 3: GOTO 3
CASE 4: GOTO 4
CASE 5: GOTO 5
CASE 6: GOTO 6
CASE 7: GOTO 7
CASE 8: GOTO 8
CASE 9: GOTO 9
CASE 10: GOTO 10
CASE 11: GOTO 11
CASE 12: GOTO 12
CASE 13: GOTO 13
CASE 14: GOTO 14
CASE 15: GOTO 15
END SELECT


check.ball:
hit.more.than.one = 0
FOR n = 1 TO boxes.level
IF brick.hit(n) > 0 THEN
	IF ball.x + 10 >= box.x(n) AND ball.x <= box.x(n) + 50 AND ball.y <= box.y(n) + 10 AND ball.y + 10 >= box.y(n) THEN
		
		IF sounds = 1 THEN SOUND 450, .5
		Score = Score + 100
		brick.hit(n) = brick.hit(n) - 1
		
'so if it hits 2 brick then it doesn't change direction twice
	hit.more.than.one = hit.more.than.one + 1
	   IF hit.more.than.one < 2 THEN
998    IF d = 0 THEN d = 1 ELSE d = 0     'this is line 998 refered to as below
	   END IF

	SELECT CASE (r)
		CASE 1:
			IF ball.x + 10 < box.x(n) + (rand.r - 1) THEN
			r = 0

			'if it hits from the side we dont' want it to change
			'direction going up or down. This will undo line label 998.

			IF hit.more.than.one < 2 THEN IF d = 0 THEN d = 1 ELSE d = 0
		END IF
		CASE 0:
			IF ball.x > box.x(n) + (51 - rand.r) THEN
			r = 1
			IF hit.more.than.one < 2 THEN IF d = 0 THEN d = 1 ELSE d = 0
			END IF
	END SELECT
		
		
		IF brick.hit(n) = 0 THEN
			PUT (box.x(n), box.y(n)), brick, XOR
			boxes.left = boxes.left - 1
			IF n = last.brick AND boxes.left > 0 THEN
			DO
			last.brick = last.brick - 1
			LOOP WHILE brick.hit(last.brick) = 0
			END IF
		END IF
	END IF
END IF
NEXT n
GOSUB print.score
RETURN


pause:
COLOR 15
LOCATE 20, 33: PRINT "Game Paused"
LOCATE 21, 16: PRINT "Press Enter to Resume : Press Escape to quit"
PUT (x, 465), paddle
PUT (ball.x, ball.y), ball
POKE &H41A, PEEK(&H41C)

DO
temp$ = INKEY$
LOOP UNTIL temp$ <> ""
IF temp$ = CHR$(27) THEN GOTO back.to.menu

'to clean ball if it was in text during pause!!!!!
PUT (ball.x, ball.y), ball
PUT (x, 465), paddle
'clean up text without erasing screen by printing over it
LOCATE 20, 33: PRINT "           "
LOCATE 21, 16: PRINT "                                            "

RETURN

print.score:
COLOR level
IF Score > highscore AND cheat$ = "OFF" THEN
	LOCATE 1, 1: PRINT "HIGHSCORE:"; Score
ELSE
	LOCATE 1, 1: PRINT "HIGHSCORE:"; highscore
END IF
LOCATE 1, 28: PRINT "SCORE:"; Score
LOCATE 1, 68: PRINT "LEVEL:"; level
LOCATE 1, 50: PRINT "LIVES:"; lives
RETURN








colour.scheme.loader:
OPEN "colour.dat" FOR INPUT AS 1
number.of.schemes = 0

''''''''''''''''''''''''''''''''''''''''''''''
'This loop is to determine number of schemes '
''''''''''''''''''''''''''''''''''''''''''''''

DO
number.of.schemes = number.of.schemes + 1
LINE INPUT #1, temp.namesr$ 'name of scheme
INPUT #1, tsr
INPUT #1, tsr
INPUT #1, tsr
INPUT #1, t ' this is blank space between schemes
LOOP UNTIL EOF(1) = -1 'end of file = true.
CLOSE 1

''''''''''''''''''''''''''''''''''
'This array is sized accordingly '
''''''''''''''''''''''''''''''''''
REDIM temp.name$(number.of.schemes)

OPEN "colour.dat" FOR INPUT AS 1

''''''''''''''''''''''''''''''''''''''''''''''''' '
'this loop stores all of the names of the schemes '
''''''''''''''''''''''''''''''''''''''''''''''''' '

FOR n = 1 TO number.of.schemes
LINE INPUT #1, temp.names$(n) 'name of scheme
INPUT #1, temp
INPUT #1, temp
INPUT #1, temp
IF EOF(1) = -1 THEN EXIT FOR 'incase of problems
INPUT #1, temp ' this is blank space between schemes
NEXT n
CLOSE 1
RETURN


draw.and.store.images:
CLS

IF scheme.name$ = "old pong" OR square.edges = 1 THEN

LINE (10, 10)-(20, 20), ball.colour, BF
LINE (201, 201)-(249, 209), box.colour, BF 'brick image
LINE (100, 100)-(paddle.width + 100, 110), paddle.colour, BF

GET (10, 10)-(20, 20), ball
GET (100, 100)-(paddle.width + 100, 110), paddle
GET (201, 201)-(249, 209), brick

RETURN
END IF

CIRCLE (100, 100), 5, ball.colour   'ball
PAINT (100, 100), ball.colour

LINE (15, 10)-(paddle.width - 5, 20), paddle.colour, BF'paddle image
CIRCLE (15, 15), 5, paddle.colour  'rounded edge left
PAINT (14, 15), paddle.colour
CIRCLE (paddle.width - 5, 15), 5, paddle.colour'rounded edge right
PAINT (paddle.width - 4, 15), paddle.colour

LINE (201, 201)-(249, 209), box.colour, BF'brick image


GET (10, 10)-(paddle.width, 20), paddle   'store in array
GET (95, 95)-(105, 105), ball 'store in array
GET (200, 200)-(250, 210), brick 'store in array
RETURN

colour.picker:
CLS
custom.colour = 0
PRINT "Enter the Number of the Colour that you would like for each instance."
FOR n = 1 TO 15
LOCATE 2, (n * 4): COLOR n: PRINT n
NEXT n
COLOR 15

DO

'in case overflow statement appears or redo from start appears
'clears that junk up (crap from input)
FOR n = 4 TO 20
	LOCATE n, 1: PRINT "                                                                                                        "
	NEXT

LOCATE 4, 1: INPUT "What colour would you like the paddle to be"; paddle.colour
LOOP WHILE paddle.colour < 1 OR paddle.colour > 15

DO
FOR n = 5 TO 20
LOCATE n, 1: PRINT "                                                                                                        "
NEXT


LOCATE 6, 1: PRINT "                                                                                                          "
LOCATE 6, 1: INPUT "What colour would you like the ball to be"; ball.colour
LOOP WHILE ball.colour < 1 OR ball.colour > 15

DO

FOR n = 7 TO 20
LOCATE n, 1: PRINT "                                                                                                        "
NEXT

LOCATE 8, 1: PRINT "                                                                                                          "
LOCATE 8, 1: INPUT "What colour would you like the bricks to be"; box.colour
LOOP WHILE box.colour < 1 OR box.colour > 15

PRINT "Would you like to save this scheme? (Y/N) "
DO
choice$ = INKEY$
LOOP UNTIL UCASE$(choice$) = "Y" OR UCASE$(choice$) = "N"
IF UCASE$(choice$) = "Y" THEN
custom.colour = 1

redo:
IF tempername$ = scheme.name$ THEN PRINT "There is already a scheme by this name!"
INPUT "What would you like to call this scheme"; scheme.name$

'''''''''''''''''''''''''''''''''''''''''''''''''
'looks to see if name of scheme is already taken'
'''''''''''''''''''''''''''''''''''''''''''''''''
reason = 0
OPEN "colour.dat" FOR INPUT AS 1
DO
LINE INPUT #1, tempername$
IF tempername$ = scheme.name$ THEN CLOSE 1: GOTO redo
IF LEN(scheme.name$) > 10 THEN PRINT "Must be less than 21 letters": CLOSE 1: GOTO redo
LOOP UNTIL EOF(1) = -1
CLOSE 1

OPEN "colour.dat" FOR APPEND AS 1
PRINT #1, scheme.name$
PRINT #1, paddle.colour
PRINT #1, ball.colour
PRINT #1, box.colour
PRINT #1, ""
CLOSE 1

END IF
GOTO back.to.menu


brick.hits:
FOR n = 1 TO boxes.left
brick.hit(n) = hits.per.brick
NEXT n
y = 20
boxes.level = boxes.left
last.brick = boxes.level
RETURN


level1:
	'''''''Main Setup
boxes.left = 72
hits.per.brick = 1
GOSUB brick.hits

t = 0
FOR n = 1 TO 6
x = 0
	FOR i = 1 TO 12
	t = t + 1
	box.x(t) = x
	box.y(t) = y
	PUT (box.x(t), box.y(t)), brick
	x = x + 51
	NEXT i
width.level = x
y = y + 11
NEXT n

GOTO get.ready.to.launch
1 'IMPORTANT TO STICK LEVEL NUMBER HERE!!!!

DO
GOSUB mainloop
LOOP WHILE level = 1

GOTO completed.level




level2:
	'''''''Main Setup
boxes.left = 36
hits.per.brick = 2
GOSUB brick.hits
t = 0
FOR n = 1 TO 6
x = 0
	FOR i = 1 TO 6
	t = t + 1
	box.x(t) = x
	box.y(t) = y
	PUT (box.x(t), box.y(t)), brick
	x = x + 101
	NEXT i
width.level = x
y = y + 11
NEXT n

GOTO get.ready.to.launch

2 'IMPORTANT TO STICK LEVEL NUMBER HERE!!!!

DO
GOSUB mainloop
LOOP WHILE level = 2

GOTO completed.level

level3:
boxes.left = 18
hits.per.brick = 3
GOSUB brick.hits
t = 0
FOR n = 1 TO 3
x = 0
	FOR i = 1 TO 6
	t = t + 1
	box.x(t) = x
	box.y(t) = y
	PUT (box.x(t), box.y(t)), brick
	x = x + 101
	NEXT i
width.level = x
y = y + 21
NEXT n

GOTO get.ready.to.launch
		'''''''Use this format for all levels (below)

3 'IMPORTANT TO STICK LEVEL NUMBER HERE!!!!


DO
GOSUB mainloop
LOOP WHILE level = 3

GOTO completed.level

level4:

boxes.left = 30
hits.per.brick = 2
GOSUB brick.hits


t = 0
FOR n = 1 TO 6
x = 185
	FOR i = 1 TO 5
	t = t + 1
	box.x(t) = x
	box.y(t) = y
	PUT (box.x(t), box.y(t)), brick
	x = x + 51
	NEXT i
y = y + 21
NEXT n
width.level = 620
GOTO get.ready.to.launch
		'''''''Use this format for all levels (below)

4 'IMPORTANT TO STICK LEVEL NUMBER HERE!!!!


DO
GOSUB mainloop
LOOP WHILE level = 4

GOTO completed.level

level5:
boxes.left = 36
hits.per.brick = 2
GOSUB brick.hits
t = 0
FOR n = 1 TO 6
x = 0
	FOR i = 1 TO 6
	t = t + 1
	box.x(t) = x
	box.y(t) = y
	PUT (box.x(t), box.y(t)), brick
	x = x + 101
	NEXT i
width.level = x
y = y + 21
NEXT n

GOTO get.ready.to.launch
		'''''''Use this format for all levels (below)

5 'IMPORTANT TO STICK LEVEL NUMBER HERE!!!!


DO
GOSUB mainloop
LOOP WHILE level = 5

GOTO completed.level

level6:
boxes.left = 31

hits.per.brick = 2
GOSUB brick.hits

t = 0
l = 0
p = 12
FOR n = 1 TO 5
p = p - 2
l = l + 50
x = l
FOR i = 1 TO p
	t = t + 1
	box.x(t) = x
	box.y(t) = y
	PUT (box.x(t), box.y(t)), brick
	x = x + 51
NEXT i
y = y + 21
NEXT n

box.x(31) = 275
box.y(31) = 125
PUT (box.x(31), box.y(31)), brick

width.level = 610
GOTO get.ready.to.launch
		'''''''Use this format for all levels (below)

6 'IMPORTANT TO STICK LEVEL NUMBER HERE!!!!


DO
GOSUB mainloop
LOOP WHILE level = 6

GOTO completed.level

Level7:
boxes.left = 44
hits.per.brick = 2

GOSUB brick.hits

t = 0
FOR n = 1 TO 22
x = 170
	FOR i = 1 TO 2
	t = t + 1
	box.x(t) = x
	box.y(t) = y
	PUT (box.x(t), box.y(t)), brick
	x = x + 201
	NEXT i
y = y + 11
NEXT n
width.level = 620
GOTO get.ready.to.launch
		'''''''Use this format for all levels (below)

7 'IMPORTANT TO STICK LEVEL NUMBER HERE!!!!


DO
GOSUB mainloop
LOOP WHILE level = 7

GOTO completed.level


Level8:
boxes.left = 90
hits.per.brick = 1
GOSUB brick.hits

t = 0
odd.or.even = 1
FOR n = 1 TO 15
IF odd.or.even = 1 THEN
	odd.or.even = 0
	x = 0
ELSE
	odd.or.even = 1
	x = 50
END IF

	FOR i = 1 TO 6
	t = t + 1
	box.x(t) = x
	box.y(t) = y
	PUT (box.x(t), box.y(t)), brick
	x = x + 100
	NEXT i
width.level = x
y = y + 11
NEXT n

GOTO get.ready.to.launch
		'''''''Use this format for all levels (below)

8 'IMPORTANT TO STICK LEVEL NUMBER HERE!!!!


DO
GOSUB mainloop
LOOP WHILE level = 8

GOTO completed.level


Level9:
boxes.left = 90

hits.per.brick = 1
GOSUB brick.hits


t = 0
FOR n = 1 TO 18
x = 185
	FOR i = 1 TO 5
	t = t + 1
	box.x(t) = x
	box.y(t) = y
	PUT (box.x(t), box.y(t)), brick
	x = x + 51
	NEXT i
width.level = 620
y = y + 11
NEXT n

GOTO get.ready.to.launch
		'''''''Use this format for all levels (below)

9 'IMPORTANT TO STICK LEVEL NUMBER HERE!!!!


DO
GOSUB mainloop
LOOP WHILE level = 9

GOTO completed.level


Level10:
boxes.left = 90
hits.per.brick = 1
GOSUB brick.hits

t = 0
odd.or.even = 0
FOR n = 1 TO 15
IF odd.or.even = 2 THEN
	x = 0
ELSE
	x = 50
END IF
	FOR i = 1 TO 6
	t = t + 1
	box.x(t) = x
	box.y(t) = y
	PUT (box.x(t), box.y(t)), brick
	x = x + 100
	NEXT i
width.level = x
y = y + 11
odd.or.even = odd.or.even + 1
IF odd.or.even = 3 THEN odd.or.even = 0
NEXT n

GOTO get.ready.to.launch
10 'IMPORTANT TO STICK LEVEL NUMBER HERE!!!!


DO
GOSUB mainloop
LOOP WHILE level = 10

GOTO completed.level

Level11:
boxes.left = 60
hits.per.brick = 2
GOSUB brick.hits

t = 0
odd.or.even = 0
FOR n = 1 TO 15
x = odd.or.even * 50
odd.or.even = odd.or.even + 1
FOR i = 1 TO 4
	t = t + 1
	box.x(t) = x
	box.y(t) = y
	PUT (box.x(t), box.y(t)), brick
	x = x + 150
	NEXT i
IF odd.or.even = 3 THEN odd.or.even = 0
y = y + 11
NEXT n
width.level = 605
GOTO get.ready.to.launch
		'''''''Use this format for all levels (below)

11 'IMPORTANT TO STICK LEVEL NUMBER HERE!!!!


DO
GOSUB mainloop
LOOP WHILE level = 11

GOTO completed.level

Level12:
boxes.left = 72
hits.per.brick = 2
GOSUB brick.hits
t = 0
odd.or.even = 1
FOR n = 1 TO 12
IF odd.or.even = 1 THEN
x = 0
odd.or.even = 0
ELSE
x = 50
odd.or.even = 1
END IF
	FOR i = 1 TO 6
	t = t + 1
	box.x(t) = x
	box.y(t) = y
	PUT (box.x(t), box.y(t)), brick
	x = x + 101
	NEXT i
width.level = 620
y = y + 21
NEXT n
GOTO get.ready.to.launch
		'''''''Use this format for all levels (below)

12 'IMPORTANT TO STICK LEVEL NUMBER HERE!!!!


DO
GOSUB mainloop
LOOP WHILE level = 12

GOTO completed.level

Level13:
boxes.left = 30
hits.per.brick = 3
GOSUB brick.hits
y = 200
t = 0
FOR n = 1 TO 5
x = 0
	FOR i = 1 TO 6
	t = t + 1
	box.x(t) = x
	box.y(t) = y
	PUT (box.x(t), box.y(t)), brick
	x = x + 101
	NEXT i
width.level = x

y = y + 21
NEXT n

GOTO get.ready.to.launch
		'''''''Use this format for all levels (below)

13 'IMPORTANT TO STICK LEVEL NUMBER HERE!!!!


DO
GOSUB mainloop
LOOP WHILE level = 13

GOTO completed.level

Level14:
boxes.left = 62
hits.per.brick = 2
GOSUB brick.hits

l = 300 'x,y location of left-most brick
p = 0 'number of bricks across
y = 31
x = 300

box.x(1) = 275
box.y(1) = y
PUT (box.x(1), box.y(1)), brick
y = y + 21
t = 1

FOR n = 1 TO 5
p = p + 2
l = l - 50
x = l

FOR i = 1 TO p
	t = t + 1
	box.x(t) = x
	box.y(t) = y
	PUT (box.x(t), box.y(t)), brick
	x = x + 51
NEXT i
y = y + 21
NEXT n

l = 0
p = 12
FOR n = 1 TO 5
p = p - 2
l = l + 50
x = l
FOR i = 1 TO p
	t = t + 1
	box.x(t) = x
	box.y(t) = y
	PUT (box.x(t), box.y(t)), brick
	x = x + 51
NEXT i
y = y + 21
NEXT n

box.x(62) = 275
box.y(62) = y
PUT (box.x(62), box.y(62)), brick

width.level = 610

GOTO get.ready.to.launch
		'''''''Use this format for all levels (below)

14 'IMPORTANT TO STICK LEVEL NUMBER HERE!!!!


DO
GOSUB mainloop
LOOP WHILE level = 14

GOTO completed.level

Level15:
boxes.left = 96
hits.per.brick = 1
GOSUB brick.hits
t = 0
y = 120
FOR n = 1 TO 8
x = 0
	FOR i = 1 TO 12
	t = t + 1
	box.x(t) = x
	box.y(t) = y
	PUT (box.x(t), box.y(t)), brick
	x = x + 51
	NEXT i
width.level = x
y = y + 21
NEXT n
GOTO get.ready.to.launch

15 'IMPORTANT TO STICK LEVEL NUMBER HERE!!!!

DO
GOSUB mainloop
LOOP WHILE level = 15
GOTO completed.level

