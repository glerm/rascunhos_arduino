#include "WProgram.h"
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
byte dataArrayRED[10];
byte dataArrayGREEN[10];

void setup() {
  //set pins to output because they are addressed in the main loop
  pinMode(latchPin, OUTPUT);
  Serial.begin(9600);


  //dentro
  dataArrayRED[0] = 34; //11111111
  dataArrayRED[1] = 17; //11111111
  dataArrayRED[2] = 34; //11111111
  dataArrayRED[3] = 17; //11111111
  dataArrayRED[4] = 0; //11111111
  dataArrayRED[5] = 0; //11111111
  dataArrayRED[6] = 0; //11111111
  dataArrayRED[7] = 0; //11111111



  //fora 
  dataArrayGREEN[0] = 3; //11111111
  dataArrayGREEN[1] = 243; //01111111
  dataArrayGREEN[2] = 204; //00111111
  dataArrayGREEN[3] = 243; //00011111
  dataArrayGREEN[4] = 0; //00111111
  dataArrayGREEN[5] = 0; //00111111
  dataArrayGREEN[6] = 0; //00111111
  dataArrayGREEN[7] = 0; //00111111



}

void loop() {


  for (int j = 0; j < 7; j++) {
    //load the light sequence you want from array
    dataRED = dataArrayRED[j];
    dataGREEN = dataArrayGREEN[j];
    //ground latchPin and hold low for as long as you are transmitting
    digitalWrite(latchPin, 0);
    //move 'em out
    shiftOut(dataPin, clockPin, dataGREEN);   
    shiftOut(dataPin, clockPin, dataRED);
    //return the latch pin high to signal chip that it 
    //no longer needs to listen for information
    digitalWrite(latchPin, 1);
    delay(200);
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

  //for each bit in the byte myDataOut\ufffd
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

