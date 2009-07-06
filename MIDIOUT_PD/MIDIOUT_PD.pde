// Variables: 
byte rawmidi = 0;            // The MIDI note value to be played

void setup() {
  //  Set MIDI baud rate:
  Serial.begin(31250);
}

void loop() {
Serial.read(rawmidi,BYTE);
Serial.print(rawmidi, BYTE);
  
  
}
