#include "WProgram.h"
//**************************************************************//
//  Name    : shiftOutCode, Predefined Array Style              //
//  Author  : Carlyn Maw, Tom Igoe                           //
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
byte data1;
byte data2;
byte data3;
byte the_byte;
byte dezena[10]={126,18,188,182,210,230,238,50,254,246};


void setup() {
  //set pins to output because they are addressed in the main loop
  pinMode(latchPin, OUTPUT);
  Serial.begin(115200);

}

void loop() {

int x;
int y;
int z;

while (Serial.available() > 0) {

    x=Serial.read();
    
    y=x%10;
    
    z=x-y;
    
    if ((x < 10)){
    data1=dezena[y];
    data2=126;
    data3=126;
    }    
    
    if ((x >= 10) && (x < 100)){
     data1=dezena[y]; 
     data2=dezena[x/10];
     data3=126;
    }
    
    if ((x >= 100) && (x < 1000)){
     data1=dezena[y]; 
     data2=dezena[(x/10)%10];
     data3=dezena[x/100];
    }


    

    
    
    //ground latchPin and hold low for as long as you are transmitting
    digitalWrite(latchPin, 0);
    //move 'em out
    
    shiftOut(dataPin, clockPin, data1); 
    shiftOut(dataPin, clockPin, data2); 
    shiftOut(dataPin, clockPin, data3); 
    //return the latch pin high to signal chip that it 
    //no longer needs to listen for information
    digitalWrite(latchPin, 1);


    
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

