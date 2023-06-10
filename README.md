Hand-Eye Coordination Game

Game Modes: Game has two modes.
1. Test Mode:
*Player puts a card in a region.
*LCD displays the region number.

2. Playing mode: Initiated by sliding switch
*Game system randomly generates a number (Displayed on LCD screen).
*Within 4 seconds, player should putcard in randomly generated region.
-Player correctly places card, green LED lights up (scores 2 pts).
-Player puts card in wrong region, red LED lights up (minus 1 pt).
-No card placement, orange LED lights up (0 pts).

*Game ends after six turns.
*Overall score of player s displayed at end of game (for 2 seconds).
-Overall score negative: Red LED lights up.
-Overall score positive: Green LED lights up.

3. Some of the Componets used.
HC-SR04 ultrasonic sensor: Measurement of the region distance.
Atmel Atmega328p microprocessor: Achieve functionality.
8-segment display: Display game score and regions.
SN74LS47N decoder: Converts binary to decimal to be displayed on 8-segment display.

