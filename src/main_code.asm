.INCLUDE "M328PDEF.INC"
.ORG 0
JMP MAIN
.ORG 0X0002
JMP TIME_ECHO_PULSE
.ORG 0X0004
JMP PLAY_MODE
.ORG 0X000A
JMP START_GAME


MAIN:
    CLR R20
	CLR R24
	CLR R25
    LDI R16,0B11111111
	OUT DDRB,R16
	OUT DDRC,R16
	SBI PORTD,2
	SBI PORTD,3
	SBI PORTB,4
	SBI PORTB,5
	LDI R16,(1<<INT1)|(1<<INT0)
	OUT EIMSK,R16
	LDI R16,0X0D
	STS EICRA,R16
	LDI R16,(1<<PCIE2)
	STS PCICR,R16
	LDI R16,(1<<PCINT23)
	STS PCMSK2,R16

	STAY:
	SEI
	CLR R16
	OUT PORTC,R16
	SLEEP
	RJMP STAY //DO NOTHING UNTIL INTERRUPTED

	START_GAME:
    SEI //ENABLE AN INTERRUPT WITHIN AN INTERRUPT,FOR THE ECHO PIN
    START_TEST:CLR R20// TEST MODE 
	RCALL TRIGGER_SENSOR
	RCALL HALF_SEC_DEL
	OUT PORTC,R24
	RCALL HALF_SEC_DEL
	RCALL HALF_SEC_DEL
	RJMP START_TEST
    RETI

    PLAY_MODE: //PLAY MODE WHWRE RANDOM NUMBER IS GENERATED
	SEI  //ENABLE INTERRUPT TO ENABLE ECH PIN INTERRUPTION
	CLR R20 // //REGEISTER TO MARK RISING AND FALLING EDGE OF ECHO PIN
	CLR R30 //REGISTER TO STORE SCORES 
	LDI R18,2 //FIRST RANDOM VALUE
	SBI PORTB,4 //DEACTIVATE 2ND LED SEGMENT PINS B AND C
	SBI PORTB,5 //DEACTIVATE LED SEGEMENT FOR NEGATIVE SCORES
	START_PLAY:
	ROUND1:OUT PORTC,R18
	       CALL TRIGGER_SENSOR
	       CALL GET_SCORE

	ROUND2:CLR R20
	       INC R18
	       NOP
	       OUT PORTC,R18
	       CALL TRIGGER_SENSOR
	       CALL GET_SCORE

	ROUND3:CLR R20
	       LDI R18,9
	       NOP
	       OUT PORTC,R18
	       CALL TRIGGER_SENSOR
	       CALL GET_SCORE
	
	ROUND4:CLR R20
	       LDI R18,5
		   NOP
	       OUT PORTC,R18
	       CALL TRIGGER_SENSOR
		   CALL GET_SCORE
	
	ROUND5:CLR R20
	       LDI R18,4
		   NOP
	       OUT PORTC,R18
		   CALL TRIGGER_SENSOR
		   CALL GET_SCORE

	ROUND6:CLR R20
	       LDI R18,3
	       NOP
	       OUT PORTC,R18
	       CALL TRIGGER_SENSOR
		   CALL GET_SCORE
		   CALL OVERALL_SCORE
		   RJMP STAY
		
	TRIGGER_DELAY://DELAY FOE 10 MICROSECONDS PULSE
	LDI R16,94
	OUT TCNT0,R16
	LDI R16,0X01
	OUT TCCR0B,R16
	POL:IN R17,TIFR0
	SBRS R17,TOV0
	RJMP POL
	CLR R17
	OUT TCCR0B,R17
	LDI R17,(1<<TOV0)
	OUT TIFR0,R17
	RET

	TIME_ECHO_PULSE://INTERRUPT THAT MONITORS ECHO PIN STARTS
	CLI //DISABLE INTERRUPTION
	INC R20
	CPI R20,2  //1 MEANS RISING EDGE AND 2 MEANS FALLING EDGE
	BREQ STOP_COUNT //IF ITS FALLING EDGE,STOP COUNTING
	LDI R16,0X00//ELSE START COUNTING
	OUT TCNT0,R16
	LDI R16,0X05
	OUT TCCR0B,R16
	RETI

	STOP_COUNT://
	IN R24,TCNT0//UPON STOP COUNTING,READ IN TCNT0 VALUE THAT REPRESENTS DISTANCE MEASURED
	CLR R16
	OUT TCCR0B,R16
	LDI R16,(1<<TOV0)
	OUT TIFR0,R16
	RETI //INTERRUPT THAT MONITORS ECHO PIN STOPS

	TRIGGER_SENSOR:
	    CALL TWO_SEC_DELAY //DELAY TO SMOOTHEN THINGS BEFORE SENDING OUT PULSE
		SBI PORTB,1 //FOR STARTING SENSOR
	    CALL TRIGGER_DELAY //CREATE A 10 MICROSECONDS HIGH PULSE
	    CBI PORTB,1
		RET

	GET_SCORE:
	CALL TWO_SEC_DELAY//SMOOTHEN THINGS
	CPI R24,10 //OUT OF BOUNDS CONDITION
	BRSH NO_PLACEMENT//OUT OF BOUNDS
	CP R18,R24 //COMPARE PLACED VALUE AND MEASURED VALUE
	BREQ CORRECT_PLACEMENT //IF EQUAL BRANCH TO CORRECT FUNCTIONS TO ADD PNTS,LIGHT GREEN LED...
	CALL WRONG_PLACEMENT //PLACED AT WRONG POS
	RET

	WRONG_PLACEMENT:
	SBI PORTB,2 //RED LED SHOWING WRONG PLACEMENT
	CALL HALF_SEC_DEL
	CBI PORTB,2
	DEC R30 //PNTS-1
	RET

	CORRECT_PLACEMENT:
	SBI PORTB,0 //GREEN LED SHOWING RIGHT PLACEMENT
	CALL HALF_SEC_DEL
	CBI PORTB,0
	LDI R25,2
	ADD R30,R25 //ADD TWO POINTS IN EVERY RIGHT PLACEMENT
	RET

	NO_PLACEMENT:
	SBI PORTB,3 //ORANGE LED SHOWING NO PLACEMENT
	CALL HALF_SEC_DEL
	CBI PORTB,3
	RET

TWO_SEC_DELAY:
LDI R17,HIGH(34286)
	STS TCNT1H,R17
	LDI R17,LOW(34286)
	STS TCNT1L,R17
	LDI R16,0X05
	STS TCCR1B,R16
	POL_TOV1:IN R17,TIFR1
	SBRS R17,TOV1
	RJMP POL_TOV1
	LDI R16,0X00
	STS TCCR1B,R16
	LDI R16,0X01
	OUT TIFR1,R16
	RET

HALF_SEC_DEL:
    LDI R17,HIGH(57724)
	STS TCNT1H,R17
	LDI R17,LOW(57724)
	STS TCNT1L,R17
	LDI R16,0X05
	STS TCCR1B,R16
	CHECK_TOV1:IN R17,TIFR1
	SBRS R17,TOV1
	RJMP POL_TOV1
	LDI R16,0X00
	STS TCCR1B,R16
	LDI R16,0X01
	OUT TIFR1,R16
	RET

OVERALL_SCORE://GET TOTAL SCORES
CLR R17
CPI R30,0
BRLT NEG_SCORE//IF SCORE IS NEGATIVE,BRANCH
CPI R30,10
BRSH POS_SCORE_GRTER_THN_9 //IF SCORE GREATER THAN 10,BRANCH
CPI R17,0
BREQ POS_SCORE_BTWN_0_AND_NINE //SCORE POSITIVE BRANCH
RET

POS_SCORE_GRTER_THN_9:
INC R17
LDI R16,10
SUB R30,R16
SBI PORTB,0  //GREEN LED
CBI PORTB,4 //OUTPUT ONE ON TENS SIDE IF SCORE WAS GREATER THAN OR EQUAL TO TEN
OUT PORTC,R30
CALL TWO_SEC_DELAY //OUTPUT SCORES FOR TWO SECONDS
CLR R30
SBI PORTB,4 //OUT
OUT PORTC,R30
CBI PORTB,0
RET

NEG_SCORE:
INC R17
CBI PORTB,5 //PIN TO OUTPUT HYPHAE IF SCORE IS NEGATIVE
LDI R25,0
SUB R25,R30
OUT PORTC,R25
SBI PORTB,2
CALL TWO_SEC_DELAY
CBI PORTB,2
SBI PORTB,5
RET

POS_SCORE_BTWN_0_AND_NINE:OUT PORTC,R30
SBI PORTB,0
CALL TWO_SEC_DELAY
CBI PORTB,0
RET
