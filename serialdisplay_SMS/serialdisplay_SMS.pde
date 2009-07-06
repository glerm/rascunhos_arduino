/* 
 ---- SimpleMessageSystem 3 digit display Shift OUt ----
 Control Arduino board functions with the following messages:
 
 r a -> read analog pins
 r d -> read digital pins
 w d [pin] [value] -> write digital pin
 w a [pin] [value] -> write analog pin
 s a [pin] [value] -> write analog pin
 
 
 Base: Thomas Ouellet Fredericks 
 Additions: Alexandre Quessy, Glerm Soares
 
 */



#include <SimpleMessageSystem.h> 

//Pin connected to ST_CP of 74HC595
int latchPin = 8;
//Pin connected to SH_CP of 74HC595
int clockPin = 12;
////Pin connected to DS of 74HC595
int dataPin = 11;



void setup() {
  //Start Serial for debuging purposes	
  Serial.begin(115200);
  //set pins to output because they are addressed in the main loop
  pinMode(latchPin, OUTPUT);

}

void loop() {
  
  if (messageBuild() > 0) { // Checks to see if the message is complete and erases any previous messages
    switch (messageGetChar()) { // Gets the first word as a character
    case 'r': // Read pins (analog or digital)
      readpins(); // Call the readpins function
      break; // Break from the switch
    case 'w': // Write pin
      writepin(); // Call the writepin function
    case 's': //7 segments display
    
    //ground latchPin and hold low for as long as you are transmitting
    digitalWrite(latchPin, 0);
    //count up on GREEN LEDs
    shiftOut(dataPin, clockPin, writeseg()); 
    //count down on RED LEDs
    shiftOut(dataPin, clockPin, writeseg());
    shiftOut(dataPin, clockPin, writeseg());
    //return the latch pin high to signal chip that it 
    //no longer needs to listen for information
    digitalWrite(latchPin, 1);
    
    break;
    
    
    
    
    
    
    
    
    }
  }  
    
  
  
  
  
  
  
  










}

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
  

  
  
//byte entry

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

//////////////////////



  















void readpins(){ // Read pins (analog or digital)

  switch (messageGetChar()) { // Gets the next word as a character

    case 'd': // READ digital pins

    messageSendChar('d');  // Echo what is being read
    for (char i=2;i<14;i++) {
      messageSendInt(digitalRead(i)); // Read pins 2 to 13
    }
    messageEnd(); // Terminate the message being sent
    break; // Break from the switch

  case 'a': // READ analog pins

    messageSendChar('a');  // Echo what is being read
    for (char i=0;i<6;i++) {
      messageSendInt(analogRead(i)); // Read pins 0 to 5
    }
    messageEnd(); // Terminate the message being sent

  }

}

void writepin() { // Write pin

    int pin;
  int state;

  switch (messageGetChar()) { // Gets the next word as a character

    case 'a' : // WRITE an analog pin

    pin = messageGetInt(); // Gets the next word as an integer
    state = messageGetInt(); // Gets the next word as an integer
    pinMode(pin, OUTPUT); //Sets the state of the pin to an output
    analogWrite(pin, state); //Sets the PWM of the pin 
    break;  // Break from the switch


    // WRITE a digital pin
  case 'd' : 

    pin = messageGetInt();  // Gets the next word as an integer
    state = messageGetInt();  // Gets the next word as an integer
    pinMode(pin,OUTPUT);  //Sets the state of the pin to an output
    digitalWrite(pin,state);  //Sets the state of the pin HIGH (1) or LOW (0)


  }

}



int writeseg() { // Write 7 segment display
  
  int state;

switch (messageGetChar()) { // Gets the next word as a character

case 'a' : // WRITE an analog pin

    
    state = messageGetInt(); // Gets the next word as an integer
    return state;
    break;  // Break from the switch


    // WRITE a digital pin
case 'b' : 

    
    state = messageGetInt(); // Gets the next word as an integer
    return state;
    break;  // Break from the switch
    
    
case 'c' : 

    
    state = messageGetInt(); // Gets the next word as an integer
    return state;
    break;  // Break from the switch


  }

}





