// Variables: 
char note = 0;            // The MIDI note value to be played

void setup() {
  //  Set MIDI baud rate:
  Serial.begin(31250);
}

void loop() {
  // play notes from F#-0 (30) to F#-5 (90):
  for (note = 0; note < 127; note ++) {

    midinote(0x90, 60, 127);
//    midiprog(0xc0,1);
 //   midiprog(0xd0,note);aftertouch
 
 
    delay(100);
 
    midinote(0x80, 60, 0);   
    delay(100);
  }
}

//  plays a MIDI note.  Doesn't check to see that
//  cmd is greater than 127, or that data values are  less than 127:
void midinote(char cmd, char data1, char data2) {
  Serial.print(cmd, BYTE);
  Serial.print(data1, BYTE);
  Serial.print(data2, BYTE);
}

void midibend(char cmd, char data1, char data2) {
  Serial.print(cmd, BYTE);
  Serial.print(data1, BYTE);
  Serial.print(data2, BYTE);
}



void midiprog(char cmd, char data1) {
  Serial.print(cmd, BYTE);
  Serial.print(data1, BYTE);
  
  
}

