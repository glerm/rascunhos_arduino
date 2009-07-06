#include "WProgram.h"
//**************************************************************//
//  Name    : Dual sequencer de leds                           //
//  Author  : Glerm Soares, Carlyn Maw, Tom Igoe               //
//  Date    : 25 Oct, 2006                                      //
//  Version : 1.0                                               //
//  Notes   : Code for using a 74HC595 Shift Register           //
//          : to count from 0 to 255                            //
//****************************************************************

//Pin connected to ST_CP of 74HC595
void setup();
void loop();
void shiftOut(int myDataPin, int myClockPin, byte myDataOut);
int latchPin = 8;
//Pin connected to SH_CP of 74HC595
int clockPin = 12;
////Pin connected to DS of 74HC595
int dataPin = 11;

int switcher= 7;

int val =0;

//holders for infromation you're going to pass to shifting function
byte AZUL;
byte AMARELO;
byte AZUL16[16];
byte AMARELO16[16];

void setup() {
  //set pins to output because they are addressed in the main loop
  pinMode(latchPin, OUTPUT);
  pinMode(switcher, INPUT);


  AZUL16[0] = 1; 
  AZUL16[1] = 2; 
  AZUL16[2] = 4; 
  AZUL16[3] = 8; 
  AZUL16[4] = 16; 
  AZUL16[5] = 32;
  AZUL16[6] = 64; 
  AZUL16[7] = 128; 
  AZUL16[8] = 0; 
  AZUL16[9] = 0; 
  AZUL16[10] = 0; 
  AZUL16[11] = 0; 
  AZUL16[12] = 0; 
  AZUL16[13] = 0;
  AZUL16[14] = 0; 
  AZUL16[15] = 0;


  AMARELO16[0] = 0; 
  AMARELO16[1] = 0; 
  AMARELO16[2] = 0; 
  AMARELO16[3] = 0; 
  AMARELO16[4] = 0; 
  AMARELO16[5] = 0; 
  AMARELO16[6] = 0; 
  AMARELO16[7] = 0; 
  AMARELO16[8] = 1; 
  AMARELO16[9] = 2; 
  AMARELO16[10] = 4; 
  AMARELO16[11] = 8; 
  AMARELO16[12] = 16; 
  AMARELO16[13] = 32; 
  AMARELO16[14] = 64; 
  AMARELO16[15] = 128; 


}

void loop() {
  
val = digitalRead(switcher);  
 
 
  if (val == HIGH) {  


  for (int j = 0; j < 16; j++) {
    //load the light sequence you want from array
    AZUL = AZUL16[j];
    AMARELO = AMARELO16[j];
    //ground latchPin and hold low for as long as you are transmitting
    digitalWrite(latchPin, 0);
    //move 'em out
    shiftOut(dataPin, clockPin, AMARELO);
    shiftOut(dataPin, clockPin, AZUL); 
    //return the latch pin high to signal chip that it 
    //no longer needs to listen for information
    digitalWrite(latchPin, 1);
    delay(analogRead(5));
  }
 }   
    
    else {

  for (int j = 0; j < 8; j++) {
    //load the light sequence you want from array
    AZUL = AZUL16[j];
    AMARELO = AMARELO16[j+8];
    //ground latchPin and hold low for as long as you are transmitting
    digitalWrite(latchPin, 0);
    //move 'em out
    shiftOut(dataPin, clockPin, AMARELO);
    shiftOut(dataPin, clockPin, AZUL);   
    
    //return the latch pin high to signal chip that it 
    //no longer needs to listen for information
    digitalWrite(latchPin, 1);
    delay(analogRead(5));
  } 
  
      
      
  }  
  
}


// the heart of the program
void shiftOut(int myDataPin, int myClockPin, byte myDataOut) {
  // This shifts 8 bits out MSB first, 
  //on the rising edge of the clock,
  //clock idles low

  //internal function setup
  int i=0;
  int pinState;
  pinMode(myClockPin, OUTPUT);
  pinMode(myDataPin, OUTPUT);

  //clear everything out just in case to
  //prepare shift register for bit shifting
  digitalWrite(myDataPin, 0);
  digitalWrite(myClockPin, 0);

  //for each bit in the byte myDataOut\u2026
  //NOTICE THAT WE ARE COUNTING DOWN in our for loop
  //This means that %00000001 or "1" will go through such
  //that it will be pin Q0 that lights. 
  for (i=7; i>=0; i--)  {
    digitalWrite(myClockPin, 0);

    //if the value passed to myDataOut and a bitmask result 
    // true then... so if we are at i=6 and our value is
    // %11010100 it would the code compares it to %01000000 
    // and proceeds to set pinState to 1.
    if ( myDataOut & (1<<i) ) {
      pinState= 1;
    }
    else {	
      pinState= 0;
    }

    //Sets the pin to HIGH or LOW depending on pinState
    digitalWrite(myDataPin, pinState);
    //register shifts bits on upstroke of clock pin  
    digitalWrite(myClockPin, 1);
    //zero the data pin after shift to prevent bleed through
    digitalWrite(myDataPin, 0);
  }

  //stop shifting
  digitalWrite(myClockPin, 0);
}











int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

