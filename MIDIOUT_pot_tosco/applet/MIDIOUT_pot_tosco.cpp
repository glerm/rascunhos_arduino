#include "WProgram.h"
// The switch is on Arduino pin 10:
#define switchPin 10
// Middle C (MIDI note value 60) is the lowest note we'll play:
#define middleC 60
//  Indicator LED:
#define LEDpin 13

// Variables: 
void setup();
void loop();
void noteOn(char cmd, char data1, char data2);
void blink(int howManyTimes);
byte note = 0;            // The MIDI note value to be played
int A = 0;           // value from the analog input
int lastNotePlayed = 0;   // note turned on when you press the switch
int lastSwitchState = 0;  // state of the switch during previous time through the main loop
int currentSwitchState = 0;
int last;

void setup() {
  //  set the states of the I/O pins:
  pinMode(switchPin, INPUT);
  pinMode(LEDpin, OUTPUT);
  //  Set MIDI baud rate:
  Serial.begin(31250);
  blink(3);
}

void loop() {
  //  My potentiometer gave a range from 0 to 1023:
  A = analogRead(0);
  //  convert to a range from 0 to 127:
    
      note=A/8;
      last = note;
      noteOn(0x90, note, 0x40);
      // save the note we played, so we can turn it off:
      

      delay(100);
      
      noteOn(0x90, last, 0x00);


}

//  plays a MIDI note.  Doesn't check to see that
//  cmd is greater than 127, or that data values are  less than 127:
void noteOn(char cmd, char data1, char data2) {
  Serial.print(cmd, BYTE);
  Serial.print(data1, BYTE);
  Serial.print(data2, BYTE);
}

// Blinks an LED 3 times
void blink(int howManyTimes) {
  int i;
  for (i=0; i< howManyTimes; i++) {
    digitalWrite(LEDpin, HIGH);
    delay(100);
    digitalWrite(LEDpin, LOW);
    delay(100);
  }
}

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

