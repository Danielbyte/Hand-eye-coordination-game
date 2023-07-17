# Hand-Eye Coordination Game <br>

## Game Modes: Game has two modes.<br>
`Test Mode`<br>
- Player puts a card in a region.<br>
- LCD displays the region number.<br>

`Playing mode: Initiated by sliding switch`<br>
- Game system randomly generates a number (Displayed on LCD screen).<br>
- Within 4 seconds, player should putcard in randomly generated region.<br>
- Player correctly places card, green LED lights up (scores 2 pts).<br>
- Player puts card in wrong region, red LED lights up (minus 1 pt).<br>
- No card placement, orange LED lights up (0 pts).<br>

 `Game ends after six turns`<br>
- Overall score of player s displayed at end of game (for 2 seconds).<br>
- Overall score negative: Red LED lights up.<br>
- Overall score positive: Green LED lights up.<br>

### Some of the Componets used<br>
- `HC-SR04 ultrasonic sensor`: Measurement of the region distance.<br>
- `Atmel Atmega328p microprocessor`: Achieve functionality.<br>
- `8-segment display`: Display game score and regions.<br>
- `SN74LS47N decoder`: Converts binary to decimal to be displayed on 8-segment display.<br>

