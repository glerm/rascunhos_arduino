// Variables: 
char note = 0;            // The MIDI note value to be played
int n=0;
int mul=0;
int penta[]={12,15,17,19,20};

void setup() {
  //  Set MIDI baud rate:
  Serial.begin(31250);
}

void loop() {
  // play notes from F#-0 (30) to F#-5 (90):
  for (note = 0; note < 5; note ++) {
    mul=random(3)+4;
    n=penta[note]*mul;
    //Note on channel 1 (0x90), some note value (note), middle velocity (0x45):
    noteOn(0x90, n, 0x45);
    delay(50);
    //Note on channel 1 (0x90), some note value (note), silent velocity (0x00):
    noteOn(0x90, n, 0x00);   
    delay(50);
  }
}

//  plays a MIDI note.  Doesn't check to see that
//  cmd is greater than 127, or that data values are  less than 127:
void noteOn(char cmd, char data1, char data2) {
  Serial.print(cmd, BYTE);
  Serial.print(data1, BYTE);
  Serial.print(data2, BYTE);
}
