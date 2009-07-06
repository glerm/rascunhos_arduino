// The switch is on Arduino pin 10:
#define switchPin 10
// Middle C (MIDI note value 60) is the lowest note we'll play:
#define middleC 60
//  Indicator LED:
#define LEDpin 13

// Variables: 
char note = 0;            // The MIDI note value to be played
int AnalogValue = 0;           // value from the analog input
int lastNotePlayed = 0;   // note turned on when you press the switch
int lastSwitchState = 0;  // state of the switch during previous time through the main loop
int currentSwitchState = 0;

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
  AnalogValue = analogRead(0);
  //  convert to a range from 0 to 127:
  note = AnalogValue/8;
  currentSwitchState = digitalRead(switchPin);
  // Check to see that the switch is pressed:
  if (currentSwitchState == 1) {
    //  check to see that the switch wasn't pressed last time
    //  through the main loop:
    if (lastSwitchState == 0) {
      // set the note value based on the analog value, plus a couple octaves:
     // note = note + 60;
      // start a note playing:
      noteOn(0x90, note, 0x40);
      // save the note we played, so we can turn it off:
      lastNotePlayed = note;
      digitalWrite(LEDpin, HIGH);
    }
  }
    else {   // if the switch is not pressed:
    //  but the switch was pressed last time through the main loop:
    if (lastSwitchState == 1) {
      //  stop the last note played:
      noteOn(0x90, lastNotePlayed, 0x00);
      digitalWrite(LEDpin, LOW);
    }
}

  //  save the state of the switch for next time
  //  through the main loop:
  lastSwitchState = currentSwitchState;
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
