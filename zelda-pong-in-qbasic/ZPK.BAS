'Ryan's Zelda Pong 2000
'THis is my first real game, other than guess number. It is really, really weak and
'crappily coded but it is also has very few lines. I could probably fix it up but it would loose that
'LAME charm that it has.
'it was to mimic zelda game boss (Ganondorf, magic ball and sword firing back and forth)
'get it ;)
'110 lines of code was a lot for me when I wrote it! LMAO!

DECLARE SUB down (vars!)
DECLARE SUB score (character!)
DECLARE SUB up (vars!)

SCREEN 9                              'sets the screen mode
LINE (200, 200)-(220, 250), 2, BF    'tunic
LINE (200, 200)-(220, 220), 14, BF   'head
LINE (220, 205)-(215, 210), 1, BF   'eyes
LINE (220, 215)-(210, 219), 1, BF  'mouth
LINE (200, 200)-(220, 205), 2, BF  'hat
DIM link(200)                         'array to store box in
GET (200, 200)-(220, 250), link             'stores box in array
CIRCLE (10, 10), 10, 14
PAINT (10, 10), 14
DIM eball(25)                         'array to store box in
GET (5, 5)-(15, 15), eball
LINE (100, 100)-(120, 150), 8, BF'grey coat
LINE (100, 100)-(120, 120), 6, BF'head
LINE (100, 105)-(105, 110), 1, BF'eyes
LINE (100, 115)-(110, 119), 1, BF'mouth
DIM ganon(500)                        'array, as for size i guessed
GET (100, 100)-(120, 150), ganon      'stores in array
1 :
CLS                                   'clears the screen
COLOR 2
PRINT "ZPK by Ryan Dickie"
PRINT "If you want a 2 player copy simply change it so that up(2) and down(2) are only called when a key is pressed"
COLOR 4
PRINT ""
PRINT "If you think about it, fighting Ganondorf reminds me"
PRINT "of an old game I used to play."
COLOR 15
PRINT ""
PRINT "Ball doesn't wait after you score. More challenging that way!!!" 'actually too lazy ;)
COLOR 2
PRINT ""
PRINT "Smaller = Faster. Recommended from 400-1200. No letters plz."
INPUT "Enter a Number please:  ", userlength
COLOR 15
PRINT "Press esc to continue"
DO                                    'changes color of sentence
COLOR colors                          'sets the color
IF colors = 15 THEN colors = 1        'max 16 color in this screen mode
LOOP UNTIL INKEY$ = CHR$(27)          'loops until esc key pressed
CLS                                   'clears the screen
COLOR 15                              'sets color to white
hearts = 3                            'sets links heart to 3 hits
hits = 10                             'ganon hearts
LOCATE 1, 1: PRINT "Hits Link has left to make: "; hits
LOCATE 1, 50: PRINT "Hearts Link has left: "; hearts       'same as above
DIM x(3)
DIM y(3)                              'DIM is as in give DIMENSION to
x(1) = 1: y(1) = 30: x(2) = 619: y(2) = 30  '1=link,2=ganon,3=ball
x(3) = x(1) + 20: y(3) = y(1) + 25     'set ball xy to center and right on Link
PUT (x(1), y(1)), link                   'puts link array on the screen
PUT (x(2), y(2)), ganon                'puts ganon
PUT (x(3), y(3)), eball                'reads eball from array and puts it at the coordinates
v = 1
h = 1
amounth = 4
amountv = 1
DO                                     '$ means string
temp$ = INKEY$                         'Inkey$ is key that is currently pressed
IF temp$ = CHR$(0) + CHR$(72) THEN CALL up(1)     'chr$ converts sting$ to ASCII
IF temp$ = CHR$(0) + CHR$(80) THEN CALL down(1)   'arrow keys are a combo of ASCII 0 + another
delays = delays + 1
IF delays = userlength THEN        'smaller # faster ball
GOSUB balldirection
time = time + 1
IF time = 6 THEN
IF h = 1 AND y(3) + 5 < y(2) + 25 THEN CALL up(2)
IF h = 1 AND y(3) > y(2) + 25 THEN CALL down(2)
time = 1
END IF
delays = 0
END IF
LOOP UNTIL temp$ = CHR$(27)                  'loop until esc key pressed
END                                           'ends program

balldirection:                                'handler, like a function
PUT (x(3), y(3)), eball, XOR                  'put contents of array at those coordinates, using Xor conditions (boolean)
IF y(3) > 330 THEN v = 0                      'v is for vertical is v=0 then up
amountv = INT(RND * 6)                        'random integer
IF y(3) < 22 THEN v = 1                        'only goes down if v=1
amountv = INT(RND * 6)                        'random integer
IF x(3) < 5 THEN CALL score(1)                    'if ball is on furthest left
IF x(3) > 620 THEN CALL score(2)
IF x(3) < x(1) + 20 AND y(3) < y(1) + 50 AND y(3) + 10 > y(1) THEN
h = 1
amounth = INT(RND * 4) + 2
END IF
 'if ball atleast as left as paddle, lower than top and higher than bottom
IF x(3) + 10 > x(2) - 1 AND y(3) < y(2) + 50 AND y(3) + 10 > y(2) THEN
h = 0
amounth = INT(RND * 4) + 2
END IF
IF v = 1 THEN y(3) = y(3) + amountv           'add random int to  y
IF v = 0 THEN y(3) = y(3) - amountv           'This section moves ball
IF h = 1 THEN x(3) = x(3) + amounth           'by random y and by 2 x so you get
IF h = 0 THEN x(3) = x(3) - amounth           'const forward speed but rnd speed to match with your paddle
PUT (x(3), y(3)), eball
RETURN                                        'returns to where gosub was called

SUB down (vars)
SHARED y()
SHARED x()
SHARED link()
SHARED ganon()
IF y(vars) + 50 < 340 THEN
IF vars = 1 THEN PUT (x(1), y(1)), link, XOR              'xor is a boolean operater
IF vars = 2 THEN PUT (x(2), y(2)), ganon, XOR             'if it is there, then erases
y(vars) = y(vars) + 20
IF y(vars) + 50 > 340 THEN y(vars) = 340
IF vars = 1 THEN PUT (x(1), y(1)), link               'need to erase in old location
IF vars = 2 THEN PUT (x(2), y(2)), ganon              'before put in new DUH!
END IF
END SUB

SUB score (character)
SHARED x()            'declared shared (global) var with
SHARED y()
SHARED h
SHARED v
SHARED hearts
SHARED hits
IF character = 1 THEN hearts = hearts - 1  'takes a heart away from link
IF character = 2 THEN hits = hits - 1      'takes a heart away from ganon
LOCATE 1, 1: PRINT "Hits Link has left to make: "; hits
LOCATE 1, 50: PRINT "Hearts Link has left: "; hearts
IF hearts = 0 THEN
PRINT "You lost! =:("
t$ = INKEY$ 'clear keys
SLEEP
END
END IF
IF hits = 0 THEN
PRINT "You Won. Ganondorf is no Longer!!! =:)"
t$ = INKEY$ 'clear keys
SLEEP
END
END IF
IF character = 1 THEN
x(3) = x(1) + 20
h = 1
ELSE
x(3) = x(2) - 5
h = 0
END IF
y(3) = y(char) + 23
END SUB

SUB up (vars) :
SHARED y()
SHARED x()
SHARED link()
SHARED ganon()
IF y(vars) > 30 THEN
IF vars = 1 THEN PUT (x(1), y(1)), link, XOR
IF vars = 2 THEN PUT (x(2), y(2)), ganon, XOR
y(vars) = y(vars) - 20
IF y(vars) < 30 THEN y(vars) = 30
IF vars = 1 THEN PUT (x(1), y(1)), link
IF vars = 2 THEN PUT (x(2), y(2)), ganon
END IF
END SUB

