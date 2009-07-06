//**************************************************************//
//  Name    : shiftOutCode, One By One                          //
//  Author  : Carlyn Maw, Tom Igoe                           //
//  Date    : 25 Oct, 2006                                      //
//  Version : 1.0                                               //
//  Notes   : Code for using a 74HC595 Shift Register           //
//          : to count from 0 to 255                            //
//****************************************************************

//Pin connected to ST_CP of 74HC595
int latchPin = 8;
//Pin connected to SH_CP of 74HC595
int clockPin = 12;
////Pin connected to DS of 74HC595
int dataPin = 11;

int pot= 5;
int tempo=0;

//holder for infromation you're going to pass to shifting function
byte data = 0; 



void setup() {
  //set pins to output because they are addressed in the main loop
  pinMode(latchPin, OUTPUT);


}

void loop() {

  

tempo=(((analogRead(pot))/4)+100);
 // light each pin one by one using a function A
  for (int j = 0; j < 8; j++) {

    
    
    lightShiftPinA(j);
    tempo=(((analogRead(pot))/4)+50);
  
  delay(tempo);


  }




}

//This function uses bitwise math to move the pins up
void lightShiftPinA(int p) {
  //defines a local variable
  int pin;

  //this is line uses a bitwise operator
  //shifting a bit left using << is the same
  //as multiplying the decimal number by two. 
  pin = 1<< p;

  //ground latchPin and hold low for as long as you are transmitting
  digitalWrite(latchPin, 0);
  //move 'em out
  shiftOut(dataPin, clockPin, pin);   
  //return the latch pin high to signal chip that it 
  //no longer needs to listen for information
  digitalWrite(latchPin, 1);

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

  //for each bit in the byte myDataOut…
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


