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

//holders for infromation you're going to pass to shifting function
byte dataRED;
byte dataGREEN;
byte dataArrayRED[8];
byte dataArrayGREEN[8];

void setup() {
  //set pins to output because they are addressed in the main loop
  pinMode(latchPin, OUTPUT);
  Serial.begin(9600);

  //Arduino doesn't seem to have a way to write binary straight into the code 
  //so these values are in HEX.  Decimal would have been fine, too. 
  dataArrayRED[0] = 1; //11111111
  dataArrayRED[1] = 2; //11111110
  dataArrayRED[2] = 4; //11111100
  dataArrayRED[3] = 8; //11111000
  dataArrayRED[4] = 16; //11110000
  dataArrayRED[5] = 32; //11100000
  dataArrayRED[6] = 64; //11000000
  dataArrayRED[7] = 128; //10000000


  //Arduino doesn't seem to have a way to write binary straight into the code 
  //so these values are in HEX.  Decimal would have been fine, too. 
  dataArrayGREEN[0] = 1; //11111111
  dataArrayGREEN[1] = 2; //01111111
  dataArrayGREEN[2] = 4; //00111111
  dataArrayGREEN[3] = 8; //00011111
  dataArrayGREEN[4] = 16; //00001111
  dataArrayGREEN[5] = 32; //00000111
  dataArrayGREEN[6] = 64; //00000011
  dataArrayGREEN[7] = 128; //00000001


}

void loop() {


  for (int j = 0; j < 16; j++) {
    //load the light sequence you want from array
    
    if (j>8){
    dataRED = dataArrayRED[j];
    }
    else{
    dataGREEN = dataArrayGREEN[int(j/2)];
    }
    digitalWrite(latchPin, 0);
    //move 'em out
    
    if (j<=8){
    shiftOut(dataPin, clockPin, dataGREEN);   
    }
    else
    {    
    shiftOut(dataPin, clockPin, dataRED);
    }
    digitalWrite(latchPin, 1);
    delay(300);
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

