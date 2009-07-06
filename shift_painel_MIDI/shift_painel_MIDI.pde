
//Pin connected to ST_CP of 74HC595
int latchPin = 8;
//Pin connected to SH_CP of 74HC595
int clockPin = 12;
////Pin connected to DS of 74HC595
int dataPin = 11;



// MIDIs: 
char note = 0;            // The MIDI note value to be played
int Anota = 0;           // value from the analog input
int lastNotePlayed = 0;   // note turned on when you press the switch
int lastSwitchState = 0;  // state of the switch during previous time through the main loop
int currentSwitchState = 0;
int last;

////////////////

int pot= 5;
int tempo=0;

//holder for infromation you're going to pass to shifting function
byte data = 0; 



void setup() {
    //  Set MIDI baud rate:
  Serial.begin(31250);
  //set pins to output because they are addressed in the main loop
  pinMode(latchPin, OUTPUT);


}

void loop() {

  Anota = analogRead(0);
  note=Anota/8;
  last = note;
  noteOn(0x90, note, 127);

  
  

tempo=(((analogRead(pot))/4)+100);
 // light each pin one by one using a function A
  for (int j = 0; j < 8; j++) {

    
    
    lightShiftPinA(j);
    tempo=(((analogRead(pot))/4)+50);
  
  delay(tempo);


  }

noteOn(0x90, last, 0x00);



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


//  plays a MIDI note.  Doesn't check to see that
//  cmd is greater than 127, or that data values are  less than 127:
void noteOn(char cmd, char data1, char data2) {
  Serial.print(cmd, BYTE);
  Serial.print(data1, BYTE);
  Serial.print(data2, BYTE);
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


